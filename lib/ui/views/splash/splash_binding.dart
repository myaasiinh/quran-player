import 'package:get/get.dart';
import 'package:quran_player/ui/views/splash/splash_controller.dart';

/// Kelas [SplashBinding] mengimplementasikan [Bindings] dari GetX.
/// Kelas ini meregistrasikan [SplashController] untuk diinjeksikan ke dalam [SplashView].
class SplashBinding implements Bindings {
  /// Metode [dependencies] akan dipanggil oleh GetX saat aplikasi memuat route Splash.
  @override
  void dependencies() {
    // Menggunakan tear-off SplashController.new untuk pendaftaran controller secara lazy.
    // Controller baru akan dibuat saat UI membutuhkannya.
    Get.lazyPut(SplashController.new);
  }
}
