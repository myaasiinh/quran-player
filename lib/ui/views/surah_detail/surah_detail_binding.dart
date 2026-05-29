import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';
import 'package:get/get.dart';

class SurahDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurahDetailController(repository: Get.find()));
  }
}
