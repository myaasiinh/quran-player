import 'package:get/get.dart';
import 'package:quran_player/ui/views/splash/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SplashController.new);
  }
}
