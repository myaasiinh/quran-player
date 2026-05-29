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

/// [AuthManager] adalah orkestrator sesi dan startup flow aplikasi.
/// Principal Engineer Pattern: Bertanggung jawab atas logika routing transisi awal.
class AuthManager extends GetxService {
  static AuthManager get find => Get.find<AuthManager>();

  // State reaktif untuk memantau status autentikasi.
  Rxn<AuthState> authState = Rxn<AuthState>();
  Stream<AuthState?> get stream => authState.stream;
  AuthState? get state => authState.value;

  // Dependensi internal yang dibutuhkan oleh AuthManager.
  StorageManager storage = StorageManager.find;
  SecureStorageManager secureStorage = SecureStorageManager.find;
  ThemeManager themeManager = ThemeManager.find;

  @override
  void onInit() {
    // Inisialisasi state awal aplikasi.
    authState.value = const AuthState();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    // Memantau perubahan authState dan menjalankan callback authChanged.
    ever(authState, (state) => unawaited(authChanged(state)));
    await authChanged(state);
    super.onReady();
  }

  /// [authChanged] menangani logika navigasi berdasarkan status aplikasi.
  Future<void> authChanged(AuthState? state) async {
    if (state?.appStatus == AppType.INITIAL) {
      // Jika status masih INITIAL, jalankan setup infrastruktur.
      await setup();
      return;
    }

    // Principal Note: Untuk aplikasi ini, kita selalu arahkan ke Home/Surah List
    // setelah melewati Splash (setelah delay dekoratif 2 detik).
    if (Get.currentRoute != SurahListView.route) {
      Timer(const Duration(seconds: 2), () {
        unawaited(Get.offAllNamed(SurahListView.route));
      });
    }
  }

  /// Menyiapkan komponen aplikasi sebelum masuk ke UI utama.
  Future<void> setup() async {
    await checkAppTheme();
    await clearExpiredCache();

    // Trigger transisi dengan mengubah status ke UNAUTHENTICATED.
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  /// Membersihkan data cache yang sudah kedaluwarsa secara asinkron.
  Future<void> clearExpiredCache() async {
    await Future.wait(
      (storage.box.getKeys() as Iterable).map((key) async {
        final permanentKeys = StorageKey.permanentKeys;

        if (!permanentKeys.contains(key)) {
          try {
            final now = DateTime.now();
            final storageItem = storage.get(key as String);
            if (storageItem is String) {
              final cacheData = CacheData.fromJson(
                jsonDecode(storageItem) as Map<String, dynamic>,
              );
              // Hapus jika waktu sekarang melewati expired date.
              if (cacheData.expiredDate.isBefore(now)) {
                await storage.delete(key);
              }
            }
          } catch (e) {
            // Error parsing diabaikan karena item cache mungkin tidak valid.
          }
        }
      }),
    );
  }

  /// Sinkronisasi tema aplikasi dengan preferensi yang tersimpan di storage.
  Future<void> checkAppTheme() async {
    final isDarkTheme =
        (await storage.getAwait(StorageKey.IS_DARK_THEME) as bool?) ?? false;
    if (isDarkTheme) {
      themeManager.toDarkMode();
    } else {
      themeManager.toLightMode();
    }
  }

  /// Logika logout untuk membersihkan seluruh sesi dan data sensitif.
  Future<void> logout() async {
    await clearData();
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  /// Pembersihan total storage lokal dan secure storage.
  Future<void> clearData() async {
    await secureStorage.logout();
    await storage.logout();
  }
}
