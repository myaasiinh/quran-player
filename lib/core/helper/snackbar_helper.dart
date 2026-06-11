import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Jenis atau tipe dari SnackBar yang akan ditampilkan.
enum SkySnackBarType { NORMAL, SUCCESS, ERROR, WARNING }

/// Kelas helper untuk mempermudah pemanggilan SnackBar menggunakan ScaffoldMessenger.
abstract class SnackBarHelper {
  /// Menampilkan SnackBar dengan pengaturan yang sepenuhnya kustom (Custom).
  static void custom({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    Color? backgroundColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    ShapeBorder? shape,
    double? elevation,
  }) {
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      behavior: behavior,
      action: action,
      backgroundColor: backgroundColor,
      width: width,
      elevation: elevation,
      shape: shape,
      margin: margin,
      padding: padding,
    );
  }

  /// Menampilkan SnackBar dengan tipe normal (tanpa indikator warna khusus).
  static void normal({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      behavior: behavior,
      action: action,
    );
  }

  /// Menampilkan SnackBar untuk status berhasil (Success).
  /// Latar belakang umumnya berwarna hijau.
  static void success({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      type: SkySnackBarType.SUCCESS,
      behavior: behavior,
      action: action,
    );
  }

  /// Menampilkan SnackBar untuk status gagal atau error (Error).
  /// Latar belakang umumnya berwarna merah.
  static void error({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    showDefaultSnackBar(
      message: message ?? 'txt_error'.tr,
      type: SkySnackBarType.ERROR,
      behavior: behavior,
      action: action,
    );
  }

  /// Menampilkan SnackBar untuk status peringatan (Warning).
  /// Latar belakang umumnya berwarna oranye.
  static void warning({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    showDefaultSnackBar(
      message: message ?? 'txt_warning'.tr,
      type: SkySnackBarType.WARNING,
      behavior: behavior,
      action: action,
    );
  }

  /// Fungsi utama (internal) untuk membuat dan menampilkan SnackBar.
  /// Berfungsi mengatur properti visual (warna, margin, dsb) berdasarkan tipe yang diberikan.
  static void showDefaultSnackBar({
    required String message,
    SkySnackBarType type = SkySnackBarType.NORMAL,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? width,
    ShapeBorder? shape,
    double? elevation,
  }) {
    // Menentukan warna dasar jika backgroundColor tidak diberikan
    var bgColor = backgroundColor ?? Theme.of(Get.context!).primaryColor;
    
    // Menyesuaikan warna sesuai dengan tipe (enum) SnackBar
    bgColor = switch (type) {
      SkySnackBarType.ERROR => bgColor = Colors.red,
      SkySnackBarType.SUCCESS => bgColor = Colors.green,
      SkySnackBarType.WARNING => bgColor = Colors.orange,
      SkySnackBarType.NORMAL => bgColor = Colors.black,
    };

    final snackBar = SnackBar(
      width: width,
      elevation: elevation,
      shape: shape,
      action: action,
      margin: margin,
      padding: padding,
      content: Text(message, style: const TextStyle(color: Colors.white)),
      // Default menggunakan tipe floating agar terlihat melayang dari bawah
      behavior: behavior ?? SnackBarBehavior.floating,
      backgroundColor: bgColor,
    );

    // Sembunyikan SnackBar yang sedang aktif (jika ada) dan tampilkan yang baru
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
