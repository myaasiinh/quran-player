import 'package:quran_player/ui/views/surah_detail/surah_detail_route.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_route.dart';
import 'package:quran_player/ui/views/splash/splash_route.dart';
import 'package:quran_player/ui/views/splash/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static const String initial = SplashView.route;

  static final List<GetPage<dynamic>> routes = [
    ...splashRoute,
    ...surahListRoute,
    ...surahDetailRoute,
  ];
}
