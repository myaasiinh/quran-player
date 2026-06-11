import '/ui/widgets/shimmer/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Widget [ShimmerButton] digunakan untuk menampilkan efek loading (shimmer)
/// dengan bentuk menyerupai tombol.
class ShimmerButton extends StatelessWidget {
  const ShimmerButton({super.key, this.height, this.width});

  /// Tinggi dari tombol shimmer. Defaultnya adalah 40.
  final double? height;
  
  /// Lebar dari tombol shimmer. Defaultnya mengambil lebar maksimal yang tersedia (infinity).
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      height: height ?? 40, 
      width: width ?? double.infinity,
    );
  }
}
