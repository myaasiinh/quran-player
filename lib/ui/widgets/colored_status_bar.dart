import '/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget pembungkus kustom [ColoredStatusBar] ditujukan untuk melampisi Scaffold layar aplikasi.
/// Berfungsi untuk secara instan menerapkan modifikasi warna batang status atas (Status Bar) pada layar-layar spesifik.
class ColoredStatusBar extends StatelessWidget {
  /// Konstruktor widget [ColoredStatusBar].
  /// Widget [child] wajib diinisialisasi. Parameter warna bisa diubah via `color` dan tema visibilitas font via `brightness`.
  const ColoredStatusBar({
    required this.child,
    super.key,
    this.color = AppColors.primary,
    this.brightness = Brightness.dark,
    this.coloredBottomBar = false,
  });

  /// Mengatur parameter pewarnaan latar belakang (Background Color) pada elemen Status Bar sistem perangkat pintar.
  final Color? color;

  /// Parameter yang menentukan visibilitas Warna Ikon dan teks penunjuk (contohnya baterai, jam, sinyal) di atas Status Bar.
  ///
  /// Apabila Brightness di set = Brightness.dark, maka Ikon sistem akan menjadi putih bersih (White).
  ///
  /// Sebaliknya, bila diset = Brightness.light, Ikon sistem akan tampil dengan rona gelap/hitam (Black).
  final Brightness brightness;

  /// Variabel flag untuk turut meneruskan efek warna Status Bar tembus sampai ke batang navigasi sistem bagian bawah (bottom bar / on-screen navigation buttons).
  final bool coloredBottomBar;

  /// Argumen widget tunggal bertindak selaku konten (UI aktual) dalam porsi tengah halaman.
  final Widget child;

  /// Menggambarkan antarmuka tampilan fungsional utama secara deklaratif.
  @override
  Widget build(BuildContext context) {
    // Android memiliki interpretasi kebalikan terkait Brightness dengan logika iOS.
    // Jika brightness argumentasi adalah dark, maka secara internal untuk android Icon Brightness adalah light.
    final androidIconBrightness =
        brightness == Brightness.dark ? Brightness.light : Brightness.dark;
        
    // Memakai widget sistem khusus [AnnotatedRegion] untuk menimpa aturan gaya konfigurasi bar notifikasi dari sistem yang ditenagai oleh `SystemUiOverlayStyle`.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color, // Menerapkan argumen warna dominan pada sisi Status Bar.
        statusBarIconBrightness: androidIconBrightness, // Menerapkan rona warna spesifik pada sistem Android OS.
        statusBarBrightness: brightness, // Menerapkan orientasi kecerahan icon spesifik di sistem Apple iOS.
      ),
      // Container pembalut bertugas mengecat seluruh dasar belakang hingga ke celah safe-area yang aman.
      child: Container(
        color: color, // Memberi lapisan warna pada sebidang layar paling belakang.
        // Komponen pelindung SafeArea berguna menggeser padding supaya widget anak `child` tidak tertutup oleh lekukan notch atau punch-hole kamera perangkat.
        child: SafeArea(
          left: false, // Mematikan penjagaan safe area untuk orientasi landscape (sisi kiri).
          right: false, // Mematikan perlindungan safe area untuk sisi layar lekukan kanan.
          bottom: coloredBottomBar, // Area dasar mengikuti sifat dari variabel kontrol custom coloredBottomBar apakah dia memproteksi / dilompati.
          child: child, // Merender anak layout Scaffold pengguna.
        ),
      ),
    );
  }
}
