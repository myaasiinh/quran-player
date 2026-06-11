import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/extension/context_extension.dart';
import '/ui/widgets/sky_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas [LocaleManager] menangani logika internal aplikasi terkait dengan penanganan 
/// pilihan bahasa, pengambilan preferensi lokalisasi, serta penyimpanannya.
class LocaleManager {
  /// Properti static [find] untuk memanggil instance [LocaleManager] yang hidup pada GetX dependency tree.
  static LocaleManager get find => Get.find<LocaleManager>();

  /// Mengambil instance [StorageManager] guna mendukung operasi tulis dan baca preferensi secara persisten.
  StorageManager storage = StorageManager.find;

  /// Mendefinisikan kamus (Map) berupa daftar bahasa yang dapat didukung sistem.
  /// Kunci (Key) adalah nama tampilan, nilai (Value) adalah referensi objek [Locale].
  final Map<String, Locale> locales = {
    'English': const Locale('en'),
    'Indonesia': const Locale('id'),
  };

  /// Bahasa dasar (fallback) yang digunakan andai konfigurasi bahasa perangkat tak diketahui/tak didukung.
  final fallbackLocale = const Locale('en');

  /// Menampilkan popup interaktif berbentuk dialog bagi pengguna untuk mengganti bahasa antarmuka.
  Future<void> showLocaleDialog(BuildContext context) async {
    // Memunculkan kotak dialog standar pada framework
    await showDialog(
      context: context,
      builder: (context) {
        // Membungkus di dalam komponen UI kustom SkyDialog
        return SkyDialog(
          child: Column(
            // Penempatan elemen ke kiri (start)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teks judul dialog ("Pilih bahasa") beserta styling-nya
              Text(
                'txt_choose_language'.tr,
                style: context.typography.subtitle2,
              ),
              // Memberikan ruang pemisah jarak 16 piksel
              const SizedBox(height: 16),
              // Menghasilkan daftar opsi bahasa yang diambil dari properti locales
              ListView.separated(
                // Mengatur komponen supaya ukurannya membatasi diri menyesuaikan isi item (shrink wrap)
                shrinkWrap: true,
                // Mengunci guliran di daftar ListView karena hanya perlu tampil diam
                physics: const NeverScrollableScrollPhysics(),
                // Sejumlah besar elemen sesuai daftar bahasa yang didukung
                itemCount: locales.length,
                // Pembatas visual tipis antar barisan pilihan bahasa
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1.5),
                // Fungsi pencetak setiap elemen dari bahasa yang dipilih pengguna
                itemBuilder: (context, index) => InkWell(
                  // Ketika salah satu item disorot dan ditekan
                  onTap: () async {
                    // Mengambil nilai [Locale] pada elemen berdasarkan index item
                    final locale = locales.entries.toList()[index].value;
                    // Melakukan update pemakaian bahasa keseluruhan di memori
                    await updateLocale(locale);
                    // Menutup popup dialog setelah proses modifikasi bahasa sukses dilakukan
                    Get.back();
                  },
                  // Berisi ruang di sekeliling nama bahasa beserta styling tipografi tubuh
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

  /// Secara bersamaan memperbarui bahasa internal framework (melalui GetX) dan 
  /// mendaftarkan nilainya pada database persisten aplikasi agar tidak hilang ketika restart.
  Future<void> updateLocale(Locale locale) async {
    // Menyimpan string languageCode ke database penyimpanan aplikasi lokal
    await storage.save(StorageKey.CURRENT_LOCALE, locale.languageCode);
    // Menginformasikan framework GetX secara dinamis memperbarui lokalisasi (rebuild state)
    await Get.updateLocale(locale);
  }

  /// Meminta objek [Locale] yang aktif atau yang ideal digunakan oleh sistem.
  Locale get getCurrentLocale {
    // Mengambil riwayat pengesetan locale bahasa pada storage manager
    final currentLanguageCode =
        storage.get(StorageKey.CURRENT_LOCALE) as String?;
        
    // Memastikan datanya eksis, artinya pengguna pernah mengganti/mendapat bahasa
    if (currentLanguageCode != null) {
      // Melakukan validasi pengembalian object [Locale]
      if (currentLanguageCode == 'en') {
        return const Locale('en');
      } else {
        return const Locale('id');
      }
    } else {
      // Andai string masih null, usahakan membaca format dari OS sistem HP secara langsung,
      // Jika hasil OS ternyata gagal dicerna, andalkan format asali (fallback en)
      return Get.deviceLocale ?? fallbackLocale;
    }
  }
}
