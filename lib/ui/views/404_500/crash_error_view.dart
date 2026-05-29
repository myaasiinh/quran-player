import '/config/themes/generated/assets.gen.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrashErrorView extends StatelessWidget {
  const CrashErrorView({required this.errorDetails, super.key});
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkyImage(src: Assets.images.imgError.path, height: 144),
            const SizedBox(height: 16),
            Text(
              kDebugMode
                  ? errorDetails.summary.toString()
                  : 'txt_crash_error_title'.tr,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: kDebugMode
                    ? Get.theme.colorScheme.error
                    : Get.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              kDebugMode
                  ? errorDetails.exceptionAsString()
                  : 'txt_crash_error_message'.tr,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
