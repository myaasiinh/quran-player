import 'package:get/get.dart';
import 'package:quran_player/ui/views/about/about_controller.dart';

/// [AboutBinding] meregistrasikan dependensi yang dibutuhkan untuk halaman About.
class AboutBinding implements Bindings {
  @override
  void dependencies() {
    // Registrasi controller secara lazy (hanya saat halaman diakses).
    Get.lazyPut(AboutController.new);
  }
}
