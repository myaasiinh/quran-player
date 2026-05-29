import 'package:get/get.dart';
import 'package:quran_player/ui/views/splash/splash_controller.dart';

/// [SplashBinding] meregistrasikan [SplashController] untuk diinjeksikan ke dalam [SplashView].
class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Menggunakan tear-off SplashController.new untuk pendaftaran controller.
    Get.lazyPut(SplashController.new);
  }
}
