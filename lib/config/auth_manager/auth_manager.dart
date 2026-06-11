import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:quran_player/config/auth_manager/auth_state.dart';
import 'package:quran_player/config/themes/theme_manager.dart';
import 'package:quran_player/core/database/secure_storage/secure_storage_manager.dart';
import 'package:quran_player/core/database/storage/cache_data.dart';
import 'package:quran_player/core/database/storage/storage_key.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';

/// [AuthManager] adalah service untuk mengatur state autentikasi 
/// serta alur startup awal aplikasi secara keseluruhan.
/// Principal Engineer Pattern: Bertanggung jawab atas logika routing transisi awal.
class AuthManager extends GetxService {
  /// Mendapatkan instance [AuthManager] yang teregistrasi melalui dependensi injeksi GetX.
  static AuthManager get find => Get.find<AuthManager>();

  /// State reaktif internal yang mengawasi status autentikasi aplikasi saat ini.
  Rxn<AuthState> authState = Rxn<AuthState>();
  
  /// Stream yang memberikan aliran data terbaru jika ada pembaruan pada status autentikasi.
  Stream<AuthState?> get stream => authState.stream;
  
  /// Mengambil nilai langsung dari status autentikasi saat ini tanpa berlangganan stream.
  AuthState? get state => authState.value;

  /// Ketergantungan manajer penyimpanan umum.
  StorageManager storage = StorageManager.find;
  
  /// Ketergantungan manajer penyimpanan yang aman (terenkripsi).
  SecureStorageManager secureStorage = SecureStorageManager.find;
  
  /// Ketergantungan manajer pengubah tema aplikasi.
  ThemeManager themeManager = ThemeManager.find;

  /// Metode siklus hidup bawaan GetX yang dipanggil sesaat sebelum service diinisialisasi penuh.
  @override
  void onInit() {
    // Mengatur state awal aplikasi dengan nilai bawaan dari AuthState.
    authState.value = const AuthState();
    // Memanggil metode induk.
    super.onInit();
  }

  /// Metode siklus hidup bawaan GetX yang dipanggil ketika service sudah siap dipakai.
  @override
  Future<void> onReady() async {
    // Berlangganan penuh terhadap objek reaktif authState.
    // Jika authState berubah, maka fungsi authChanged akan dijalankan.
    ever(authState, (state) => unawaited(authChanged(state)));
    // Melakukan evaluasi segera pada saat pertama kali dimuat.
    await authChanged(state);
    // Memanggil metode induk.
    super.onReady();
  }

  /// [authChanged] mengontrol transisi antarmuka pengguna sesuai dengan status yang berlaku.
  /// Ini memastikan pengalihan rute berjalan benar (misal dari splash ke utama).
  Future<void> authChanged(AuthState? state) async {
    // Apabila tipe aplikasi masih initial (baru berjalan)
    if (state?.appStatus == AppType.INITIAL) {
      // Jalankan fungsi pengaturan infrastruktur dasar.
      await setup();
      return;
    }

    // Principal Note: Untuk aplikasi ini, pengguna selalu akan diarahkan ke halaman Surah List
    // sesudah melewati layar Splash dengan tambahan jeda visual selama 2 detik.
    
    // Mengecek apakah rute saat ini belum ada di tampilan SurahListView
    if (Get.currentRoute != SurahListView.route) {
      // Menyiapkan timer tunda selama 2 detik
      Timer(const Duration(seconds: 2), () {
        // Melakukan navigasi ulang menghapus rute sebelumnya ke halaman SurahListView
        unawaited(Get.offAllNamed(SurahListView.route));
      });
    }
  }

  /// Mempersiapkan keperluan infrastruktur dasar sesaat sebelum interaksi pengguna dilakukan.
  Future<void> setup() async {
    // Mengecek lalu menetapkan tema berdasarkan konfigurasi lokal tersimpan.
    await checkAppTheme();
    // Mengeksekusi rutinitas penghapusan chace yang sudah usang.
    await clearExpiredCache();

    // Memperbarui status state menjadi unauthenticated untuk memicu pergerakan rute di `authChanged`.
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  /// Membersihkan penyimpanan memori chace dari data yang masanya telah berlalu (kedaluwarsa).
  Future<void> clearExpiredCache() async {
    // Menjalankan pengecekan secara konkuren pada seluruh key memori
    await Future.wait(
      (storage.box.getKeys() as Iterable).map((key) async {
        // Mendapatkan kunci-kunci permanen yang tidak boleh dihapus
        final permanentKeys = StorageKey.permanentKeys;

        // Jika kunci bukan termasuk kunci permanen
        if (!permanentKeys.contains(key)) {
          try {
            // Waktu saat ini sebagai pembanding
            final now = DateTime.now();
            // Mengambil item penyimpanan terkait dari box
            final storageItem = storage.get(key as String);
            
            // Apabila nilainya string, ada kemungkinan ini adalah data berformat CacheData JSON
            if (storageItem is String) {
              // Parsing JSON menjadi objek CacheData
              final cacheData = CacheData.fromJson(
                jsonDecode(storageItem) as Map<String, dynamic>,
              );
              // Lakukan komparasi: jika expiredDate kurang dari waktu sekarang, maka hapus
              if (cacheData.expiredDate.isBefore(now)) {
                await storage.delete(key);
              }
            }
          } catch (e) {
            // Jika terdapat error parsing data, abaikan saja karena mungkin bentuk datanya lain
          }
        }
      }),
    );
  }

  /// Melakukan sinkronisasi mode tema UI dengan preferensi dari penyimpanan aplikasi lokal.
  Future<void> checkAppTheme() async {
    // Membaca pengaturan tema boolean dari storage
    final isDarkTheme =
        (await storage.getAwait(StorageKey.IS_DARK_THEME) as bool?) ?? false;
    
    // Apabila disetel gelap, rubah manager ke mode gelap
    if (isDarkTheme) {
      themeManager.toDarkMode();
    } else {
      // Bila terang (atau default), rubah manager ke mode terang
      themeManager.toLightMode();
    }
  }

  /// Proses logout pengguna untuk menyetel status otentikasi kembali tidak berwenang.
  Future<void> logout() async {
    // Membersihkan data riwayat login dan rahasia lainnya
    await clearData();
    // Memperbarui status aplikasi
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  /// Pembersihan keseluruhan konten penyimpanan baik standar maupun terenkripsi.
  Future<void> clearData() async {
    // Menghapus data sensitif di secure storage
    await secureStorage.logout();
    // Menghapus rekaman biasa di storage box lokal
    await storage.logout();
  }
}
