import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';

/// [SurahDetailBinding] mengelola injeksi dependensi untuk modul Detail Surah.
class SurahDetailBinding implements Bindings {
  @override
  void dependencies() {
    // Registrasi controller dengan menyuntikkan QuranRepository yang sudah ada di ServiceLocator.
    Get.lazyPut(() => SurahDetailController(repository: Get.find()));
  }
}
