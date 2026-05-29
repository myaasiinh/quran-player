import 'package:get/get.dart';
import 'package:quran_player/ui/views/splash/splash_binding.dart';
import 'package:quran_player/ui/views/splash/splash_view.dart';

/// Konfigurasi routing untuk halaman Splash.
final List<GetPage<dynamic>> splashRoute = [
  GetPage(
    name: SplashView.route,
    page: SplashView.new,
    binding: SplashBinding(),
  ),
];
