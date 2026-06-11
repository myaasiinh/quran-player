import '/ui/widgets/platform_loading_indicator.dart';
import '/ui/widgets/sky_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Kelas utilitas [LoadingDialog] digunakan untuk menampilkan dialog indikator proses (loading).
/// 
/// Kelas ini mempermudah pemanggilan dialog loading di manapun tanpa harus
/// membuat instance widget baru secara manual setiap saat.
class LoadingDialog {
  /// Menampilkan dialog loading kustom dengan latar belakang layar semi-transparan.
  /// 
  /// [dismissible] menentukan apakah dialog dapat ditutup secara paksa oleh pengguna
  /// dengan mengetuk area kosong di luar kotak loading. Default adalah false (tidak bisa ditutup).
  static Future<T?> show<T>({bool? dismissible}) {
    // Memanggil fungsi bawaan showGeneralDialog dengan pengaturan khusus
    return showGeneralDialog<T>(
      // Menggunakan konteks layar global yang dikelola oleh GetX
      context: Get.context!,
      // Label semantik untuk barrier (latar belakang luar)
      barrierLabel: 'Barrier',
      // Mengatur apakah layar luar dapat diklik untuk menutup (default false)
      barrierDismissible: dismissible ?? false,
      // Memberikan warna gelap dengan transparansi/alpha 0.5 di belakang dialog
      barrierColor: Colors.black.withValues(alpha: 0.5),
      // Fungsi untuk membangun tampilan dialog itu sendiri
      pageBuilder: (context, animation, secondaryAnimation) {
        // Meletakkan elemen tepat di tengah layar
        return Center(
          // Membungkus loading ke dalam sebuah kotak (container)
          child: Container(
            // Menentukan tinggi dan lebar kotak loading agar persegi dan konsisten
            height: 80,
            width: 80,
            // Dekorasi tampilan kotak loading
            decoration: BoxDecoration(
              // Menggunakan warna latar dari scaffold global (beradaptasi mode gelap/terang)
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              // Memberikan lengkungan (radius 12 piksel) pada ujung kotak
              borderRadius: BorderRadius.circular(12),
            ),
            // Memberi jarak bagian dalam antara pinggir kotak dengan indikator putar
            padding: const EdgeInsets.all(16),
            // Menggunakan widget loading indikator yang secara otomatis beradaptasi dengan platform (Material/Cupertino)
            child: const PlatformLoadingIndicator(),
          ),
        );
      },
    );
  }

  /// Menutup dialog loading yang saat ini sedang tampil di layar.
  /// 
  /// Menjalankan [Get.back] untuk menghapus rute paling atas (dalam hal ini dialog).
  static void dismiss() => Get.back();
}

/// Kelas helper [DialogHelper] untuk memudahkan pemanggilan berbagai jenis peringatan (alert)
/// dan pesan sistem dalam bentuk dialog modal.
/// 
/// Terdiri dari metode terstruktur untuk dialog peringatan kegagalan, kesuksesan, informasi, dan paksaan.
class DialogHelper {
  /// Menampilkan dialog peringatan untuk operasi yang berakhir gagal (Failed).
  /// 
  /// Menerima [message] sebagai pesan utama. Dapat juga dikustomisasi dengan parameter opsional
  /// seperti [header], [title], fungsi [onConfirm], dan [isDismissible].
  static Future<T?> failed<T>({
    required String message,
    VoidCallback? onConfirm,
    Widget? header,
    bool? isDismissible,
    String? title,
  }) {
    // Menampilkan dialog reguler
    return showDialog<T>(
      // Mengatur apakah ketukan luar diizinkan (default: bisa ditutup)
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      // Menggunakan desain peringatan dialog Error yang sudah dibakukan di aplikasi
      builder: (context) => DialogAlert.error(
        header: header,
        // Menggunakan judul kustom atau fallback ke terjemahan bawaan untuk gagal
        title: title ?? 'txt_failed'.tr,
        // Menyematkan deskripsi pesan utama
        description: message,
        // Aksi saat tombol ditekan (kembali standar jika tidak diset)
        onConfirm: onConfirm ?? dismiss,
        isDismissible: isDismissible ?? true,
      ),
    );
  }

  /// Menampilkan dialog peringatan untuk operasi yang berjalan dengan berhasil (Success).
  /// 
  /// Membutuhkan callback eksekusi [onConfirm] saat pengguna menekan tombol pada dialog.
  /// Secara default pengguna tidak dapat menutup dialog sukses tanpa menekan tombol.
  static Future<T?> success<T>({
    required String message,
    required VoidCallback onConfirm,
    Widget? header,
    bool? isDismissible,
    String? title,
  }) {
    // Menampilkan dialog konfirmasi sukses
    return showDialog<T>(
      // Dialog sukses sengaja dibuat tidak bisa ditutup secara sembarangan secara default
      barrierDismissible: isDismissible ?? false,
      context: Get.context!,
      // Menggunakan widget alert versi Sukses (berwarna hijau atau konfirmasi positif)
      builder: (context) => DialogAlert.success(
        header: header,
        // Mengambil teks "Berhasil" dari fail translasi
        title: title ?? 'txt_success'.tr,
        description: message,
        onConfirm: onConfirm,
        isDismissible: isDismissible ?? false,
      ),
    );
  }

  /// Menampilkan dialog peringatan berupa teguran, konfirmasi ganda, atau info (Warning).
  /// 
  /// Mendukung fungsi tombol ganda: tombol setuju/lanjut ([onConfirm]) dan tombol tolak/batal ([onCancel]).
  static Future<T?> warning<T>({
    required String message,
    required VoidCallback onConfirm,
    Widget? header,
    bool? isDismissible,
    String? title,
    String? confirmText,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    // Menampilkan dialog interaktif peringatan
    return showDialog<T>(
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      // Menggunakan desain widget peringatan kuning/oranye
      builder: (context) => DialogAlert.warning(
        header: header,
        isDismissible: isDismissible ?? false,
        // Judul default diatur dengan terjemahan Peringatan
        title: title ?? 'txt_warning'.tr,
        description: message,
        // Menangani persetujuan dari dialog
        onConfirm: onConfirm,
        // Kustomisasi teks konfirmasi (misal "Ya, Lanjutkan")
        confirmText: confirmText,
        // Menangani penolakan (jika tidak ada akan ditutup biasa)
        onCancel: onCancel ?? dismiss,
        // Kustomisasi teks penolakan (misal "Batal")
        cancelText: cancelText,
      ),
    );
  }

  /// Menampilkan dialog peringatan untuk menyarankan tindakan percobaan ulang (Retry).
  /// 
  /// Berguna saat terjadi masalah jaringan, API gagal memuat, dan pengguna perlu diberi
  /// pilihan untuk memuat ulang data.
  static Future<T?> retry<T>({
    required String message,
    required VoidCallback onConfirm,
    bool? isDismissible,
    Widget? header,
    String? title,
    String? confirmText,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    // Menampilkan dialog percobaan ulang
    return showDialog<T>(
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      // Menggunakan layout dialog retry
      builder: (context) => DialogAlert.retry(
        header: header,
        // Memakai title kustom atau teks default gagal
        title: title ?? 'txt_failed'.tr,
        description: message,
        confirmText: confirmText,
        cancelText: cancelText,
        // Fungsi untuk mengulangi aksi
        onConfirm: onConfirm,
        // Fungsi batal jika tidak jadi mencoba ulang
        onCancel: onCancel ?? dismiss,
        isDismissible: isDismissible ?? true,
      ),
    );
  }

  /// Menampilkan dialog peringatan yang memaksa pengguna untuk mengambil tindakan (Force).
  /// 
  /// Jenis dialog ini sama sekali tidak bisa ditutup secara otomatis/casual
  /// kecuali pengguna benar-benar mengeklik tombol yang ada.
  static Future<T?> force<T>({
    required String message,
    required VoidCallback onConfirm,
    bool? isDismissible,
    Widget? header,
    String? title,
    VoidCallback? onCancel,
    String? confirmText,
  }) {
    // Menampilkan dialog pemaksaan
    return showDialog<T>(
      // [barrierDismissible] dibuat bernilai false mutlak agar ketukan area latar tidak berefek apa-apa
      barrierDismissible: false,
      context: Get.context!,
      // Mengambil widget untuk format peringatan paksaan
      builder: (context) => DialogAlert.force(
        header: header,
        title: title ?? 'txt_warning'.tr,
        description: message,
        onConfirm: onConfirm,
        onCancel: onCancel ?? dismiss,
        // Jika tidak diisi, teks konfirmasi otomatis bernama 'OK'
        confirmText: confirmText ?? 'OK',
        // Sama, tidak boleh ditutup tanpa aksi
        isDismissible: isDismissible ?? false,
      ),
    );
  }

  /// Fungsi cepat untuk menutup dialog yang saat ini sedang aktif (pop route).
  static void dismiss() => Get.back();
}
