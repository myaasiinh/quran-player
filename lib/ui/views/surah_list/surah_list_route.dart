import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_binding.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';

/// Konfigurasi routing (jalur navigasi) untuk halaman daftar surah.
/// 
/// Menyediakan daftar rute dari `GetPage` untuk menangani navigasi utama 
/// saat menampilkan halaman indeks/daftar seluruh surah dalam Al-Quran.
final List<GetPage<dynamic>> surahListRoute = [
  // Pengaturan rute spesifik untuk daftar surah menggunakan GetX
  GetPage(
    // Identitas rute halaman daftar surah (misal: '/surah-list')
    name: SurahListView.route,
    // Fungsi konstruktor penunjuk untuk membuat widget halaman SurahListView
    page: SurahListView.new,
    // Menggunakan binding untuk memuat dependensi yang diperlukan oleh daftar surah
    binding: SurahListBinding(),
  ),
];
