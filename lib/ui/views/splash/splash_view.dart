import '/config/themes/app_colors.dart';
import '/ui/widgets/colored_status_bar.dart';
import '/ui/widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    return const ColoredStatusBar(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(child: PlatformLoadingIndicator(color: Colors.white)),
      ),
    );

    // return ColoredStatusBar(
    //   brightness: Brightness.light,
    //   child: Scaffold(
    //     backgroundColor: AppColors.primary,
    //     body: ContentWrapper(
    //       bottom: true,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     height: 170,
    //                     width: 170,
    //                     padding: const EdgeInsets.all(20),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(180),
    //                       color: Colors.white,
    //                     ),
    //                     child: const FlutterLogo(),
    //                   ),
    //                   const SizedBox(height: 20),
    //                   Text(
    //                     AppConfiguration.appName,
    //                     style: AppStyle.headline2.copyWith(color: Colors.white),
    //                   ),
    //                   Text(
    //                     AppConfiguration.appTag,
    //                     style: const TextStyle(color: Colors.white),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Text(
    //               '${'txt_version'.tr} ${AppConfiguration.appVersion}',
    //               style: const TextStyle(color: Colors.white),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
