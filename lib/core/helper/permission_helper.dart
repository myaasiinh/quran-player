import 'dart:io';

import '/config/themes/app_colors.dart';
import '/core/helper/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Kelas `PermissionHelper` berfungsi sebagai utilitas untuk mengelola permintaan izin
/// (permissions) pada perangkat pengguna, seperti izin kamera, penyimpanan, dan foto.
class PermissionHelper {
  /// Membuka dialog pengaturan sistem saat izin ditolak secara permanen.
  /// Menerima parameter [message] untuk menampilkan pesan peringatan.
  static void openSettings(String message) {
    // Menampilkan snackbar dari GetX untuk peringatan izin
    Get.snackbar(
      // Judul peringatan izin yang diterjemahkan
      'txt_permission_warning'.tr,
      // Pesan alasan pengaturan perlu dibuka
      message,
      // Durasi tampilan snackbar
      duration: const Duration(seconds: 5),
      // Tombol aksi utama untuk membuka pengaturan aplikasi
      mainButton: TextButton(
        // Fungsi dari permission_handler untuk membuka pengaturan
        onPressed: openAppSettings,
        child: Text(
          // Teks tombol untuk pengaturan yang diterjemahkan
          'txt_open_setting'.tr,
          // Gaya teks menggunakan tema aplikasi dengan warna sekunder
          style: Get.textTheme.bodySmall?.copyWith(color: AppColors.secondary),
        ),
      ),
    );
  }

  /// Menampilkan pesan error sederhana terkait izin.
  /// Menerima [message] sebagai pesan error dan [backgroundColor] opsional.
  static void error(String message, {Color? backgroundColor}) {
    // Menampilkan snackbar peringatan error
    Get.snackbar(
      // Judul peringatan izin yang diterjemahkan
      'txt_permission_warning'.tr,
      // Pesan error yang diberikan
      message,
      // Warna latar belakang, default-nya putih jika tidak diberikan
      backgroundColor: backgroundColor ?? Colors.white,
      // Durasi tampilan snackbar
      duration: const Duration(seconds: 5),
    );
  }

  /// Memeriksa dan meminta izin untuk menggunakan kamera.
  /// Mengembalikan `true` jika izin diberikan, `false` sebaliknya.
  static Future<bool> isCameraGranted({
    // Flag untuk menentukan apakah akan menampilkan pesan jika izin ditolak
    bool showDeniedMessage = true,
    // Pesan jika izin ditolak permanen
    String? permanentlyDeniedMsg,
    // Pesan default jika izin ditolak
    String deniedMsg = 'txt_need_permission_camera',
  }) async {
    // Cek status izin kamera saat ini
    final isGranted = await Permission.camera.status.isGranted;
    // Jika sudah diizinkan, langsung kembalikan true
    if (isGranted) return true;

    // Meminta izin kamera ke pengguna
    final permission = await Permission.camera.request();
    // Menangani respons pengguna melalui dialog
    _handleDialog(
      permission: permission,
      // Gunakan pesan permanen kustom jika ada, atau fallback ke pesan terjemahan
      permanentlyDeniedMsg: permanentlyDeniedMsg ?? deniedMsg.tr,
      // Tampilkan pesan penolakan jika flag showDeniedMessage aktif
      deniedMsg: showDeniedMessage ? deniedMsg.tr : null,
    );
    // Kembalikan status hasil permintaan izin
    return permission.isGranted;
  }

  /// Memeriksa dan meminta izin untuk mengakses penyimpanan (storage).
  /// Mengembalikan `true` jika izin diberikan, `false` sebaliknya.
  static Future<bool> isStorageGranted({
    // Flag untuk menampilkan pesan penolakan
    bool showDeniedMessage = true,
    // Pesan jika izin ditolak permanen
    String? permanentlyDeniedMsg,
    // Pesan default jika izin ditolak
    String deniedMsg = 'txt_need_permission_storage',
  }) async {
    // Cek status izin penyimpanan saat ini
    final isGranted = await Permission.storage.status.isGranted;
    // Jika sudah diizinkan, langsung kembalikan true
    if (isGranted) return true;

    // Meminta izin penyimpanan ke pengguna
    final permission = await Permission.storage.request();
    // Menangani respons dialog berdasarkan status izin
    _handleDialog(
      permission: permission,
      // Pesan untuk penolakan permanen
      permanentlyDeniedMsg: permanentlyDeniedMsg ?? deniedMsg.tr,
      // Tampilkan pesan penolakan jika diminta
      deniedMsg: showDeniedMessage ? deniedMsg.tr : null,
    );
    // Kembalikan status izin akhir
    return permission.isGranted;
  }

  /// Memeriksa dan meminta izin untuk mengakses galeri/foto.
  /// Mengembalikan `true` jika izin diberikan, `false` sebaliknya.
  static Future<bool> isPhotoGranted({
    // Secara default tidak menampilkan pesan penolakan biasa
    bool showDeniedMessage = false,
    // Pesan jika izin ditolak permanen
    String? permanentlyDeniedMsg,
    // Pesan default untuk izin foto
    String deniedMsg = 'txt_need_permission_gallery_photo',
  }) async {
    // Cek status izin akses foto
    final isGranted = await Permission.photos.status.isGranted;
    // Jika sudah diizinkan, langsung kembalikan true
    if (isGranted) return true;

    // Meminta izin akses foto
    final permission = await Permission.photos.request();
    // Perlakuan khusus untuk platform iOS
    if (Platform.isIOS) {
      // iOS mengharuskan pengguna membuka pengaturan jika ditolak permanen
      if (permission.isPermanentlyDenied) {
        // Tampilkan dialog arahkan ke pengaturan
        openSettings(permanentlyDeniedMsg ?? deniedMsg.tr);
        return false;
      }
      // Jika tidak ditolak permanen di iOS, anggap diizinkan (atau ditangani sistem)
      return true;
    } else {
      // Penanganan dialog standar untuk Android dan lainnya
      _handleDialog(
        permission: permission,
        // Pesan jika ditolak permanen
        permanentlyDeniedMsg: permanentlyDeniedMsg ?? deniedMsg.tr,
        // Pesan penolakan biasa jika diperlukan
        deniedMsg: showDeniedMessage ? deniedMsg.tr : null,
      );
      // Kembalikan status izin akhir
      return permission.isGranted;
    }
  }

  /// Meminta beberapa izin sekaligus dalam satu panggilan.
  /// Mengembalikan `true` hanya jika SEMUA izin yang diminta diberikan.
  static Future<bool> isMultiplePermissionGranted(
    // Daftar izin yang akan diminta secara massal
    List<Permission> permissions, {
    // Pesan jika salah satu izin ditolak permanen
    String? permanentlyDeniedMsg,
    // Pesan default jika izin ditolak
    String deniedMsg = 'txt_need_several_permission',
  }) async {
    // Meminta semua izin dalam daftar sekaligus
    final permissionList = await permissions.request();
    // Mengecek apakah ada izin yang ditolak secara permanen
    if (permissionList.values.contains(PermissionStatus.permanentlyDenied)) {
      // Jika ada, minta pengguna untuk membuka pengaturan
      PermissionHelper.openSettings(permanentlyDeniedMsg ?? deniedMsg.tr);
      return false;
    } 
    // Jika semua izin diberikan dengan sukses
    else if (permissionList.values.every((e) => e.isGranted)) {
      return true;
    } 
    // Jika ada izin yang ditolak secara biasa
    else if (permissionList.values.contains(PermissionStatus.denied)) {
      // Tampilkan pesan error penolakan
      PermissionHelper.error(deniedMsg.tr);
      return false;
    } 
    // Kondisi lain (misal dibatasi)
    else {
      // Tampilkan error penolakan sebagai fallback
      PermissionHelper.error(deniedMsg.tr);
      return false;
    }
  }

  /// Meminta izin untuk mengelola penyimpanan eksternal (manage external storage).
  /// **Catatan:** Izin ini digunakan untuk membuka folder yang diunduh.
  /// Namun ini sangat sensitif dan berisiko ditolak oleh Google Play.
  /// Sebisa mungkin hindari meminta izin ini kecuali sangat diperlukan.
  static Future<bool> manageExternalStorage({
    // Pesan peringatan jika izin ditolak
    String deniedMsg = 'txt_need_permission_storage',
  }) async {
    // Izin ini hanya relevan untuk platform Android
    if (Platform.isAndroid) {
      // Meminta izin kelola penyimpanan eksternal
      final permission = await Permission.manageExternalStorage.request();
      // Jika pengguna menolak secara permanen
      if (permission.isPermanentlyDenied) {
        // Arahkan pengguna ke pengaturan
        PermissionHelper.openSettings(deniedMsg.tr);
      } else {
        // Jika ditolak biasa, tampilkan snackbar peringatan
        SnackBarHelper.warning(message: deniedMsg.tr);
      }
      // Kembalikan status izin
      return permission.isGranted;
    } else {
      // Selain Android (misal iOS), otomatis kembalikan true atau tangani terpisah
      return true;
    }
  }

  /// Fungsi bantuan (helper) untuk menangani respons dialog izin.
  /// **Catatan:**
  /// Akan menampilkan pesan *open setting* jika **Permission.permanentlyDenied**
  /// dan secara opsional menampilkan pesan *error* jika **Permission.isDenied**.
  static void _handleDialog({
    // Status izin yang akan dievaluasi
    required PermissionStatus permission,
    // Pesan khusus jika ditolak permanen
    required String permanentlyDeniedMsg,
    // Pesan opsional jika ditolak biasa
    String? deniedMsg,
  }) {
    // Menggunakan switch-case untuk menangani berbagai status
    switch (permission) {
      case PermissionStatus.granted:
        // Jika diizinkan, tidak ada tindakan yang perlu dilakukan
        break;
      case PermissionStatus.permanentlyDenied:
        // Jika ditolak permanen, panggil openSettings
        openSettings(permanentlyDeniedMsg);
      case PermissionStatus.denied:
        // Jika ditolak, tampilkan pesan error jika disediakan
        if (deniedMsg != null) error(deniedMsg);
      default:
        // Tidak melakukan apa-apa untuk status lain
        break;
    }
  }
}
