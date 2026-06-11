import '/ui/widgets/media/determine_media_widget.dart';
import '/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Halaman `MediaListPreviewPage` digunakan untuk menampilkan pratinjau (preview) 
/// dari sekumpulan (list) media sekaligus secara vertikal yang dapat di-scroll.
class MediaListPreviewPage extends StatelessWidget {
  /// Konstruktor halaman pratinjau daftar media.
  const MediaListPreviewPage({required this.mediaUrls, super.key});
  
  /// Parameter berupa daftar URL (string) media yang akan dirender secara bergantian.
  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    // Membuat sebuah List sementara untuk menampung widget yang akan digambar
    final children = <Widget>[];

    // Melakukan pengulangan (looping) pada setiap URL media dalam koleksi `mediaUrls`
    for (final item in mediaUrls) {
      // Menambahkan elemen-elemen baru ke dalam List (dengan Cascade Operator '..')
      children
        ..add(
          // Menggunakan widget utilitas khusus untuk menentukan jenis media (Gambar/Video/Berkas)
          DetermineMediaWidget(
            // Jalur asal (path) file
            path: item,
            // Jika terdeteksi sebagai gambar, render menggunakan SkyImage dengan fitur zoom/preview menyala
            image: SkyImage(src: item, enablePreview: true),
            // Set this widget if want to show file preview
            // Pengisian sementara untuk file; saat ini belum menampilkan apa-apa jika tipe dokumen.
            file: const SizedBox.shrink(),
            // Set this widget if want to show video preview
            // Pengisian sementara untuk video; belum menampilkan UI Video Player.
            video: const SizedBox.shrink(),
            // Set this widget if want to show custom unknown preview
            // Pengisian untuk format file tak dikenal; disembunyikan.
            unknown: const SizedBox.shrink(),
          ),
        )
        // Menambahkan garis pemisah (Divider) horisontal setelah setiap media agar tampilan rapi
        ..add(const Divider());
    }
    
    // Kembalikan Scaffold sebagai kanvas dasar layar
    return Scaffold(
      // AppBar kustom berstatus 'primer' dengan judul yang diterjemahkan ("Preview Media")
      appBar: SkyAppBar.primary(title: '${'txt_preview'.tr} ${'txt_media'.tr}'),
      // Membuat konten utamanya bisa di-scroll secara vertikal
      body: SingleChildScrollView(
        // Menyusun anak-anak (daftar render media) dalam format Kolom dari atas ke bawah
        child: Column(children: children),
      ),
    );
  }
}
