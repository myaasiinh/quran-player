import 'package:get/get.dart';
import 'package:quran_player/ui/views/splash/splash_binding.dart';
import 'package:quran_player/ui/views/splash/splash_view.dart';

/// Konfigurasi routing (jalur navigasi) untuk halaman Splash.
/// 
/// Kumpulan rute ini dipanggil di awal proses aplikasi (entry point)
/// untuk memuat tampilan perdana serta inisiasi konfigurasi awal melalui controller yang terhubung.
final List<GetPage<dynamic>> splashRoute = [
  // Mengatur satu buah rute halaman untuk tampilan Splash
  GetPage(
    // Identitas atau jalur nama (route name) untuk mengakses halaman Splash
    name: SplashView.route,
    // Konstruktor fungsi pembuat tampilan (view) layar Splash
    page: SplashView.new,
    // Menggunakan binding yang bertanggung jawab menyuntikkan (inject) controller atau data 
    // yang dibutuhkan selama splash screen berlangsung
    binding: SplashBinding(),
  ),
];
