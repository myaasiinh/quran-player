import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';

/// [SurahListBinding] meregistrasikan dependensi yang diperlukan untuk halaman daftar surah.
class SurahListBinding implements Bindings {
  @override
  void dependencies() {
    // Injeksi controller dengan menyertakan repository yang dibutuhkan.
    Get.lazyPut(() => SurahListController(repository: Get.find()));
  }
}
