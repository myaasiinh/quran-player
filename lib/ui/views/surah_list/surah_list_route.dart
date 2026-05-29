import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_binding.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';

/// Konfigurasi routing untuk halaman daftar surah.
final List<GetPage<dynamic>> surahListRoute = [
  GetPage(
    name: SurahListView.route,
    page: SurahListView.new,
    binding: SurahListBinding(),
  ),
];
