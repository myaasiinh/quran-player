import 'package:get/get.dart';
import 'package:quran_player/ui/views/about/about_binding.dart';
import 'package:quran_player/ui/views/about/about_view.dart';

/// Konfigurasi routing untuk fitur About.
final List<GetPage<dynamic>> aboutRoute = [
  GetPage(
    name: AboutView.route,
    page: AboutView.new,
    binding: AboutBinding(),
  ),
];
