import '/ui/widgets/platform_loading_indicator.dart';
import '/ui/widgets/sky_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Kelas utilitas untuk menampilkan dialog indikator proses (loading).
class LoadingDialog {
  /// Menampilkan dialog loading kustom dengan latar belakang semi transparan.
  /// 
  /// [dismissible] menentukan apakah dialog dapat ditutup dengan mengetuk area luar.
  static Future<T?> show<T>({bool? dismissible}) {
    return showGeneralDialog<T>(
      context: Get.context!,
      barrierLabel: 'Barrier',
      barrierDismissible: dismissible ?? false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            // Menggunakan widget loading indikator yang menyesuaikan platform
            child: const PlatformLoadingIndicator(),
          ),
        );
      },
    );
  }

  /// Menutup dialog loading yang sedang tampil.
  static void dismiss() => Get.back();
}

/// Kelas helper untuk menampilkan berbagai macam peringatan/pesan dalam bentuk dialog.
class DialogHelper {
  /// Menampilkan dialog peringatan untuk operasi yang gagal (Failed).
  static Future<T?> failed<T>({
    required String message,
    VoidCallback? onConfirm,
    Widget? header,
    bool? isDismissible,
    String? title,
  }) {
    return showDialog<T>(
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      builder: (context) => DialogAlert.error(
        header: header,
        title: title ?? 'txt_failed'.tr,
        description: message,
        onConfirm: onConfirm ?? dismiss,
        isDismissible: isDismissible ?? true,
      ),
    );
  }

  /// Menampilkan dialog peringatan untuk operasi yang berhasil (Success).
  static Future<T?> success<T>({
    required String message,
    required VoidCallback onConfirm,
    Widget? header,
    bool? isDismissible,
    String? title,
  }) {
    return showDialog<T>(
      barrierDismissible: isDismissible ?? false,
      context: Get.context!,
      builder: (context) => DialogAlert.success(
        header: header,
        title: title ?? 'txt_success'.tr,
        description: message,
        onConfirm: onConfirm,
        isDismissible: isDismissible ?? false,
      ),
    );
  }

  /// Menampilkan dialog peringatan berupa teguran atau info (Warning).
  /// Mendukung tombol konfirmasi dan batal.
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
    return showDialog<T>(
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      builder: (context) => DialogAlert.warning(
        header: header,
        isDismissible: isDismissible ?? false,
        title: title ?? 'txt_warning'.tr,
        description: message,
        onConfirm: onConfirm,
        confirmText: confirmText,
        onCancel: onCancel ?? dismiss,
        cancelText: cancelText,
      ),
    );
  }

  /// Menampilkan dialog peringatan untuk melakukan percobaan ulang (Retry).
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
    return showDialog<T>(
      barrierDismissible: isDismissible ?? true,
      context: Get.context!,
      builder: (context) => DialogAlert.retry(
        header: header,
        title: title ?? 'txt_failed'.tr,
        description: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel ?? dismiss,
        isDismissible: isDismissible ?? true,
      ),
    );
  }

  /// Menampilkan dialog peringatan yang memaksa pengguna untuk mengambil tindakan (Force).
  /// Umumnya tidak dapat di-dismiss dengan menekan area luar dialog.
  static Future<T?> force<T>({
    required String message,
    required VoidCallback onConfirm,
    bool? isDismissible,
    Widget? header,
    String? title,
    VoidCallback? onCancel,
    String? confirmText,
  }) {
    return showDialog<T>(
      barrierDismissible: false, // Tidak bisa ditutup secara otomatis
      context: Get.context!,
      builder: (context) => DialogAlert.force(
        header: header,
        title: title ?? 'txt_warning'.tr,
        description: message,
        onConfirm: onConfirm,
        onCancel: onCancel ?? dismiss,
        confirmText: confirmText ?? 'OK',
        isDismissible: isDismissible ?? false,
      ),
    );
  }

  /// Menutup dialog yang saat ini aktif.
  static void dismiss() => Get.back();
}
