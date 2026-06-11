import '/core/helper/media_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget [DetermineMediaWidget] adalah komponen dinamis yang bertugas untuk menganalisis,
/// menentukan, dan pada akhirnya merender widget yang sesuai dengan tipe media
/// (berupa file, gambar, video, atau tidak diketahui) yang dideteksi dari sebuah path/URL.
class DetermineMediaWidget extends StatelessWidget {
  /// Konstruktor utama pembentuk [DetermineMediaWidget].
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

  /// Path lokal atau alamat URL string tempat berkas media tersebut berada.
  final String path;
  
  /// Konfigurasi (opsional) widget kustom yang ditampilkan apabila berkas tersebut adalah file dokumen/umum.
  final Widget? file;
  
  /// Konfigurasi (opsional) widget kustom yang ditampilkan apabila berkas tersebut adalah file gambar (image).
  final Widget? image;
  
  /// Konfigurasi (opsional) widget kustom yang ditampilkan apabila berkas tersebut adalah file video.
  final Widget? video;
  
  /// Konfigurasi (opsional) widget fallback saat tipe berkas media tidak terdeteksi (unknown).
  final Widget? unknown;
  
  /// Flag boolean. Bila bernilai [true], widget secara paksa akan menampilkan blok [image] terlepas dari esensi file asli.
  final bool forceImage;
  
  /// Flag boolean. Bila bernilai [true], widget secara paksa akan menampilkan blok [video] terlepas dari esensi file asli.
  final bool forceVideo;
  
  /// Flag boolean. Bila bernilai [true], widget secara paksa akan menampilkan blok [file] terlepas dari esensi file asli.
  final bool forceFile;

  /// Metode fungsional [build] untuk melukis tampilan grafis.
  @override
  Widget build(BuildContext context) {
    // Mengecek serangkaian aturan pemaksaan render khusus jika diaktifkan.
    
    // Jika flag forceImage aktif, maka tampilkan widget image. Jika kosong, gunakan widget peringatan (fallback).
    if (forceImage) return image ?? _unsupportedMediaWidget();
    
    // Jika flag forceVideo aktif, maka tampilkan widget video. Jika kosong, gunakan fallback.
    if (forceVideo) return video ?? _unsupportedMediaWidget();
    
    // Jika flag forceFile aktif, maka tampilkan widget dokumen. Jika kosong, gunakan fallback.
    if (forceFile) return file ?? _unsupportedMediaWidget();

    // Jika tidak ada pemaksaan (force), maka kita lakukan identifikasi tipe media berdasar URL/Path melalui fungsi bantuan internal (helper).
    final media = MediaHelper.getMediaType(path);
    
    // Melakukan pengecekan kondisional (switch expression) terhadap nilai enum MediaType.
    return switch (media.type) {
      // Apabila terdeteksi sebagai FILE biasa, muat komponen `file`.
      MediaType.FILE => file ?? _unsupportedMediaWidget(),
      
      // Apabila terdeteksi sebagai IMAGE (gambar), muat komponen `image`.
      MediaType.IMAGE => image ?? _unsupportedMediaWidget(),
      
      // Apabila terdeteksi sebagai VIDEO, muat komponen `video`.
      MediaType.VIDEO => video ?? _unsupportedMediaWidget(),
      
      // Apabila gagal mengidentifikasi jenisnya secara otomatis, gunakan status UNKNOWN.
      MediaType.UNKNOWN => unknown ?? _unsupportedMediaWidget(),
    };
  }

  /// Metode internal (private) yang bertugas menghasilkan widget standar 
  /// (berupa pesan peringatan teks) apabila media yang terkait tidak dapat didukung / kosong.
  Widget _unsupportedMediaWidget() {
    // Menyiapkan teks default dengan memanfaatkan modul lokalisasi dari GetX ('tr').
    var message = 'txt_media_unsupported'.tr;
    
    // Pengecekan enviroment: apabila aplikasi dibangun pada lingkungan uji coba (Debug mode), 
    // lampirkan path/direktori ke dalam teks kesalahan tersebut untuk mempermudah investigasi (debugging).
    if (kDebugMode) message += '\n$path';
    
    // Merender widget peringatan dalam format teks di bagian tengah layar.
    return Center(
      // Menggunakan widget Text untuk mencetak peringatan di layar
      child: Text(
        // String variabel pesan
        message,
        // Meratakan tulisan ke area center
        textAlign: TextAlign.center,
        // Menyematkan warna font teks dengan warna putih demi kontras pada mode gelap.
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
