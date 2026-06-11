import '/ui/widgets/sky_box.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget [ShimmerBox] digunakan untuk menampilkan efek loading (shimmer)
/// berbentuk kotak persegi (box).
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.baseColor,
  });

  /// Tinggi dari kotak shimmer.
  final double? height;
  
  /// Lebar dari kotak shimmer.
  final double? width;
  
  /// Radius sudut (lengkungan) dari kotak shimmer. Defaultnya adalah 6.
  final double? borderRadius;
  
  /// Margin (jarak luar) di sekitar kotak shimmer.
  final EdgeInsets? margin;
  
  /// Warna dasar dari efek shimmer. Jika tidak diisi, akan menggunakan warna abu-abu.
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: Colors.white,
      child: SkyBox(
        margin: margin,
        height: height,
        width: width,
        borderRadius: borderRadius ?? 6,
        enabledCard: false,
        color: Colors.grey,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
