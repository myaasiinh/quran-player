import 'package:quran_player/ui/views/splash/splash_binding.dart';
import 'package:quran_player/ui/views/splash/splash_view.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> splashRoute = [
  GetPage(
    name: SplashView.route,
    page: () => const SplashView(),
    binding: SplashBinding(),
  ),
];
