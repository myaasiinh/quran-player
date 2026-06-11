import '/ui/widgets/shimmer/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Widget [ShimmerButton] digunakan untuk menampilkan efek loading animasi (shimmer).
/// Widget ini memiliki bentuk yang menyerupai tombol pada umumnya.
class ShimmerButton extends StatelessWidget {
  /// Konstruktor konstan untuk membuat widget [ShimmerButton].
  const ShimmerButton({super.key, this.height, this.width});

  /// Menentukan tinggi dari tombol shimmer. Jika null, defaultnya adalah 40.
  final double? height;
  
  /// Menentukan lebar dari tombol shimmer. Jika null, akan mengambil lebar maksimal yang tersedia.
  final double? width;

  /// Metode [build] untuk menggambar antarmuka widget di layar.
  @override
  Widget build(BuildContext context) {
    // Mengembalikan widget ShimmerBox dengan ukuran yang disesuaikan
    return ShimmerBox(
      // Menggunakan tinggi yang diberikan atau 40 sebagai fallback
      height: height ?? 40, 
      // Menggunakan lebar yang diberikan atau lebar maksimal ruang kosong sebagai fallback
      width: width ?? double.infinity,
    );
  }
}
