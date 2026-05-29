import 'dart:async';
import 'dart:convert';

import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';

import '/config/auth_manager/auth_state.dart';
import '/config/themes/theme_manager.dart';
import '/core/database/secure_storage/secure_storage_manager.dart';
import '/core/database/storage/cache_data.dart';
import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import 'package:get/get.dart';

class AuthManager extends GetxService {
  static AuthManager get find => Get.find<AuthManager>();

  Rxn<AuthState> authState = Rxn<AuthState>();
  Stream<AuthState?> get stream => authState.stream;
  AuthState? get state => authState.value;

  StorageManager storage = StorageManager.find;
  SecureStorageManager secureStorage = SecureStorageManager.find;
  ThemeManager themeManager = ThemeManager.find;

  @override
  void onInit() {
    authState.value = const AuthState();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    ever(authState, (state) => unawaited(authChanged(state)));
    await authChanged(state);
    super.onReady();
  }

  Future<void> authChanged(AuthState? state) async {
    if (state?.appStatus == AppType.INITIAL) {
      await setup();
      return;
    }

    // For this app, we always go to Home/Surah List after splash
    if (Get.currentRoute != SurahListView.route) {
      Timer(const Duration(seconds: 2), () {
        unawaited(Get.offAllNamed(SurahListView.route));
      });
    }
  }

  Future<void> setup() async {
    await checkAppTheme();
    await clearExpiredCache();
    // Set to unauthenticated to trigger transition to surah list after splash
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  Future<void> clearExpiredCache() async {
    await Future.wait(
      (storage.box.getKeys() as Iterable).map((key) async {
        final permanentKeys = StorageKey.permanentKeys + [StorageKey.USERS];

        if (!permanentKeys.contains(key)) {
          try {
            final now = DateTime.now();
            final storageItem = storage.get(key as String);
            if (storageItem is String) {
              final cacheData = CacheData.fromJson(
                jsonDecode(storageItem) as Map<String, dynamic>,
              );
              if (cacheData.expiredDate.isBefore(now)) {
                await storage.delete(key);
              }
            }
          } catch (e) {}
        }
      }),
    );
  }

  Future<void> checkAppTheme() async {
    final isDarkTheme =
        (await storage.getAwait(StorageKey.IS_DARK_THEME) as bool?) ?? false;
    if (isDarkTheme) {
      themeManager.toDarkMode();
    } else {
      themeManager.toLightMode();
    }
  }

  Future<void> logout() async {
    await clearData();
    authState.value = const AuthState(appStatus: AppType.UNAUTHENTICATED);
  }

  Future<void> clearData() async {
    await secureStorage.logout();
    await storage.logout();
  }
}
