import '/ui/widgets/shimmer/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

/* author
   myaasiinh@gmail.com
*/
class ShimmerSampleFeatureItem extends StatelessWidget {
  const ShimmerSampleFeatureItem({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final shimmerColor = Get.isDarkMode ? Colors.black54 : Colors.white;
    final baseDark = Colors.grey[700] ?? Colors.grey;
    final baseLight = Colors.grey[300] ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Shimmer.fromColors(
        baseColor: Get.isDarkMode ? baseDark : baseLight,
        highlightColor: shimmerColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(radius: 30, backgroundColor: shimmerColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShimmerText(),
                  SizedBox(height: 4),
                  ShimmerText(),
                  SizedBox(height: 4),
                  ShimmerText(width: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
