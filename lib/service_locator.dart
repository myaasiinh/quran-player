import 'dart:io';
import 'package:quran_player/core/helper/app_logger.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/repositories/quran/quran_repository_impl.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources_impl.dart';

import '/config/environment/app_env.dart';
import '/config/environment/config_data.dart';

import '/config/app/app_info.dart';
import '/config/auth_manager/auth_manager.dart';
import '/config/network/api_config.dart';
import '/config/themes/theme_manager.dart';
import '/core/database/secure_storage/secure_storage_manager.dart';
import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/helper/orientation_helper.dart';
import '/core/localization/locale_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

class ServiceLocator {
  static Future<void> init() async {
    AppLogger.debug('Initializing Service Locator...');

    await AppOrientation.lock([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await AppInfo.init();

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

    await _initStorage();
    Get
      ..put(const FlutterSecureStorage())
      ..lazyPut(DioClient.new)
      ..lazyPut(StorageManager.new)
      ..lazyPut(SecureStorageManager.new)
      ..lazyPut(ThemeManager.new)
      ..lazyPut(LocaleManager.new)
      ..put(AuthManager())
      ..lazyPut<QuranSources>(QuranSourcesImpl.new)
      ..lazyPut<QuranRepository>(() => QuranRepositoryImpl(remote: Get.find()));
  }

  static Future<void> _initStorage() async {
    late final GetStorage storage;
    if (Platform.isIOS) {
      final dir = await getLibraryDirectory();
      storage = GetStorage(StorageKey.STORAGE_NAME, dir.path);
    } else {
      storage = GetStorage(StorageKey.STORAGE_NAME);
    }
    await storage.initStorage;
    Get.put(storage);
  }
}
