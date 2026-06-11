import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget [ShimmerWrapper] digunakan untuk memberikan efek kilau (shimmer)
/// pada widget anak (child) yang diberikan. Biasanya digunakan untuk 
/// menunjukkan status pemuatan (loading) pada antarmuka pengguna.
class ShimmerWrapper extends StatelessWidget {
  /// Konstruktor untuk membuat instance dari [ShimmerWrapper].
  const ShimmerWrapper({
    required this.child,
    super.key,
    this.align,
    this.baseColor,
  });

  /// Widget anak yang akan dibungkus dengan efek shimmer.
  final Widget child;
  
  /// Penyelarasan (alignment) dari widget anak. 
  /// Jika tidak diberikan, secara bawaan akan menggunakan [Alignment.topCenter].
  final AlignmentGeometry? align;
  
  /// Warna dasar dari efek shimmer. 
  /// Jika tidak diberikan, akan menggunakan warna abu-abu terang (grey 300).
  final Color? baseColor;

  /// Membangun antarmuka pengguna untuk widget ini.
  @override
  Widget build(BuildContext context) {
    // Membungkus dengan widget Align untuk mengatur posisi anak
    return Align(
      // Mengatur properti alignment, gunakan topCenter jika align bernilai null
      alignment: align ?? Alignment.topCenter,
      // Menggunakan Shimmer.fromColors untuk memberikan efek kilau berdasarkan warna
      child: Shimmer.fromColors(
        // Menentukan warna dasar shimmer, gunakan grey.shade300 jika null
        baseColor: baseColor ?? Colors.grey.shade300,
        // Menentukan warna sorotan shimmer sebagai putih
        highlightColor: Colors.white,
        // Menyisipkan widget anak yang akan diberikan efek
        child: child,
      ),
    );
  }
}
