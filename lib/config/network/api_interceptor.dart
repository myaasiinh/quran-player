import 'package:dio/dio.dart';
import 'package:quran_player/core/helper/app_logger.dart';

import '/config/network/api_token_manager.dart';

/* author
   myaasiinh@gmail.com
*/

/// [ApiInterceptors] menangani logging dan manajemen token untuk setiap request HTTP.
/// Principal Note: Memisahkan concern logging dan penanganan error ke dalam interceptor Dio.
base class ApiInterceptors extends ApiTokenManager {
  ApiInterceptors(this._dio);
  final Dio _dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Mencatat log detail request sebelum dikirim ke server.
    AppLogger.debug('--> ${options.method} ${options.uri}');
    AppLogger.debug('Headers: ${options.headers}');
    AppLogger.debug('Body: ${options.data}');
    AppLogger.debug('--> END ${options.method}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    /// Mencatat log respon sukses dari server.
    AppLogger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
    );
    AppLogger.debug('Data: ${response.data}');
    AppLogger.debug('<-- END HTTP');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    /// Mencatat log jika terjadi kegagalan pada request HTTP.
    AppLogger.debug(
      '<-- ${err.response?.statusCode} ${err.response?.requestOptions.uri}',
    );
    AppLogger.debug('Message: ${err.message}');

    if (err.response != null) {
      AppLogger.debug('Response Data: ${err.response?.data}');
    }
    AppLogger.debug('<-- END HTTP');

    /// Mendelegasikan penanganan token (refresh/unauthorized) ke parent class.
    await handleToken(dio: _dio, err: err, handler: handler);
  }
}
