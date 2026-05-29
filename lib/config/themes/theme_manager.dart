import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/
class ThemeManager extends GetxService {
  static ThemeManager get find => Get.find<ThemeManager>();

  StorageManager storage = StorageManager.find;

  RxBool isDark = false.obs;

  void toDarkMode() => isDark.value = true;

  void toLightMode() => isDark.value = false;

  @override
  Future<void> onReady() async {
    isDark.value =
        (await storage.getAwait(StorageKey.IS_DARK_THEME) as bool?) ?? false;
    super.onReady();
  }

  Future<Rx<bool>> changeTheme() async {
    if (isDark.isTrue) {
      await storage.save(StorageKey.IS_DARK_THEME, false);
      isDark.value = false;
    } else {
      await storage.save(StorageKey.IS_DARK_THEME, true);
      isDark.value = true;
    }
    return isDark;
  }
}
