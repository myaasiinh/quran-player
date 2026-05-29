import 'dart:io';
import 'dart:math';

import 'package:quran_player/core/helper/app_logger.dart';

import '/core/helper/dialog_helper.dart';
import '/core/helper/permission_helper.dart';
import '/core/helper/snackbar_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FileHelper {
  static String getFileSizeString(String path, int decimals) {
    final bytes = File(path).lengthSync();
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  static Future<List<File>?> pickFile({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    final extensions = allowedExtensions ?? _defaultExtensions;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      allowMultiple: allowMultiple,
    );

    final data = result?.files.map((e) => File(e.path.toString())).toList();

    if (result != null) {
      /// Verify Extension
      /// Handle beberapa device android yang tidak support filter extension
      ///
      for (var i = 0; i < (result.paths.length); i++) {
        var isMatches = false;
        for (final allowedExtension in extensions) {
          if (result.paths[i]!.endsWith(allowedExtension)) {
            isMatches = true;
          }
        }
        if (!isMatches) {
          data?.removeAt(i);
          SnackBarHelper.error(message: 'Extension not allowed');
        }
      }
    }

    return data;
  }

  static List<String> get _defaultExtensions => [
        'pdf',
        'doc',
        'docx',
        'odt',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'csv',
        'psd',
        'txt',
        'zip',
        'rar',
      ];

  static Future<void> viewDownloadedFile(String savePath) async {
    try {
      final result = await OpenFilex.open(savePath);
      AppLogger.debug(result.message);
    } catch (e) {
      AppLogger.debug('error: $e');
    }
  }

  static Future<void> openDownloadedFolder(String folderPath) async {
    try {
      final result = await OpenFilex.open(folderPath);
      AppLogger.debug(result.message);
    } catch (e) {
      AppLogger.debug('error: $e');
    }
  }

  static Future<void> openPlatformDownloadedFolder(String folderPath) async {
    if (Platform.isIOS) {
      final downloadDir = Uri.tryParse('shareddocuments://$folderPath')!;
      await launchUrl(downloadDir);
    } else if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt > 29) {
        final isGranted = await PermissionHelper.manageExternalStorage();
        if (isGranted) await FileHelper.openDownloadedFolder(folderPath);
      } else {
        await FileHelper.openDownloadedFolder(folderPath);
      }
    }
  }

  static Future<void> downloadAndOpenFile({
    required String url,
    String? fileName,
  }) async {
    final name = fileName ?? url.split('/').last;
    final file = await downloadFilePath(url, name);
    AppLogger.debug('Path : $file');
    await OpenFilex.open(file);
  }

  static Future<String> downloadFilePath(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    try {
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed download, msg : $e');
    }
  }

  Future<Directory> getDirectory() async {
    Directory? directory;

    final hasGranted = await checkStoragePermission();
    if (hasGranted) {
      directory = await _prepareSaveDir();
    }

    return directory!;
  }

  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt < 33) {
        final permission = await Permission.storage.request();
        if (permission.isPermanentlyDenied) {
          LoadingDialog.dismiss();
          PermissionHelper.openSettings('txt_need_permission_storage'.tr);
          return false;
        } else if (permission.isGranted) {
          return true;
        } else if (permission.isDenied) {
          SnackBarHelper.error(message: 'txt_need_permission_storage'.tr);
          return false;
        }
      } else {
        ///
        /// For android 13+ (API 33+) you don't need permission pdf or file
        /// But you need to define every media permission
        /// Permission.photos
        /// Permission.videos
        /// Permission.audio
        ///
        final permission = await Permission.photos.request();
        if (permission.isPermanentlyDenied) {
          LoadingDialog.dismiss();
          PermissionHelper.openSettings('txt_need_permission_storage'.tr);
          return false;
        } else if (permission.isGranted) {
          return true;
        } else if (permission.isDenied) {
          SnackBarHelper.error(message: 'txt_need_permission_storage'.tr);
          return false;
        }
      }
    } else if (Platform.isIOS) {
      return true;
    }
    return false;
  }

  Future<Directory> _prepareSaveDir() async {
    final localPath = await _findSavedDir();
    final savedDir = Directory(localPath);
    final hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }

    return savedDir;
  }

  Future<String> _findSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      // final directory = await getExternalStorageDirectory();
      // externalStorageDirPath = directory?.absolute.path;
      externalStorageDirPath = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    } else {
      throw UnimplementedError(
        '_findLocalPath untuk platform ini belum dibuat',
      );
    }
    AppLogger.debug('externalStorageDirPath: $externalStorageDirPath');
    return externalStorageDirPath;
  }
}
