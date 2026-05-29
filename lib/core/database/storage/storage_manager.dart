import 'dart:convert';

import 'package:quran_player/core/helper/app_logger.dart';

import '/core/database/storage/storage_key.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/* author
   myaasiinh@gmail.com
*/

/// ----Getx Storage----
///
/// Format -> Key == BoxName,
/// So one box contains one key --> One Box = One Data.
class StorageManager {
  static StorageManager get find => Get.find<StorageManager>();
  final GetStorage box = Get.find<GetStorage>();

  /// If you want to save Object/Model don't forget to encode toJson
  Future<void> save<T>(String name, T value) async {
    await box.write(name, value);
  }

  Future<void> delete(String name) async {
    await box.remove(name);
  }

  /// If you want to get Object/Model don't forget to decode fromJson
  dynamic get<T>(String name) {
    return box.read<T>(name);
  }

  bool has(String name) {
    return box.hasData(name);
  }

  String encodeList<T>(List<T> data) {
    return json.encode(data);
  }

  List<T> decodeList<T>(String data) {
    return (json.decode(data) as List).cast<T>();
  }

  dynamic getAwait(String name) async {
    return await box.read(name);
  }

  Future<void> logout() async {
    try {
      final permanentKeys = StorageKey.permanentKeys;
      final deleteKeys = (box.getKeys() as Iterable<String>).where((key) {
        return !permanentKeys.contains(key);
      }).toList();

      for (final key in deleteKeys) {
        await box.remove(key);
      }
    } catch (e) {
      AppLogger.debug(e.toString());
    }
  }
}
