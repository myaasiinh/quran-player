/* author
   myaasiinh@gmail.com
*/

import 'dart:convert';
import 'dart:developer';

import '/core/database/storage/cache_data.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/extension/string_extension.dart';
import '/data/sources/local/cached_model_converter.dart';

/// Mixin yang menyediakan fungsi-fungsi dasar untuk mengelola cache data.
/// Memudahkan penyimpanan, pengambilan, dan penghapusan data cache
/// dengan dukungan JSON encoding/decoding.
mixin CacheMixin {
  /// Tag logging untuk kelas ini.
  final String _tag = 'CacheMixin::->';

  /// Instance dari [StorageManager] yang digunakan untuk mengakses penyimpanan.
  StorageManager storage = StorageManager.find;

  /// Mengambil daftar objek bertipe [T] dari cache berdasarkan [key].
  /// Mengembalikan list kosong jika cache tidak ditemukan atau kosong.
  Future<List<T>> getCachedList<T>({required String key}) async {
    log('get cached, key: $key');

    final dynamic cache = storage.get(key);
    if (storage.has(key) && cache.toString().isNotEmpty) {
      final cacheData = CacheData.fromJson(
        jsonDecode(cache as String) as Map<String, dynamic>,
      );
      _logging(cacheData, key);
      return List<T>.from(
        (jsonDecode(cacheData.value as String) as List).map(
          (x) => CachedModelConverter<T>().fromJson(x),
        ),
      );
    } else {
      return [];
    }
  }

  /// Menyimpan daftar objek bertipe [T] ke dalam cache menggunakan [key].
  Future<void> saveCachedList<T>({
    required String key,
    required List<T> list,
  }) async {
    log('$_tag save cache, key: $key');
    await storage.save<String>(
      key,
      jsonEncode(CacheData(value: jsonEncode(list))),
    );
  }

  /// Mengambil objek tunggal bertipe [T] dari cache berdasarkan [key].
  /// Akan memvalidasi apakah id dari cache sama dengan [cachedId] atau [customFieldId].
  Future<T?> getCacheObject<T>({
    required String key,
    required String? cachedId,
    String? customFieldId,
  }) async {
    log('$_tag get cache, key : $key');
    log('$_tag cache id : ${cachedId != null && cachedId.isNotEmpty}');
    final dynamic cache = await storage.get(key);
    if (storage.has(key) && cache.toString().isNotNullAndNotEmpty) {
      final cacheData = CacheData.fromJson(
        jsonDecode(cache as String) as Map<String, dynamic>,
      );
      _logging(cacheData, key);
      final cacheMap = cacheData.value as Map<String, dynamic>;
      if (cachedId == _getId(cache: cacheMap, customFieldId: customFieldId)) {
        return CachedModelConverter<T>().fromJson(cacheMap);
      }
    }
    return null;
  }

  /// Mengambil nilai ID dari sebuah map [cache], atau menggunakan [customFieldId] jika tersedia.
  String _getId({required Map<String, dynamic> cache, String? customFieldId}) {
    if (customFieldId != null) return customFieldId;
    return cache['id'].toString();
  }

  /// Menyimpan sebuah objek tunggal ke dalam cache dengan [key] tertentu.
  Future<void> saveCachedObject<T>({
    required String key,
    required T data,
  }) async {
    await storage.save<String>(
      key,
      jsonEncode(CacheData(value: data).toJson()),
    );
  }

  /// Menghapus data cache yang terkait dengan [key] tertentu.
  Future<void> deleteCached(String key) async {
    await storage.delete(key);
  }

  /// Melakukan logging terkait informasi data cache, seperti waktu kadaluarsa.
  void _logging(CacheData cacheData, String key) {
    log('$_tag get cache $key');
    log('$_tag expiry: ${cacheData.expiredDate}');
    log(
      '$_tag Expired in: ${DateTime.now().difference(cacheData.expiredDate).inMinutes} minutes',
    );
    log('$_tag isExpired: ${cacheData.expiredDate.isBefore(DateTime.now())}');
  }
}
