import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/config/environment/app_env.dart';
import '/config/network/api_interceptor.dart';

/* author
   myaasiinh@gmail.com
*/
class DioClient extends GetxService {
  DioClient() {
    _dio = Dio();
    _dio.options.baseUrl = AppEnv.config.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _setInterceptor();
  }
  static Dio get find => Get.find<DioClient>()._dio;
  late Dio _dio;

  static void setInterceptor() {
    final dio = DioClient.find;
    dio.interceptors.clear();
    dio.interceptors.add(ApiInterceptors(dio));
  }

  void _setInterceptor() {
    _dio.interceptors.add(ApiInterceptors(_dio));
  }
}
