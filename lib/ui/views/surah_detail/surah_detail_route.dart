import 'package:quran_player/ui/views/surah_detail/surah_detail_binding.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> surahDetailRoute = [
  GetPage(
    name: SurahDetailView.route,
    page: () => const SurahDetailView(),
    binding: SurahDetailBinding(),
  ),
];
