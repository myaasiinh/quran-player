import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '/config/environment/app_env.dart';
import '/config/network/api_interceptor.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas [DioClient] adalah instance service dari GetX yang menginisialisasi 
/// dan menyediakan objek Dio sebagai HTTP Client untuk akses jaringan.
class DioClient extends GetxService {
  /// Konstruktor [DioClient] yang melakukan inisialisasi Dio,
  /// menerapkan base URL dari environment, mengatur batasan waktu timeout,
  /// serta memasang interceptor kustom.
  DioClient() {
    _dio = Dio();
    _dio.options.baseUrl = AppEnv.config.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _setInterceptor();
  }
  
  /// Mengambil instance Dio tunggal dari [DioClient] yang sudah diregistrasikan di GetX.
  static Dio get find => Get.find<DioClient>()._dio;
  
  /// Instance Dio privat yang sudah terkonfigurasi.
  late Dio _dio;

  /// Mengganti dan memperbarui konfigurasi interceptor jaringan pada instance Dio yang aktif.
  static void setInterceptor() {
    final dio = DioClient.find;
    dio.interceptors.clear();
    dio.interceptors.add(ApiInterceptors(dio));
  }

  /// Fungsi internal untuk menyuntikkan (inject) [ApiInterceptors] ke dalam instance Dio.
  void _setInterceptor() {
    _dio.interceptors.add(ApiInterceptors(_dio));
  }
}
