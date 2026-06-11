import 'package:get/get.dart';
import 'package:quran_player/ui/views/about/about_binding.dart';
import 'package:quran_player/ui/views/about/about_view.dart';

/// Konfigurasi routing (jalur navigasi) khusus untuk fitur Halaman Tentang (About).
/// 
/// Menyediakan daftar rute (route list) dari `GetPage` yang mengatur bagaimana navigasi ke 
/// halaman "Tentang Aplikasi" diinisialisasi dan ditampilkan oleh GetX.
final List<GetPage<dynamic>> aboutRoute = [
  // Definisi konfigurasi halaman tunggal menggunakan GetPage
  GetPage(
    // Mendefinisikan nama alias rute (path) yang dipakai untuk bernavigasi, misalnya '/about'
    name: AboutView.route,
    // Fungsi pembuat untuk memanggil halaman utama dari tampilan "About"
    page: AboutView.new,
    // Menghubungkan binding (sebagai pengatur state/dependency injection) secara spesifik 
    // agar resource dan controller dibuat tepat ketika halaman ini diakses
    binding: AboutBinding(),
  ),
];
