import 'dart:async';
import 'dart:convert';

import 'package:quran_player/core/helper/app_logger.dart';

import '/config/auth_manager/auth_manager.dart';
import '/config/environment/app_env.dart';
import '/config/network/api_exception.dart';
import '/config/network/api_response.dart';
import '/core/database/secure_storage/secure_storage_manager.dart';
import '/core/helper/dialog_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/* author
   myaasiinh@gmail.com
*/
enum TokenType {
  /// When your app no need token authentication.
  NONE,

  /// When your app just use Access Token.
  ACCESS_TOKEN,

  /// When your app use Refresh Token Mechanism (Access + Refresh).
  REFRESH_TOKEN,
}

abstract base class ApiTokenManager extends QueuedInterceptorsWrapper
    with NetworkException {
  final AuthManager authManager = AuthManager.find;
  final SecureStorageManager secureStorage = SecureStorageManager.find;

  Future<void> handleToken({
    required Dio dio,
    required DioException err,
    required ErrorInterceptorHandler handler,
  }) async {
    switch (AppEnv.config.tokenType) {
      case TokenType.NONE:
        super.onError(err, handler);
      case TokenType.ACCESS_TOKEN:
        // super.onError(err, handler);
        await _handleAccessToken(err, handler);
      case TokenType.REFRESH_TOKEN:
        await _handleRefreshToken(dio, err, handler);
    }
  }

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

  Future<void> _handleRefreshToken(
    Dio dio,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final accessToken = await secureStorage.getToken();
    final refreshToken = await secureStorage.getRefreshToken();
    if (accessToken != null && err.response?.statusCode == 401) {
      final newToken = await _getAccessToken(
        refreshToken: refreshToken.toString(),
      );
      await secureStorage.setToken(value: newToken.toString());
      return handler.resolve(await _retry(dio, err.requestOptions));
    } else {
      super.onError(err, handler);
    }
  }

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
