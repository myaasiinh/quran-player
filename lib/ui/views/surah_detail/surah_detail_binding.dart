import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';

/// Kelas [SurahDetailBinding] mengelola injeksi dependensi untuk modul Detail Surah.
/// Mengimplementasikan [Bindings] dari framework GetX.
class SurahDetailBinding implements Bindings {
  /// Metode [dependencies] digunakan untuk mendeklarasikan objek yang akan di-inject.
  @override
  void dependencies() {
    // Registrasi controller SurahDetailController secara lazy (inisialisasi tertunda).
    // Menyuntikkan (inject) instance QuranRepository yang sudah terdaftar di memori (ServiceLocator) menggunakan Get.find().
    Get.lazyPut(() => SurahDetailController(repository: Get.find()));
  }
}
