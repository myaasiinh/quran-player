import '/ui/widgets/sky_box.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Komponen visual [ShimmerCircle] merepresentasikan status pemuatan (loading) 
/// berbentuk profil bulat bercahaya untuk avatar, tombol bulat, dll.
class ShimmerCircle extends StatelessWidget {
  /// Konstruktor widget shimmer dengan properti modifikasi dimensi serta ruang sekitarnya.
  const ShimmerCircle({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.baseColor,
  });

  /// Besaran nilai ukuran tinggi visual, ini turut berperan membentuk radius putaran lingkaran.
  final double? height;
  
  /// Besaran nilai ukuran lebar visual elemen shimmer tersebut.
  final double? width;
  
  /// Inset batasan spasi luaran pada area elemen shimmer (margin).
  final EdgeInsets? margin;
  
  /// Inset batasan celah ruangan di dalam pada elemen shimmer (padding).
  final EdgeInsets? padding;
  
  /// Konfigurasi opsional warna pudar dasar pembentuk latar shimmer.
  final Color? baseColor;

  /// Metode bawaan framework Flutter dalam menghasilkan dan menggambar UI.
  @override
  Widget build(BuildContext context) {
    // Menginstansiasi pustaka Shimmer untuk animasi berkelip antar 2 set warna
    return Shimmer.fromColors(
      // Menerapkan warna latar sesuai pemberian parameter, andai tiada guna warna keabuan pudar
      baseColor: baseColor ?? Colors.grey.shade300,
      // Mengunci sorot kedipan bercahaya melintasi kotak agar tampak berwarna putih
      highlightColor: Colors.white,
      // Anak elemen dibentuk via komponen modular `SkyBox` sebagai tubuh wujud geometrinya
      child: SkyBox(
        // Melimpahkan pengaturan margin ke komponen kotak
        margin: margin,
        // Melimpahkan pengaturan padding ke komponen kotak
        padding: padding,
        // Mengalokasikan nilai tinggi komponen
        height: height,
        // Mengalokasikan nilai lebar komponen
        width: width,
        // Karena SkyBox membuat kotak, agar berubah melingkar radius diatur selebar tingginya penuh
        borderRadius: height,
        // Mengatur ketinggian (shadow elevation) datar tak terangkat
        elevation: 0,
        // Konten internal direduksi memadat kosong lewat `SizedBox.shrink()`
        child: const SizedBox.shrink(),
      ),
    );
  }
}
