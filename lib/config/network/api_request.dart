import 'dart:convert';
import 'dart:io';

import 'package:quran_player/core/database/secure_storage/secure_storage_manager.dart';
import 'package:quran_player/core/helper/app_logger.dart';

import '/config/network/api_config.dart';
import '/config/network/api_exception.dart';
import 'package:dio/dio.dart';

/* author
   myaasiinh@gmail.com
*/

Map<String, String> headers = {HttpHeaders.authorizationHeader: ''};

/// Base Request for calling API.
/// * Can be modify as needed.
class ApiRequest {
  static final _networkUtils = NetworkUtilsRequest();

  static Future<Response> post({
    required String url,
    bool useToken = true,
    String? contentType = Headers.jsonContentType,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _networkUtils.tokenManager(useToken);
    return _networkUtils.safeFetch(
      () => DioClient.find.post(
        url,
        data: _networkUtils.setBody(contentType: contentType, body: body),
        options: Options(headers: headers, contentType: contentType),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  static Future<Response> get({
    required String url,
    bool useToken = true,
    String? contentType = Headers.jsonContentType,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _networkUtils.tokenManager(useToken);
    return _networkUtils.safeFetch(
      () => DioClient.find.get(
        url,
        options: Options(headers: headers, contentType: contentType),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  static Future<Response> patch({
    required String url,
    bool useToken = true,
    String? contentType = Headers.jsonContentType,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _networkUtils.tokenManager(useToken);
    return _networkUtils.safeFetch(
      () => DioClient.find.patch(
        url,
        data: _networkUtils.setBody(contentType: contentType, body: body),
        options: Options(headers: headers, contentType: contentType),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  static Future<Response> put({
    required String url,
    bool useToken = true,
    String? contentType = Headers.jsonContentType,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _networkUtils.tokenManager(useToken);
    return _networkUtils.safeFetch(
      () => DioClient.find.put(
        url,
        data: _networkUtils.setBody(contentType: contentType, body: body),
        options: Options(headers: headers, contentType: contentType),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  static Future<Response> delete({
    required String url,
    bool useToken = true,
    String? contentType = Headers.jsonContentType,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _networkUtils.tokenManager(useToken);
    return _networkUtils.safeFetch(
      () => DioClient.find.delete(
        url,
        data: _networkUtils.setBody(contentType: contentType, body: body),
        options: Options(headers: headers, contentType: contentType),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }
}

final class NetworkUtilsRequest with NetworkException {
  Object? setBody({required String? contentType, required Object? body}) {
    if (contentType == Headers.jsonContentType) {
      return body = jsonEncode(body);
    } else if (contentType == Headers.formUrlEncodedContentType) {
      return body;
    } else if (contentType == Headers.multipartFormDataContentType) {
      (body! as Map<String, dynamic>).removeWhere((k, v) => v == null);
      return FormData.fromMap(body as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> tokenManager(bool useToken) async {
    DioClient.setInterceptor();
    final token = await SecureStorageManager.find.getToken();
    if (useToken && token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    } else {
      headers.clear();
    }
  }

  Future<Response> safeFetch(Future<Response> Function() tryFetch) async {
    try {
      final response = await tryFetch();
      // return ApiResponse.fromJson(response.data);
      return response;
    } on DioException catch (e, stackTrace) {
      AppLogger.debug('Api Request -> $e, $stackTrace');
      throw getErrorException(e);
    } catch (e, stackTrace) {
      AppLogger.debug('Api Request -> $e, $stackTrace');
      rethrow;
    }
  }
}
