import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';

/// Kelas [SurahListBinding] meregistrasikan dependensi yang diperlukan untuk halaman daftar surah.
/// Kelas ini mengimplementasikan [Bindings] yang merupakan bagian dari arsitektur GetX.
class SurahListBinding implements Bindings {
  /// Metode [dependencies] mendaftarkan objek-objek ke dalam memori.
  @override
  void dependencies() {
    // Melakukan injeksi controller secara lazy.
    // Menyertakan instance repository dengan mencarinya di memori (Get.find()).
    Get.lazyPut(() => SurahListController(repository: Get.find()));
  }
}
