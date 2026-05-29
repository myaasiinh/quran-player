import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_binding.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';

/// Konfigurasi routing untuk modul Detail Surah.
final List<GetPage<dynamic>> surahDetailRoute = [
  GetPage(
    name: SurahDetailView.route,
    page: SurahDetailView.new,
    binding: SurahDetailBinding(),
  ),
];
