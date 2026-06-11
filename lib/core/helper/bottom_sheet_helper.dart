import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Kelas pembantu (helper) untuk menampilkan berbagai jenis Bottom Sheet.
/// Menggunakan package `modal_bottom_sheet` dan utilitas dari `get`.
class BottomSheetHelper {
  /// Menampilkan Bottom Sheet dasar/standar bawaan Material.
  /// 
  /// [child] adalah widget konten yang akan ditampilkan.
  /// Parameter lain dapat diatur untuk mengonfigurasi properti Bottom Sheet seperti dismissible, warna, dsb.
  static Future<T?> basic<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor = Colors.transparent,
    Color? barrierColor,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      enableDrag: enableDrag,
      builder: (btmContext) => ColoredBox(
        color: Theme.of(Get.context!).scaffoldBackgroundColor,
        child: ConstrainedBox(
          // Membatasi tinggi maksimum Bottom Sheet agar tidak melebihi ukuran layar
          constraints: BoxConstraints(maxHeight: Get.height - 50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Menampilkan Bottom Sheet dengan sudut atas yang melengkung (rounded).
  static Future<T?> rounded<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor = Colors.transparent,
    Color? barrierColor,
    bool enableDrag = true,
    double? height,
    bool expand = false,
  }) async {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      builder: (btmContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height - 50),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              // Memberikan lengkungan (radius) pada sudut kiri atas dan kanan atas
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Menampilkan Bottom Sheet bergaya Bar.
  /// Sering digunakan untuk tampilan yang menempel pada batas atas.
  static Future<T?> bar<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
    bool expand = false,
  }) async {
    return showBarModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      expand: expand,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (btmContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: child,
      ),
    );
  }

  /// Menampilkan Bottom Sheet bergaya Cupertino (iOS style).
  /// Memiliki indikator tarikan (drag indicator) kecil di bagian atas.
  static Future<T?> cupertino<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool enableBack = true,
    bool expand = false,
    Color? barrierColor,
  }) async {
    return showCupertinoModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      topRadius: const Radius.circular(24),
      duration: const Duration(milliseconds: 600),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      barrierColor: barrierColor ?? Colors.black54,
      expand: expand,
      builder: (btmContext) => PopScope(
        canPop: enableBack,
        child: Material(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Indikator drag (garis horizontal di tengah atas)
              Positioned(
                top: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menampilkan Modal Bottom Sheet Material yang disesuaikan dari package.
  static Future<T?> material<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool enableBack = true,
    bool expand = false,
    Color? barrierColor,
  }) async {
    return showMaterialModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      duration: const Duration(milliseconds: 600),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      barrierColor: barrierColor ?? Colors.black54,
      expand: expand,
      bounce: true,
      builder: (btmContext) => PopScope(
        canPop: enableBack,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: child,
        ),
      ),
    );
  }
}
