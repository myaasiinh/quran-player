import 'dart:io';

import '/core/helper/file_helper.dart';
import '/core/helper/media_helper.dart';
import '/core/helper/permission_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/* author
   myaasiinh@gmail.com
*/

/// Sebuah Widget Bottom Sheet yang digunakan untuk memilih sumber lampiran.
///
/// Pengguna dapat memilih untuk mengambil foto melalui kamera, mengambil
/// gambar dari galeri, atau memilih dokumen dari berkas lokal.
class AttachmentsSourceBottomSheet extends StatelessWidget {
  /// Konstruktor pembuatan [AttachmentsSourceBottomSheet].
  const AttachmentsSourceBottomSheet({
    required this.onAttachmentsSelected,
    required this.onMultipleAttachmentsSelected,
    super.key,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.cameraIcon = const Icon(Icons.camera_alt_rounded),
    this.galleryIcon = const Icon(Icons.image),
    this.fileIcon = const Icon(CupertinoIcons.doc_text_fill),
    this.cameraLabel,
    this.galleryLabel,
    this.fileLabel,
    this.withImageCompression = false,
    this.sizeLimit = 2000000,
    this.allowMultiple = true,
    this.allowedFileExtensions,
    this.enabledFileSource = true,
  });

  /// Batas tinggi maksimal gambar yang diambil.
  final double? maxHeight;
  /// Batas lebar maksimal gambar yang diambil.
  final double? maxWidth;
  /// Kualitas kompresi gambar (0 - 100).
  final int? imageQuality;
  /// Pilihan kamera preferensi, misal [CameraDevice.rear] atau front.
  final CameraDevice preferredCameraDevice;
  
  /// Callback ketika satu berkas/lampiran terpilih.
  final void Function(File) onAttachmentsSelected;
  /// Callback ketika beberapa berkas/lampiran terpilih sekaligus.
  final void Function(List<File>) onMultipleAttachmentsSelected;

  /// Ikon yang ditampilkan untuk pilihan Kamera.
  final Widget? cameraIcon;
  /// Ikon yang ditampilkan untuk pilihan Galeri.
  final Widget? galleryIcon;
  /// Ikon yang ditampilkan untuk pilihan Berkas/Dokumen.
  final Widget? fileIcon;
  
  /// Label teks untuk tombol Kamera.
  final Widget? cameraLabel;
  /// Label teks untuk tombol Galeri.
  final Widget? galleryLabel;
  /// Label teks untuk tombol Berkas/Dokumen.
  final Widget? fileLabel;

  /// Menandakan apakah proses pengambilan gambar akan menggunakan kompresi.
  final bool withImageCompression;
  /// Batas ukuran fail dalam byte.
  final int sizeLimit;
  /// Status yang memperbolehkan pemilihan lebih dari satu lampiran (multi-pick).
  final bool allowMultiple;
  /// Daftar ekstensi fail (file extension) yang diperbolehkan untuk dipilih.
  final List<String>? allowedFileExtensions;
  /// Jika `false`, maka opsi pemilihan berkas/dokumen akan disembunyikan.
  final bool enabledFileSource;

  @override
  Widget build(BuildContext context) {
    // Membungkus list opsi dalam widget Wrap agar fleksibel secara vertikal
    return Wrap(
      children: <Widget>[
        // Pilihan Kamera
        ListTile(
          leading: cameraIcon,
          title: cameraLabel ?? Text('txt_camera'.tr),
          onTap: () => _onPickImage(ImageSource.camera),
        ),
        // Pilihan Galeri
        ListTile(
          leading: galleryIcon,
          title: galleryLabel ?? Text('txt_gallery'.tr),
          onTap: () => _onPickImage(ImageSource.gallery),
        ),
        // Pilihan Dokumen (hanya tampil jika enabledFileSource bernilai true)
        if (enabledFileSource)
          ListTile(
            leading: fileIcon,
            title: fileLabel ?? Text('txt_document'.tr),
            onTap: _onPickFile,
          ),
      ],
    );
  }

  /// Menangani aksi pemilihan gambar baik dari sumber Kamera maupun Galeri.
  Future<void> _onPickImage(ImageSource source) async {
    // Jika sumber adalah Kamera
    if (source == ImageSource.camera) {
      // Periksa izin akses kamera
      final isGranted = await PermissionHelper.isCameraGranted();
      // Jika izin diberikan, proses ambil gambar tunggal
      if (isGranted) await _pickSingleImage(ImageSource.camera);
    } else {
      // Jika sumber adalah Galeri, periksa perizinan media/foto
      final isGranted = await _checkPermission();
      if (isGranted) {
        // Cek apakah mode multi-pick diaktifkan
        if (allowMultiple) {
          await _pickMultipleImage();
        } else {
          // Jika tidak, ambil hanya satu gambar dari galeri
          await _pickSingleImage(ImageSource.gallery);
        }
      }
    }
  }

  /// Memeriksa izin berdasarkan platform perangkat (Android/iOS).
  Future<bool> _checkPermission() async {
    // Jika perangkat iOS, cukup periksa izin foto
    if (Platform.isIOS) {
      return PermissionHelper.isPhotoGranted();
    } else {
      // Jika Android, butuh pengecekan spesifik berdasarkan versi SDK
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      // Jika versi Android di bawah Android 13 (API 33)
      if (androidInfo.version.sdkInt < 33) {
        return PermissionHelper.isStorageGranted(
          permanentlyDeniedMsg: 'txt_need_permission_gallery_photo'.tr,
        );
      } else {
        // Jika versi Android 13 ke atas, izinnya menggunakan spesifik media
        return PermissionHelper.isMultiplePermissionGranted(
          [
            Permission.photos,
            Permission.videos,
          ],
          deniedMsg: 'txt_need_permission_storage'.tr,
        );
      }
    }
  }

  /// Fungsi untuk memilih/mengambil satu buah gambar saja.
  Future<void> _pickSingleImage(ImageSource source) async {
    // Menjalankan fungsi helper untuk mengambil gambar
    final pickedFile = await MediaHelper.pickImage(
      source: source,
      withCompression: withImageCompression,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      // sizeLimit: sizeLimit, // parameter tidak terpakai
    );
    // Jika berhasil mendapatkan gambar
    if (null != pickedFile) {
      // Panggil callback onAttachmentsSelected
      onAttachmentsSelected(pickedFile);
      // Tutup bottom sheet
      Get.back();
    }
  }

  /// Fungsi untuk memilih banyak gambar sekaligus dari galeri.
  Future<void> _pickMultipleImage() async {
    // Panggil library ImagePicker untuk multi-pick gambar
    final result = await ImagePicker().pickMultiImage(
      // Batasi tinggi jika dengan kompresi, bila tidak gunakan properti widget
      maxHeight: withImageCompression ? 1024 : maxHeight,
      // Batasi lebar jika dengan kompresi, bila tidak gunakan properti widget
      maxWidth: withImageCompression ? 1024 : maxWidth,
      imageQuality: imageQuality,
    );
    // Map hasil path ke object File dan panggil callback
    onMultipleAttachmentsSelected(result.map((e) => File(e.path)).toList());
    // Tutup bottom sheet
    Get.back();
  }

  /// Menangani aksi pemilihan dokumen/berkas (file).
  Future<void> _onPickFile() async {
    // Menjalankan helper FileHelper untuk memilih berkas secara async
    final result = await FileHelper.pickFile(
          allowMultiple: allowMultiple,
          // Menyesuaikan ekstensi yang dizinkan atau menggunakan default
          allowedExtensions:
              allowedFileExtensions ?? MediaHelper.fileExtensions,
        ) ??
        [];
    // Kirimkan list file yang didapat ke callback
    onMultipleAttachmentsSelected(result);
    // Tutup bottom sheet
    Get.back();
  }
}
