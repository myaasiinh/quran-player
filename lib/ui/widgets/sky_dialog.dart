import 'package:quran_player/ui/widgets/sky_appbar.dart';
/* author
   myaasiinh@gmail.com
*/

import '/config/themes/app_colors.dart';
import '/core/extension/context_extension.dart';
import '/ui/widgets/sky_button.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkyDialog extends StatelessWidget {
  const SkyDialog({required this.child, super.key, this.padding, this.margin});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Wrap(
            children: [
              Container(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                margin: margin ?? const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: (Get.isDarkMode) ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (Get.isDarkMode) ? AppColors.primary : Colors.black,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogAlert extends StatelessWidget {
  const DialogAlert({
    required this.title,
    required this.description,
    required this.header,
    required this.onConfirm,
    required this.backgroundColorHeader,
    required this.isDismissible,
    super.key,
    this.onCancel,
    this.confirmText = 'Ya',
    this.cancelText,
    this.confirmColor,
    this.cancelColor,
  });

  factory DialogAlert.success({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          child: header ??
              const SkyImage(src: AppIcons.icSuccess, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
        confirmColor: Colors.green,
      );

  factory DialogAlert.error({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          child: header ??
              const SkyImage(src: AppIcons.icFailed, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
        confirmColor: Colors.red[700],
      );

  factory DialogAlert.warning({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required bool isDismissible,
    String? confirmText,
    String? cancelText,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: header ??
            const SkyImage(
              src: AppIcons.icWarning,
              color: Colors.orange,
              fit: BoxFit.contain,
            ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText ?? 'Ya',
        cancelText: cancelText,
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );

  factory DialogAlert.retry({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required bool isDismissible,
    String? confirmText,
    String? cancelText,
    Widget? header,
    Color? backgroundColorHeader,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        confirmText: confirmText ?? 'txt_try_again'.tr,
        cancelText: cancelText,
        isDismissible: isDismissible,
        header: Padding(
          padding: const EdgeInsets.all(6),
          child: header ??
              const SkyImage(src: AppIcons.icFailed, fit: BoxFit.contain),
        ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );

  factory DialogAlert.force({
    required String title,
    required String confirmText,
    required String description,
    required VoidCallback onConfirm,
    required bool isDismissible,
    Widget? header,
    Color? backgroundColorHeader,
    VoidCallback? onCancel,
  }) =>
      DialogAlert(
        title: title,
        description: description,
        isDismissible: isDismissible,
        header: header ??
            const SkyImage(
              src: AppIcons.icWarning,
              color: Colors.orange,
              fit: BoxFit.contain,
            ),
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        backgroundColorHeader:
            backgroundColorHeader ?? Get.theme.scaffoldBackgroundColor,
      );
  final String title;
  final String description;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? header;
  final Color? backgroundColorHeader;
  final Color? confirmColor;
  final Color? cancelColor;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  margin: const EdgeInsets.only(top: 26),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (Get.isDarkMode) ? AppColors.primary : Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 64),
                      Text(
                        title,
                        style: context.typography.subtitle3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      SkyButton(
                        text: confirmText,
                        color: confirmColor ?? AppColors.primary,
                        onPressed: onConfirm,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: onCancel != null,
                        child: SkyButton(
                          text: cancelText ?? 'txt_no'.tr,
                          fontWeight: FontWeight.w600,
                          color: cancelColor ?? AppColors.primary,
                          onPressed: onCancel,
                          outlineMode: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: backgroundColorHeader,
                radius: 50,
                child: header,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
