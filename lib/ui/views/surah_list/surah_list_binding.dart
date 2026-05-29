import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:get/get.dart';

class SurahListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurahListController(repository: Get.find()));
  }
}
