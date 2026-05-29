import 'package:dio/dio.dart';

class RequestParams {
  RequestParams({
    required this.cancelToken,
    this.cachedKey,
    this.cachedId,
  });
  CancelToken cancelToken;
  String? cachedKey;
  String? cachedId;
}
