import 'package:dio/dio.dart';
import '/config/network/api_config.dart';

/* author
   myaasiinh@gmail.com
*/

/// [ApiRequest] adalah wrapper statis untuk menyederhanakan pemanggilan Dio.
/// Principal Note: Menggunakan singleton DioClient untuk menjamin penggunaan konfigurasi yang konsisten.
abstract class ApiRequest {
  /// Melakukan request HTTP GET.
  static Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    return DioClient.find.get(
      url,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  /// Melakukan request HTTP POST.
  static Future<Response<dynamic>> post({
    required String url,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    return DioClient.find.post(
      url,
      data: data,
      cancelToken: cancelToken,
    );
  }
}
