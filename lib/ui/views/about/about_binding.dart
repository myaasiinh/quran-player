import 'package:get/get.dart';
import 'package:quran_player/ui/views/about/about_controller.dart';

/// Kelas [AboutBinding] mengimplementasikan [Bindings] dari GetX.
/// Kelas ini digunakan untuk meregistrasikan dependensi yang dibutuhkan untuk halaman About.
class AboutBinding implements Bindings {
  /// Metode [dependencies] akan dipanggil oleh GetX saat route terkait diakses.
  @override
  void dependencies() {
    // Registrasi controller secara lazy (hanya diinisialisasi saat halaman benar-benar diakses).
    // Menggunakan tear-off dari constructor AboutController.
    Get.lazyPut(AboutController.new);
  }
}
