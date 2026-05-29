import 'package:quran_player/core/helper/app_logger.dart';

import '/config/network/api_token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/* author
   myaasiinh@gmail.com
*/
final class ApiInterceptors extends ApiTokenManager
    implements QueuedInterceptorsWrapper {
  ApiInterceptors(this._dio);
  final Dio _dio;

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      AppLogger.debug('');
      AppLogger.debug('# REQUEST');
      AppLogger.debug('--> ${options.method.toUpperCase()} - ${options.uri}');
      AppLogger.debug('Headers: ${options.headers}');
      AppLogger.debug('Query Params: ${options.queryParameters}');
      AppLogger.debug('Body: ${options.data}');

      if (options.data is FormData) {
        AppLogger.debug('Body: ${(options.data as FormData).fields}');
      }
      AppLogger.debug('--> END ${options.method.toUpperCase()}');
    }
    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      AppLogger.debug('');
      AppLogger.debug('# RESPONSE');
      AppLogger.debug('<-- ${response.requestOptions.uri}');
      AppLogger.debug('Status Code : ${response.statusCode} ');
      AppLogger.debug('Headers: ${response.headers}');
      AppLogger.debug('Response: ${response.data}');
      AppLogger.debug('<-- END HTTP');
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      AppLogger.debug('');
      AppLogger.debug('# ERROR');
      AppLogger.debug('<-- ${err.response?.requestOptions.baseUrl}');
      AppLogger.debug('Status Code : ${err.response?.statusCode} ');
      AppLogger.debug('Error Message : ${err.error} ');
      AppLogger.debug('Error Message : ${err.message} ');
      AppLogger.debug(
          'Error Response Message : ${err.response?.statusMessage} ');
      AppLogger.debug('Response Path : ${err.response?.requestOptions.uri}');
      AppLogger.debug('<-- End HTTP');
    }
    await handleToken(dio: _dio, err: err, handler: handler);
  }
}
