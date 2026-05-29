// import '/config/themes/app_colors.dart';
// import '/ui/views/sample_feature/detail/widgets/sample_feature_detail_header.dart';
// import '/ui/widgets/shimmer/sample_feature/shimmer_sample_feature_list.dart';
// import '/ui/widgets/shimmer/shimmer_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';

// class ShimmerSampleFeatureDetail extends StatelessWidget {
//   const ShimmerSampleFeatureDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final baseDark = Colors.grey[700] ?? Colors.grey;
//     final baseLight = Colors.grey[300] ?? Colors.grey;

//     return SingleChildScrollView(
//       child: Shimmer.fromColors(
//         baseColor: Get.isDarkMode ? baseDark : baseLight,
//         highlightColor: Colors.white,
//         child: const Column(
//           children: [
//             SampleFeatureDetailHeader(),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 12),
//                   ShimmerText(),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.location_city),
//                       Expanded(child: ShimmerText()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on),
//                       Expanded(child: ShimmerText()),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             DefaultTabController(
//               length: 3,
//               child: Column(
//                 children: [
//                   TabBar(
//                     labelColor: AppColors.primary,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: AppColors.secondary,
//                     tabs: [
//                       Tab(text: 'Repositories'),
//                       Tab(text: 'Followers'),
//                       Tab(text: 'Followings'),
//                     ],
//                   ),
//                   ShimmerSampleFeatureList(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
