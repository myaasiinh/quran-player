import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:quran_player/core/helper/app_logger.dart';

import '/config/auth_manager/auth_manager.dart';
import '/config/environment/app_env.dart';
import '/config/network/api_exception.dart';
import '/config/network/api_response.dart';
import '/core/database/secure_storage/secure_storage_manager.dart';
import '/core/helper/dialog_helper.dart';

/* author
   myaasiinh@gmail.com
*/

/// Tipe token yang didukung oleh aplikasi.
enum TokenType {
  /// Tanpa autentikasi token.
  NONE,

  /// Hanya menggunakan Access Token.
  ACCESS_TOKEN,

  /// Menggunakan mekanisme penyegaran (Access + Refresh Token).
  REFRESH_TOKEN,
}

/// [ApiTokenManager] mengelola siklus hidup token autentikasi pada level network.
/// Principal Note: Menggunakan QueuedInterceptorsWrapper untuk menangani refresh token secara sekuensial.
abstract base class ApiTokenManager extends QueuedInterceptorsWrapper
    with NetworkException {
  final AuthManager authManager = AuthManager.find;
  final SecureStorageManager secureStorage = SecureStorageManager.find;

  /// [handleToken] memutuskan tindakan berdasarkan tipe kegagalan token.
  Future<void> handleToken({
    required Dio dio,
    required DioException err,
    required ErrorInterceptorHandler handler,
  }) async {
    switch (AppEnv.config.tokenType) {
      case TokenType.NONE:
        super.onError(err, handler);
      case TokenType.ACCESS_TOKEN:
        await _handleAccessToken(err, handler);
      case TokenType.REFRESH_TOKEN:
        await _handleRefreshToken(dio, err, handler);
    }
  }

  /// Menangani kegagalan Access Token statis (biasanya logout jika 401).
  Future<void> _handleAccessToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode ?? 0;
    if (status == 401) {
      await DialogHelper.failed(
        isDismissible: false,
        message: 'txt_you_must_login_again'.tr,
        onConfirm: () => unawaited(authManager.logout()),
      );
      super.onError(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  /// Menangani logika penyegaran token otomatis (Silent Refresh).
  Future<void> _handleRefreshToken(
    Dio dio,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final accessToken = await secureStorage.getToken();
    final refreshToken = await secureStorage.getRefreshToken();
    
    /// Jika terjadi 401 dan token tersedia, coba ambil token baru.
    if (accessToken != null && err.response?.statusCode == 401) {
      final newToken = await _getAccessToken(
        refreshToken: refreshToken.toString(),
      );
      await secureStorage.setToken(value: newToken.toString());
      
      /// Lakukan retry request asli dengan token baru.
      return handler.resolve(await _retry(dio, err.requestOptions));
    } else {
      super.onError(err, handler);
    }
  }

  /// Meminta token baru ke server menggunakan Refresh Token.
  Future<String?> _getAccessToken({required String refreshToken}) async {
    try {
      final responseBody = await Dio().post(
        '${AppEnv.config.baseUrl}/auth/refresh',
        data: jsonEncode({'refresh_token': refreshToken}),
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ),
      );
      final data =
          ApiResponse.fromJson(responseBody.data as Map<String, dynamic>).data
              as Map<String, dynamic>;
      return data['token'] as String?;
    } on DioException catch (error) {
      AppLogger.debug(getErrorException(error).toString());
      return DialogHelper.failed(
        isDismissible: false,
        message: 'txt_you_must_login_again'.tr,
        onConfirm: () => unawaited(authManager.logout()),
      );
    }
  }

  /// Melakukan percobaan ulang (retry) request yang gagal setelah token diperbarui.
  Future<Response<dynamic>> _retry(
    Dio dio,
    RequestOptions requestOptions,
  ) async {
    final newAccessToken = await secureStorage.getToken() ?? '';
    final options = Options(
      method: requestOptions.method,
      headers: {'Authorization': 'Bearer $newAccessToken'},
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
