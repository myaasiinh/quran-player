import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas [ThemeManager] mewarisi [GetxService] yang bertugas mengelola tema (mode gelap atau terang) 
/// dalam aplikasi serta mempertahankan perubahannya di penyimpanan lokal.
class ThemeManager extends GetxService {
  /// Memanggil [ThemeManager] yang tersedia dalam memori pengelolaan instance GetX.
  static ThemeManager get find => Get.find<ThemeManager>();

  /// Mengambil pemanggilan penyimpanan manajer storage lokal.
  StorageManager storage = StorageManager.find;

  /// Indikator reaktif (RxBool) apakah tampilan layar saat ini memakai mode malam.
  RxBool isDark = false.obs;

  /// Memaksa aplikasi menggunakan perwajahan mode gelap.
  void toDarkMode() => isDark.value = true;

  /// Memaksa aplikasi menggunakan perwajahan mode terang (cahaya).
  void toLightMode() => isDark.value = false;

  /// Dipanggil segera setelah servis disuntik ke memori.
  /// Bertugas memuat setting tema terakhir yang disimpan di lokal pengguna.
  @override
  Future<void> onReady() async {
    isDark.value =
        (await storage.getAwait(StorageKey.IS_DARK_THEME) as bool?) ?? false;
    super.onReady();
  }

  /// Secara interaktif mengubah warna tema pengguna (switch toggle) yang diikuti 
  /// aktivitas perekaman preferensi ini ke storage lokal.
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
