/// Widget dialog kustom yang menampilkan konten [child] di dalam kotak dialog
/// dengan gaya yang konsisten.
///
/// Dialog ini memiliki latar belakang transparan dan mendukung mode gelap/terang
/// untuk warna latar belakang konten.
import 'package:quran_player/ui/widgets/sky_appbar.dart';
/* author
   myaasiinh@gmail.com
*/

import '/config/themes/app_colors.dart';
import '/core/extension/context_extension.dart';
import '/ui/widgets/sky_button.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkyDialog extends StatelessWidget {
  /// Membuat instance [SkyDialog].
  ///
  /// Parameter [child] adalah widget yang akan ditampilkan di dalam dialog.
  /// [padding] dan [margin] bersifat opsional untuk menyesuaikan tata letak konten.
  const SkyDialog({required this.child, super.key, this.padding, this.margin});

  /// Widget yang akan ditampilkan sebagai konten utama di dalam dialog.
  final Widget child;

  /// Padding opsional untuk konten di dalam dialog.
  /// Jika tidak disediakan, akan menggunakan padding default.
  final EdgeInsetsGeometry? padding;

  /// Margin opsional untuk kotak konten dialog.
  /// Jika tidak disediakan, akan menggunakan margin default (hanya di bagian atas).
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Bentuk dialog dengan sudut membulat.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Tidak ada elevasi untuk dialog.
      elevation: 0,
      // Latar belakang dialog transparan.
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Wrap(
            children: [
              Container(
                // Menggunakan padding yang diberikan atau padding default.
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                // Menggunakan margin yang diberikan atau margin default (hanya di bagian atas).
                margin: margin ?? const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  // Warna latar belakang konten dialog, menyesuaikan mode gelap/terang.
                  color: (Get.isDarkMode) ? Colors.black : Colors.white,
                  // Sudut membulat untuk kotak konten.
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      // Warna bayangan, menyesuaikan mode gelap/terang.
                      color:
                          (Get.isDarkMode) ? AppColors.primary : Colors.black,
                      // Radius blur untuk bayangan.
                      blurRadius: 10,
                    ),
                  ],
                ),
                // Menampilkan widget anak yang diberikan.
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget dialog peringatan kustom yang menampilkan judul, deskripsi,
/// header ikonik, dan tombol konfirmasi/batal.
///
/// Menyediakan beberapa konstruktor pabrik untuk jenis peringatan umum
/// seperti sukses, error, warning, retry, dan force.
class DialogAlert extends StatelessWidget {
  /// Membuat instance [DialogAlert].
  ///
  /// Parameter wajib:
  /// - [title]: Judul dialog.
  /// - [description]: Deskripsi atau pesan utama dialog.
  /// - [header]: Widget yang ditampilkan di bagian atas dialog (biasanya ikon).
  /// - [onConfirm]: Callback yang dipanggil saat tombol konfirmasi ditekan.
  /// - [backgroundColorHeader]: Warna latar belakang untuk header (ikon).
  /// - [isDismissible]: Menentukan apakah dialog dapat ditutup dengan mengetuk di luar atau tombol kembali.
  ///
  /// Parameter opsional:
  /// - [onCancel]: Callback yang dipanggil saat tombol batal ditekan.
  /// - [confirmText]: Teks untuk tombol konfirmasi (default 'Ya').
  /// - [cancelText]: Teks untuk tombol batal.
  /// - [confirmColor]: Warna untuk tombol konfirmasi.
  /// - [cancelColor]: Warna untuk tombol batal.
  const DialogAlert({
    required this.title,
    required this.description,
    required this.header,
    required this.onConfirm,
    required this.backgroundColorHeader,
    required this.isDismissible,
    super.key,
    this.onCancel,
    this.confirmText = 'Ya',
    this.cancelText,
    this.confirmColor,
    this.cancelColor,
  });

  /// Konstruktor pabrik untuk dialog peringatan sukses.
  /// Menampilkan ikon sukses secara default.
  factory DialogAlert.success({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          // Menggunakan header yang diberikan atau ikon sukses default.
          child: header ??
              const SkyImage(src: AppIcons.icSuccess, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        // Menggunakan warna latar belakang header yang diberikan atau warna scaffold default.
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
        // Warna tombol konfirmasi default untuk sukses adalah hijau.
        confirmColor: Colors.green,
      );

  /// Konstruktor pabrik untuk dialog peringatan error.
  /// Menampilkan ikon gagal secara default.
  factory DialogAlert.error({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          // Menggunakan header yang diberikan atau ikon gagal default.
          child: header ??
              const SkyImage(src: AppIcons.icFailed, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        // Menggunakan warna latar belakang header yang diberikan atau warna scaffold default.
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
        // Warna tombol konfirmasi default untuk error adalah merah.
        confirmColor: Colors.red[700],
      );

  /// Konstruktor pabrik untuk dialog peringatan umum (warning).
  /// Menampilkan ikon peringatan secara default dan mendukung tombol batal.
  factory DialogAlert.warning({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required bool isDismissible,
    String? confirmText,
    String? cancelText,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        // Menggunakan header yang diberikan atau ikon peringatan default.
        header: header ??
            const SkyImage(
              src: AppIcons.icWarning,
              color: Colors.orange,
              fit: BoxFit.contain,
            ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        // Menggunakan teks konfirmasi yang diberikan atau 'Ya' default.
        confirmText: confirmText ?? 'Ya',
        cancelText: cancelText,
        // Menggunakan warna latar belakang header yang diberikan atau warna scaffold default.
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );

  /// Konstruktor pabrik untuk dialog peringatan coba lagi (retry).
  /// Menampilkan ikon gagal secara default dan mendukung tombol batal.
  factory DialogAlert.retry({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required bool isDismissible,
    String? confirmText,
    String? cancelText,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        // Menggunakan teks konfirmasi yang diberikan atau 'txt_try_again'.tr default.
        confirmText: confirmText ?? 'txt_try_again'.tr,
        cancelText: cancelText,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          // Menggunakan header yang diberikan atau ikon gagal default.
          child: header ??
              const SkyImage(src: AppIcons.icFailed, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        // Menggunakan warna latar belakang header yang diberikan atau warna scaffold default.
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );

  /// Konstruktor pabrik untuk dialog peringatan paksa (force).
  /// Menampilkan ikon peringatan secara default dan mendukung tombol batal opsional.
  factory DialogAlert.force({
    required String title,
    required String confirmText,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
    VoidCallback? onCancel,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        // Menggunakan header yang diberikan atau ikon peringatan default.
        header: header ??
            const SkyImage(
              src: AppIcons.icWarning,
              color: Colors.orange,
              fit: BoxFit.contain,
            ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        // Menggunakan warna latar belakang header yang diberikan atau warna scaffold default.
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );

  /// Judul yang ditampilkan di bagian atas dialog.
  final String title;

  /// Deskripsi atau pesan utama yang ditampilkan di dialog.
  final String description;

  /// Teks yang ditampilkan pada tombol konfirmasi.
  final String confirmText;

  /// Teks yang ditampilkan pada tombol batal.
  final String? cancelText;

  /// Callback yang dipanggil ketika tombol konfirmasi ditekan.
  final VoidCallback? onConfirm;

  /// Callback yang dipanggil ketika tombol batal ditekan.
  final VoidCallback? onCancel;

  /// Widget yang ditampilkan sebagai header dialog (biasanya ikon).
  final Widget? header;

  /// Warna latar belakang untuk [header] (ikon).
  final Color? backgroundColorHeader;

  /// Warna kustom untuk tombol konfirmasi.
  final Color? confirmColor;

  /// Warna kustom untuk tombol batal.
  final Color? cancelColor;

  /// Menentukan apakah dialog dapat ditutup dengan mengetuk di luar atau tombol kembali.
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Mengontrol apakah dialog dapat ditutup oleh tombol kembali atau gestur.
      canPop: isDismissible,
      child: Dialog(
        // Bentuk dialog dengan sudut membulat.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // Tidak ada elevasi untuk dialog.
        elevation: 0,
        // Latar belakang dialog transparan.
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Wrap(
              children: [
                Container(
                  // Padding untuk konten dialog.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  // Margin di bagian atas untuk memberi ruang bagi header.
                  margin: const EdgeInsets.only(top: 26),
                  decoration: BoxDecoration(
                    // Warna latar belakang konten dialog, diambil dari tema scaffold.
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // Sudut membulat untuk kotak konten.
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        // Warna bayangan, menyesuaikan mode gelap/terang.
                        color:
                            (Get.isDarkMode) ? AppColors.primary : Colors.black,
                        // Radius blur untuk bayangan.
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Spasi untuk header.
                      const SizedBox(height: 64),
                      // Judul dialog.
                      Text(
                        title,
                        style: context.typography.subtitle3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Deskripsi dialog.
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // Tombol konfirmasi.
                      SkyButton(
                        text: confirmText,
                        color: confirmColor ?? AppColors.primary,
                        onPressed: onConfirm,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      // Tombol batal, hanya terlihat jika onCancel disediakan.
                      Visibility(
                        visible: onCancel != null,
                        child: SkyButton(
                          text: cancelText ?? 'txt_no'.tr,
                          fontWeight: FontWeight.w600,
                          color: cancelColor ?? AppColors.primary,
                          onPressed: onCancel,
                          outlineMode: true, // Tombol batal dalam mode outline.
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Posisi header (ikon) di bagian atas tengah dialog.
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: backgroundColorHeader,
                radius: 50,
                child: header,
              ),
            ),
          ],
        ),
      ),
    );
  }
}