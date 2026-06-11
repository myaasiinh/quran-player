import '/ui/widgets/shimmer/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Widget [ShimmerText] digunakan untuk menampilkan efek loading (shimmer)
/// berbentuk kotak yang mensimulasikan bentuk dari teks.
class ShimmerText extends StatelessWidget {
  const ShimmerText({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.margin,
    this.padding,
    this.baseColor,
  });

  /// Factory untuk membuat skeleton teks ukuran besar (displayLarge).
  factory ShimmerText.displayLarge({double? width}) =>
      ShimmerText(height: 24, width: width);

  /// Factory untuk membuat skeleton teks ukuran cukup besar (displaySmall).
  factory ShimmerText.displaySmall({double? width}) =>
      ShimmerText(height: 18, width: width);

  /// Factory untuk membuat skeleton teks judul utama besar (headlineLarge).
  factory ShimmerText.headlineLarge({double? width}) =>
      ShimmerText(height: 16, width: width);

  /// Factory untuk membuat skeleton teks judul utama menengah (headlineMedium).
  factory ShimmerText.headlineMedium({double? width}) =>
      ShimmerText(height: 16, width: width);

  /// Factory untuk membuat skeleton teks judul utama kecil (headlineSmall).
  factory ShimmerText.headlineSmall({double? width}) =>
      ShimmerText(height: 14, width: width);

  /// Factory untuk membuat skeleton teks tubuh paragraf besar (bodyLarge).
  factory ShimmerText.bodyLarge({double? width}) =>
      ShimmerText(height: 16, width: width);

  /// Factory untuk membuat skeleton teks tubuh paragraf menengah (bodyMedium).
  factory ShimmerText.bodyMedium({double? width}) =>
      ShimmerText(height: 14, width: width);

  /// Factory untuk membuat skeleton teks tubuh paragraf kecil (bodySmall).
  factory ShimmerText.bodySmall({double? width}) =>
      ShimmerText(height: 12, width: width);

  /// Tinggi dari skeleton teks (menentukan ketebalan baris teks).
  final double? height;
  
  /// Lebar dari skeleton teks.
  final double? width;
  
  /// Radius sudut skeleton.
  final double? radius;
  
  /// Margin di sekitar skeleton teks.
  final EdgeInsets? margin;
  
  /// Padding di dalam skeleton teks.
  final EdgeInsets? padding;
  
  /// Warna dasar dari skeleton teks.
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      borderRadius: 4,
      height: height ?? 14,
      width: width ?? double.infinity,
    );
  }
}
