import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_player/config/app/app_info.dart';
import 'package:quran_player/config/auth_manager/auth_manager.dart';
import 'package:quran_player/config/environment/app_env.dart';
import 'package:quran_player/config/environment/config_data.dart';
import 'package:quran_player/config/network/api_config.dart';
import 'package:quran_player/config/themes/theme_manager.dart';
import 'package:quran_player/core/database/secure_storage/secure_storage_manager.dart';
import 'package:quran_player/core/database/storage/storage_key.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/core/helper/app_logger.dart';
import 'package:quran_player/core/helper/orientation_helper.dart';
import 'package:quran_player/core/localization/locale_manager.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/repositories/quran/quran_repository_impl.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources_impl.dart';

/// [ServiceLocator] bertanggung jawab untuk mengelola seluruh registrasi dan injeksi dependensi aplikasi.
/// Principal Note: Kelas ini menggunakan package `GetX` sebagai penyedia Dependency Injection (DI) container
/// guna memastikan setiap modul siap pakai.
class ServiceLocator {
  /// Fungsi statis [init] bertugas menjalankan seluruh urutan inisialisasi dependensi inti secara ketat.
  /// Urutan pemanggilan ini sangat krusial untuk dipatuhi demi mencegah terjadinya startup race conditions (saling mendahului).
  static Future<void> init() async {
    // Mencetak log debugging untuk menandakan dimulainya proses inisialisasi Service Locator.
    AppLogger.debug('Initializing Service Locator...');

    // 1. Kunci orientasi perangkat.
    // Memastikan orientasi aplikasi selalu berada pada mode Portrait, baik menghadap atas maupun bawah.
    await AppOrientation.lock([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 2. Inisialisasi metadata aplikasi.
    // Menjalankan fungsi untuk mengekstrak versi, build number, dan identitas paket.
    await AppInfo.init();

    // 3. Konfigurasi Environment berdasarkan flavor saat runtime aplikasi dijalankan.
    // Melakukan pemeriksaan tipe lingkungan yang sedang aktif untuk menentukan URL dan konfigurasi lainnya.
    switch (AppEnv.env) {
      case Environment.PRODUCTION:
        // Set konfigurasi untuk mode produksi sungguhan (Real/Live).
        AppEnv.set(
          environment: Environment.PRODUCTION,
          configuration: ConfigData.prod,
        );
      case Environment.STAGING:
        // Set konfigurasi untuk mode staging (Testing Internal).
        AppEnv.set(
          environment: Environment.STAGING,
          configuration: ConfigData.stg,
        );
      case Environment.DEVELOPMENT:
        // Set konfigurasi untuk mode pengembangan lokal (Development).
        AppEnv.set(
          environment: Environment.DEVELOPMENT,
          configuration: ConfigData.dev,
        );
    }

    // 4. Inisialisasi mekanisme penyimpanan data lokal.
    // Mengonfigurasi `GetStorage` untuk menyimpan key-value statis.
    await _initStorage();

    // 5. Registrasi dependensi utilitas inti aplikasi menggunakan `Get.put` dan `Get.lazyPut`.
    // Menggunakan lazyPut untuk optimasi alokasi memori (kelas baru diinstansiasi hanya saat pertama kali diakses).
    Get
      // Mendaftarkan objek penyimpanan aman (Secure Storage) secara instan.
      ..put(const FlutterSecureStorage())
      // Mendaftarkan instance klien API jaringan HTTP (Dio).
      ..lazyPut(DioClient.new)
      // Mendaftarkan pengelola Storage biasa.
      ..lazyPut(StorageManager.new)
      // Mendaftarkan pengelola Secure Storage terenkripsi.
      ..lazyPut(SecureStorageManager.new)
      // Mendaftarkan pengelola Tema UI aplikasi.
      ..lazyPut(ThemeManager.new)
      // Mendaftarkan pengelola lokalisasi dan bahasa aplikasi.
      ..lazyPut(LocaleManager.new)
      // Mendaftarkan pengelola status Autentikasi secara instan karena dipantau langsung.
      ..put(AuthManager())

      // 6. Registrasi Layer Data (Data Sources & Repositories).
      // Memetakan antarmuka API service Quran dari implementasinya.
      ..lazyPut<QuranSources>(QuranSourcesImpl.new)
      // Memetakan Repository Quran yang bergantung pada Data Source jarak jauh, dieksekusi secara injeksi otomatis dari `Get.find`.
      ..lazyPut<QuranRepository>(
        () => QuranRepositoryImpl(remote: Get.find()),
      );
  }

  /// Fungsi internal statik pembantu [initStorage] ini bertujuan memulai inisialisasi awal mekanisme penyimpanan persisten key-value lokal.
  static Future<void> _initStorage() async {
    // Variabel penampung instance GetStorage khusus untuk OS ini.
    late final GetStorage storage;
    
    // Melakukan percabangan logika untuk menengahi perbedaan tata cara penyimpanan iOS.
    if (Platform.isIOS) {
      // Perangkat Apple iOS memerlukan peletakan ke library directory aplikasi secara khusus untuk persistence.
      final dir = await getLibraryDirectory();
      // Melakukan inisialisasi Storage GetX menunjuk file dan jalur tersebut.
      storage = GetStorage(StorageKey.STORAGE_NAME, dir.path);
    } else {
      // Jika Android atau OS lain, instansiasi standar di directory default yang sudah ditangani GetStorage secara native.
      storage = GetStorage(StorageKey.STORAGE_NAME);
    }
    // Menjalankan inisiasi awaitable pembacaan disk pertama kali.
    await storage.initStorage;
    // Menginjeksi referensi GetStorage yang telah matang ke dalam sistem Service Locator GetX.
    Get.put(storage);
  }
}
