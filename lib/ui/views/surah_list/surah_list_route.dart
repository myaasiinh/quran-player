import 'package:quran_player/ui/views/surah_list/surah_list_binding.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> surahListRoute = [
  GetPage(
    name: SurahListView.route,
    page: () => const SurahListView(),
    binding: SurahListBinding(),
  ),
];
