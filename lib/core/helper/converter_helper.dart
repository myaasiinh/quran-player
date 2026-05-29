import 'dart:convert';
import 'dart:io';

import 'package:quran_player/core/helper/app_logger.dart';

class ConverterHelper {
  static String toBase64({File? imageFile, File? file}) {
    try {
      if (imageFile != null) {
        final bytes = imageFile.readAsBytesSync();
        final img64Path = base64Encode(bytes);
        return img64Path;
      } else if (file != null) {
        final bytes = File(file.path).readAsBytesSync();
        final file64Path = base64Encode(bytes);
        return file64Path;
      } else {
        return 'Anda belum memilih file';
      }
    } catch (e) {
      AppLogger.debug('toBase64 Exception : $e');
      return e.toString();
    }
  }

  /// Convert string into new string at specific index.
  /// * Example : [oldString] = 'abc', [index] = 2, [newChar] = '$', Result --> a$b
  static String replaceStringAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  /// Convert string into new string. Used to hidden string like a email, phone number, etc.
  /// * Example :
  ///
  /// [oldString] = name@email.com,
  ///
  /// [index] = 2,
  ///
  /// [newChar] = *
  ///
  /// --> Result will = na****mail.com
  static String replaceStringRange(
    String sentence,
    int start,
    int end,
    String newChar,
  ) {
    for (var i = start; i < end + 1; i++) {
      sentence = ConverterHelper.replaceStringAt(sentence, i, newChar);
    }
    return sentence;
  }
}
