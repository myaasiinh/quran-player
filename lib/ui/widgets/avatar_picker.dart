import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'dart:io';

import '/core/helper/bottom_sheet_helper.dart';
import '/core/helper/media_helper.dart';
import '/ui/widgets/media/attachments_source_bottom_sheet.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.onAvatarSelected,
    super.key,
    this.imagePath,
    this.editWidget,
    this.hideRemove = false,
    this.enabled = true,
    this.namePlaceholder,
    this.onRemoveImage,
    this.editIcon,
    this.editBackgroundColor,
  });

  final String? imagePath;
  final String? namePlaceholder;
  final Widget? editWidget;
  final Widget? editIcon;
  final Color? editBackgroundColor;
  final bool hideRemove;
  final bool enabled;
  final void Function(File) onAvatarSelected;
  final VoidCallback? onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          GestureDetector(
            onTap: enabled ? _onPickAvatar : null,
            child: SkyImage(
              width: 80,
              height: 80,
              shapeImage: ShapeImage.oval,
              src: imagePath ??
                  (namePlaceholder != null
                      ? MediaHelper.generateAvatarByName(
                          namePlaceholder.toString(),
                        )
                      : AppImages.imgPlaceholderUser),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: enabled ? _onPickAvatar : null,
              child: editWidget ??
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: editBackgroundColor ?? Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: editIcon ??
                        const Icon(
                          Icons.mode_edit,
                          size: 15.9,
                          color: Colors.black,
                        ),
                  ),
            ),
          ),
          if (imagePath != null && !hideRemove)
            GestureDetector(
              onTap: onRemoveImage,
              child: Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15.9,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onPickAvatar() async {
    await BottomSheetHelper.bar(
      child: AttachmentsSourceBottomSheet(
        allowMultiple: false,
        withImageCompression: true,
        onAttachmentsSelected: onAvatarSelected,
        onMultipleAttachmentsSelected: (results) {},
      ),
    );
  }
}
