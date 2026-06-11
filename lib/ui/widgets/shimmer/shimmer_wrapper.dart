import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget [ShimmerWrapper] digunakan untuk membungkus widget apapun (misalnya Icon, Text)
/// dengan efek kilau (shimmer) sehingga tampak seperti sedang dimuat.
class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({
    required this.child,
    super.key,
    this.align,
    this.baseColor,
  });

  /// Widget anak yang akan diberikan efek shimmer.
  final Widget child;
  
  /// Penyelarasan (alignment) dari widget anak. Defaultnya adalah topCenter.
  final AlignmentGeometry? align;
  
  /// Warna dasar dari efek shimmer. Jika tidak diisi, akan menggunakan abu-abu cerah.
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align ?? Alignment.topCenter,
      child: Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade300,
        highlightColor: Colors.white,
        child: child,
      ),
    );
  }
}
