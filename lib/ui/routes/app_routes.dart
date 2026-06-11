// Mengimpor definisi `GetPage` dari paket GetX untuk mengelola rute navigasi.
import 'package:get/get_navigation/src/routes/get_route.dart';
// Mengimpor daftar rute yang terkait dengan halaman "Tentang" (About).
import 'package:quran_player/ui/views/about/about_route.dart';
// Mengimpor daftar rute yang terkait dengan halaman "Splash Screen".
import 'package:quran_player/ui/views/splash/splash_route.dart';
// Mengimpor definisi `SplashView` untuk menentukan rute awal aplikasi.
import 'package:quran_player/ui/views/splash/splash_view.dart';
// Mengimpor daftar rute yang terkait dengan halaman "Detail Surah".
import 'package:quran_player/ui/views/surah_detail/surah_detail_route.dart';
// Mengimpor daftar rute yang terkait dengan halaman "Daftar Surah".
import 'package:quran_player/ui/views/surah_list/surah_list_route.dart';

/// Kelas `AppPages` bertanggung jawab untuk mendefinisikan semua rute navigasi yang digunakan dalam aplikasi.
/// Ini mengkonsolidasikan rute dari berbagai modul tampilan menjadi satu daftar yang dapat digunakan oleh GetX
/// untuk manajemen rute global.
class AppPages {
  /// Mendefinisikan rute awal aplikasi.
  /// Aplikasi akan dimulai dari `SplashView` saat pertama kali diluncurkan.
  static const String initial = SplashView.route;

  /// Daftar semua rute yang tersedia dalam aplikasi.
  /// Rute-rute ini digabungkan dari berbagai file rute spesifik modul
  /// menggunakan operator spread (`...`) untuk mengkonsolidasikan semua `GetPage`
  /// ke dalam satu daftar.
  static final List<GetPage<dynamic>> routes = [
    // Menambahkan rute-rute yang terkait dengan Splash Screen.
    ...splashRoute,
    // Menambahkan rute-rute yang terkait dengan Daftar Surah.
    ...surahListRoute,
    // Menambahkan rute-rute yang terkait dengan Detail Surah.
    ...surahDetailRoute,
    // Menambahkan rute-rute yang terkait dengan halaman Tentang.
    ...aboutRoute,
  ];
}