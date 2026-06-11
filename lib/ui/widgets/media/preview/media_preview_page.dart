import '/ui/widgets/media/determine_media_widget.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/

/// Halaman `MediaPreviewPage` adalah layar tampilan penuh (full screen) 
/// untuk mempratinjau atau meninjau media tertentu seperti gambar.
/// Layar ini mendukung modifikasi paksa tipe media berdasarkan parameter yang dipasok.
class MediaPreviewPage extends StatelessWidget {
  /// Konstruktor widget halaman pratinjau.
  const MediaPreviewPage({
    required this.src,
    super.key,
    this.isAsset = true,
    this.title,
    this.titleStyle,
    this.forceImage = false,
    this.forceVideo = false,
    this.forceFile = false,
  });
  
  /// Rujukan string jalur file (alamat internet atau path lokal) yang akan dipratinjau.
  final String src;
  
  /// Boolean flag penanda apakah file ini berasal dari assets aplikasi atau luar.
  final bool isAsset;
  
  /// Judul (title) teks yang ditampilkan pada App Bar atas halaman pratinjau.
  final String? title;
  
  /// Opsi gaya font khusus (TextStyle) untuk judul.
  final TextStyle? titleStyle;
  
  /// Flag paksaan jika ekstensi file media harus dirender secara absolut sebagai Image.
  final bool forceImage;
  
  /// Flag paksaan untuk di-render sebagai Video.
  final bool forceVideo;
  
  /// Flag paksaan untuk merender layaknya representasi Berkas/File umum.
  final bool forceFile;

  @override
  Widget build(BuildContext context) {
    // Menggunakan base Scaffold untuk me-render kerangka page dasar
    return Scaffold(
      // Konfigurasi AppBar (bilah atas) yang membungkus fungsi 'Kembali' secara otomatis
      appBar: AppBar(
        // Latar belakang bilah navigasi gelap sesuai tema bioskop/preview
        backgroundColor: Colors.black,
        // Menyisipkan label judul text
        title: Text(title ?? '', style: titleStyle),
      ),
      // Latar layar full dibuat hitam untuk menonjolkan fokus gambar
      backgroundColor: Colors.black,
      // Komponen widget utama yang menampung file multimedia
      body: DetermineMediaWidget(
        // Alamat media yang akan dianalisa tipe renderannya
        path: src,
        // Properti flag paksaan diteruskan ke widget determinasi
        forceFile: forceFile,
        forceImage: forceImage,
        forceVideo: forceVideo,
        // Parameter widget pengganti bila file yang diterima ditetapkan sebagai gambar
        image: Center(
          // Memakai widget gambar kostum kita (SkyImage) dan ditaruh pas di tengah (Center)
          child: SkyImage(src: src, isAsset: isAsset),
        ),
        // Set this widget if want to show file preview
        // Mengirimkan kotak tak terlihat (SizedBox.shrink) karena mode preview file dokumen dimatikan saat ini
        file: const SizedBox.shrink(),
        // Set this widget if want to show video preview
        // Widget preview untuk Video juga tak ada render visual spesifik di layar ini (diakali dengan kosong)
        video: const SizedBox.shrink(),
        // Set this widget if want to show custom unknown preview
        // Tangani sisa render yang gagal/tidak diklasifikasikan dengan layar kosong transparan
        unknown: const SizedBox.shrink(),
      ),
    );
  }
}
