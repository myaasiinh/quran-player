import '/ui/widgets/sky_box.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget [ShimmerCircle] digunakan untuk menampilkan efek loading (shimmer)
/// dengan bentuk lingkaran.
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.baseColor,
  });

  /// Tinggi dari lingkaran shimmer. Juga digunakan untuk menghitung radius lingkaran.
  final double? height;
  
  /// Lebar dari lingkaran shimmer.
  final double? width;
  
  /// Margin (jarak luar) di sekitar lingkaran shimmer.
  final EdgeInsets? margin;
  
  /// Padding (jarak dalam) di dalam lingkaran shimmer.
  final EdgeInsets? padding;
  
  /// Warna dasar dari efek shimmer. Jika tidak diisi, akan menggunakan warna abu-abu.
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: Colors.white,
      child: SkyBox(
        margin: margin,
        padding: padding,
        height: height,
        width: width,
        // Mengatur border radius sebesar tinggi agar menjadi lingkaran penuh
        borderRadius: height,
        elevation: 0,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
