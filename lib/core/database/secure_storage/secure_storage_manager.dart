import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Instance global dari [FlutterSecureStorage] yang diambil menggunakan [Get.find].
FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();

/// Kelas manajer untuk mengelola penyimpanan data yang aman (secure storage).
/// 
/// Menyediakan metode-metode untuk menyimpan, membaca, dan menghapus
/// token otentikasi serta refresh token.
class SecureStorageManager {
  /// Mengambil instance [SecureStorageManager] yang sudah terdaftar di GetX.
  static SecureStorageManager get find => Get.find<SecureStorageManager>();

  // Kunci untuk menyimpan token.
  final String _tokenKey = 'token';
  // Kunci untuk menyimpan refresh token.
  final String _refreshTokenKey = 'refresh_token';

  /// Memeriksa apakah pengguna sedang login berdasarkan ketersediaan token.
  /// 
  /// Mengembalikan [true] jika token tersedia dan tidak kosong, jika tidak [false].
  Future<bool> isLoggedIn() async {
    return (await getToken() != '');
  }

  /// Mengambil token otentikasi yang tersimpan.
  /// 
  /// Mengembalikan nilai token berupa [String] jika ada, atau [null] jika tidak ada.
  Future<String?> getToken() async {
    return secureStorage.read(key: _tokenKey);
  }

  /// Menyimpan token otentikasi.
  /// 
  /// Parameter [value] adalah string token yang ingin disimpan.
  Future setToken({required String? value}) async {
    return secureStorage.write(key: _tokenKey, value: value);
  }

  /// Mengambil refresh token yang tersimpan.
  /// 
  /// Mengembalikan nilai refresh token berupa [String] jika ada, atau [null] jika tidak ada.
  Future<String?> getRefreshToken() async {
    return secureStorage.read(key: _refreshTokenKey);
  }

  /// Menyimpan refresh token.
  /// 
  /// Parameter [value] adalah string refresh token yang ingin disimpan.
  Future setRefreshToken({required String? value}) async {
    return secureStorage.write(key: _refreshTokenKey, value: value);
  }

  /// Melakukan proses logout dengan menghapus (mengosongkan) token dan refresh token yang tersimpan.
  Future logout() async {
    await setToken(value: '');
    await setRefreshToken(value: '');
  }
}
