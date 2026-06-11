import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/extension/context_extension.dart';
import '/ui/widgets/sky_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas manajer untuk menangani pemilihan, pembaruan, dan pengambilan bahasa (Locale) aplikasi.
class LocaleManager {
  /// Mendapatkan instance [LocaleManager] yang telah diinisialisasi pada dependensi Get.
  static LocaleManager get find => Get.find<LocaleManager>();

  // Mengambil instance dari StorageManager untuk membaca dan menyimpan preferensi bahasa
  StorageManager storage = StorageManager.find;

  /// Daftar bahasa yang didukung oleh aplikasi beserta [Locale]-nya.
  final Map<String, Locale> locales = {
    'English': const Locale('en'),
    'Indonesia': const Locale('id'),
  };

  /// Bahasa cadangan (fallback) jika bahasa perangkat tidak ditemukan/didukung.
  final fallbackLocale = const Locale('en');

  /// Menampilkan dialog pop-up yang berisi daftar pilihan bahasa.
  /// Saat dipilih, bahasa aplikasi akan otomatis diubah.
  Future<void> showLocaleDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SkyDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'txt_choose_language'.tr,
                style: context.typography.subtitle2,
              ),
              const SizedBox(height: 16),
              // Daftar item bahasa yang bisa dipilih
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locales.length,
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1.5),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    final locale = locales.entries.toList()[index].value;
                    // Memperbarui bahasa yang dipilih
                    await updateLocale(locale);
                    // Menutup dialog setelah diperbarui
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      locales.entries.toList()[index].key,
                      style: context.typography.body1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Memperbarui bahasa aplikasi secara keseluruhan dan menyimpannya di penyimpanan lokal (storage).
  Future<void> updateLocale(Locale locale) async {
    // Simpan kode bahasa ke penyimpanan lokal agar persisten saat aplikasi dibuka kembali
    await storage.save(StorageKey.CURRENT_LOCALE, locale.languageCode);
    // Perbarui bahasa di tingkat aplikasi melalui package Get
    await Get.updateLocale(locale);
  }

  /// Mendapatkan bahasa ([Locale]) aplikasi yang saat ini sedang aktif.
  /// Jika belum ada preferensi tersimpan, akan menggunakan bahasa sistem perangkat.
  Locale get getCurrentLocale {
    final currentLanguageCode =
        storage.get(StorageKey.CURRENT_LOCALE) as String?;
    if (currentLanguageCode != null) {
      if (currentLanguageCode == 'en') {
        return const Locale('en');
      } else {
        return const Locale('id');
      }
    } else {
      // Jika kosong, gunakan bahasa perangkat, jika tidak bisa, gunakan fallback
      return Get.deviceLocale ?? fallbackLocale;
    }
  }
}
