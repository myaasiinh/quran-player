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

/// [ServiceLocator] bertanggung jawab mengelola seluruh dependensi aplikasi.
/// Menggunakan GetX sebagai Dependency Injection (DI) container.
class ServiceLocator {
  /// [init] menjalankan urutan inisialisasi dependensi yang ketat.
  /// Urutan ini sangat krusial untuk mencegah startup race conditions.
  static Future<void> init() async {
    AppLogger.debug('Initializing Service Locator...');

    // 1. Kunci orientasi perangkat.
    await AppOrientation.lock([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 2. Inisialisasi metadata aplikasi (version, build number).
    await AppInfo.init();

    // 3. Konfigurasi Environment berdasarkan flavor saat runtime.
    switch (AppEnv.env) {
      case Environment.PRODUCTION:
        AppEnv.set(
          environment: Environment.PRODUCTION,
          configuration: ConfigData.prod,
        );
      case Environment.STAGING:
        AppEnv.set(
          environment: Environment.STAGING,
          configuration: ConfigData.stg,
        );
      case Environment.DEVELOPMENT:
        AppEnv.set(
          environment: Environment.DEVELOPMENT,
          configuration: ConfigData.dev,
        );
    }

    // 4. Inisialisasi penyimpanan lokal (GetStorage).
    await _initStorage();

    // 5. Registrasi dependensi inti (Get.put & Get.lazyPut).
    // Menggunakan lazyPut untuk optimasi memori (instansiasi saat dibutuhkan).
    Get
      ..put(const FlutterSecureStorage())
      ..lazyPut(DioClient.new)
      ..lazyPut(StorageManager.new)
      ..lazyPut(SecureStorageManager.new)
      ..lazyPut(ThemeManager.new)
      ..lazyPut(LocaleManager.new)
      ..put(AuthManager())

      // 6. Registrasi Layer Data (Sources & Repositories).
      ..lazyPut<QuranSources>(QuranSourcesImpl.new)
      ..lazyPut<QuranRepository>(
        () => QuranRepositoryImpl(remote: Get.find()),
      );
  }

  /// Inisialisasi mekanisme penyimpanan lokal berbasis key-value.
  static Future<void> _initStorage() async {
    late final GetStorage storage;
    if (Platform.isIOS) {
      // iOS memerlukan library directory khusus untuk persistence.
      final dir = await getLibraryDirectory();
      storage = GetStorage(StorageKey.STORAGE_NAME, dir.path);
    } else {
      storage = GetStorage(StorageKey.STORAGE_NAME);
    }
    await storage.initStorage;
    Get.put(storage);
  }
}
