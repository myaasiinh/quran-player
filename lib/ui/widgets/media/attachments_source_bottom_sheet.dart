import 'dart:io';

import '/core/helper/file_helper.dart';
import '/core/helper/media_helper.dart';
import '/core/helper/permission_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/* author
   myaasiinh@gmail.com
*/
class AttachmentsSourceBottomSheet extends StatelessWidget {
  const AttachmentsSourceBottomSheet({
    required this.onAttachmentsSelected,
    required this.onMultipleAttachmentsSelected,
    super.key,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.cameraIcon = const Icon(Icons.camera_alt_rounded),
    this.galleryIcon = const Icon(Icons.image),
    this.fileIcon = const Icon(CupertinoIcons.doc_text_fill),
    this.cameraLabel,
    this.galleryLabel,
    this.fileLabel,
    this.withImageCompression = false,
    this.sizeLimit = 2000000,
    this.allowMultiple = true,
    this.allowedFileExtensions,
    this.enabledFileSource = true,
  });
  final double? maxHeight;
  final double? maxWidth;
  final int? imageQuality;
  final CameraDevice preferredCameraDevice;
  final void Function(File) onAttachmentsSelected;
  final void Function(List<File>) onMultipleAttachmentsSelected;

  final Widget? cameraIcon;
  final Widget? galleryIcon;
  final Widget? fileIcon;
  final Widget? cameraLabel;
  final Widget? galleryLabel;
  final Widget? fileLabel;
  final bool withImageCompression;
  final int sizeLimit;
  final bool allowMultiple;
  final List<String>? allowedFileExtensions;
  final bool enabledFileSource;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: cameraIcon,
          title: cameraLabel ?? Text('txt_camera'.tr),
          onTap: () => _onPickImage(ImageSource.camera),
        ),
        ListTile(
          leading: galleryIcon,
          title: galleryLabel ?? Text('txt_gallery'.tr),
          onTap: () => _onPickImage(ImageSource.gallery),
        ),
        if (enabledFileSource)
          ListTile(
            leading: fileIcon,
            title: fileLabel ?? Text('txt_document'.tr),
            onTap: _onPickFile,
          ),
      ],
    );
  }

  Future<void> _onPickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final isGranted = await PermissionHelper.isCameraGranted();
      if (isGranted) await _pickSingleImage(ImageSource.camera);
    } else {
      final isGranted = await _checkPermission();
      if (isGranted) {
        if (allowMultiple) {
          await _pickMultipleImage();
        } else {
          await _pickSingleImage(ImageSource.gallery);
        }
      }
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return PermissionHelper.isPhotoGranted();
    } else {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        return PermissionHelper.isStorageGranted(
          permanentlyDeniedMsg: 'txt_need_permission_gallery_photo'.tr,
        );
      } else {
        return PermissionHelper.isMultiplePermissionGranted(
          [
            Permission.photos,
            Permission.videos,
          ],
          deniedMsg: 'txt_need_permission_storage'.tr,
        );
      }
    }
  }

  Future<void> _pickSingleImage(ImageSource source) async {
    final pickedFile = await MediaHelper.pickImage(
      source: source,
      withCompression: withImageCompression,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      // sizeLimit: sizeLimit,
    );
    if (null != pickedFile) {
      onAttachmentsSelected(pickedFile);
      Get.back();
    }
  }

  Future<void> _pickMultipleImage() async {
    final result = await ImagePicker().pickMultiImage(
      maxHeight: withImageCompression ? 1024 : maxHeight,
      maxWidth: withImageCompression ? 1024 : maxWidth,
      imageQuality: imageQuality,
    );
    onMultipleAttachmentsSelected(result.map((e) => File(e.path)).toList());
    Get.back();
  }

  Future<void> _onPickFile() async {
    final result = await FileHelper.pickFile(
          allowMultiple: allowMultiple,
          allowedExtensions:
              allowedFileExtensions ?? MediaHelper.fileExtensions,
        ) ??
        [];
    onMultipleAttachmentsSelected(result);
    Get.back();
  }
}
