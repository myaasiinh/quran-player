import '/core/helper/media_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget [DetermineMediaWidget] digunakan untuk menentukan dan menampilkan widget yang sesuai
/// berdasarkan tipe media (file, gambar, video, atau tidak diketahui) dari sebuah path atau URL.
class DetermineMediaWidget extends StatelessWidget {
  const DetermineMediaWidget({
    required this.path,
    super.key,
    this.file,
    this.image,
    this.video,
    this.unknown,
    this.forceImage = false,
    this.forceVideo = false,
    this.forceFile = false,
  });

  /// Path atau URL dari media.
  final String path;
  
  /// Widget yang ditampilkan jika tipe media adalah file dokumen.
  final Widget? file;
  
  /// Widget yang ditampilkan jika tipe media adalah gambar.
  final Widget? image;
  
  /// Widget yang ditampilkan jika tipe media adalah video.
  final Widget? video;
  
  /// Widget yang ditampilkan jika tipe media tidak diketahui.
  final Widget? unknown;
  
  /// Jika bernilai `true`, widget akan dipaksa menampilkan sebagai gambar mengabaikan tipe aslinya.
  final bool forceImage;
  
  /// Jika bernilai `true`, widget akan dipaksa menampilkan sebagai video mengabaikan tipe aslinya.
  final bool forceVideo;
  
  /// Jika bernilai `true`, widget akan dipaksa menampilkan sebagai file mengabaikan tipe aslinya.
  final bool forceFile;

  @override
  Widget build(BuildContext context) {
    // Memeriksa apakah ada pemaksaan tipe media
    if (forceImage) return image ?? _unsupportedMediaWidget();
    if (forceVideo) return video ?? _unsupportedMediaWidget();
    if (forceFile) return file ?? _unsupportedMediaWidget();

    // Menentukan tipe media berdasarkan path
    final media = MediaHelper.getMediaType(path);
    return switch (media.type) {
      MediaType.FILE => file ?? _unsupportedMediaWidget(),
      MediaType.IMAGE => image ?? _unsupportedMediaWidget(),
      MediaType.VIDEO => video ?? _unsupportedMediaWidget(),
      MediaType.UNKNOWN => unknown ?? _unsupportedMediaWidget(),
    };
  }

  /// Membuat widget default yang ditampilkan saat media tidak didukung.
  Widget _unsupportedMediaWidget() {
    var message = 'txt_media_unsupported'.tr;
    // Menambahkan path ke pesan error jika dalam mode debug
    if (kDebugMode) message += '\n$path';
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
