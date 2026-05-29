import '/ui/widgets/shimmer/shimmer_box.dart';
import 'package:flutter/material.dart';

class ShimmerButton extends StatelessWidget {
  const ShimmerButton({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(height: height ?? 40, width: width ?? double.infinity);
  }
}
