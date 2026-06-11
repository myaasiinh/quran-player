import 'package:get/get.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_binding.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';

/// Konfigurasi routing (jalur navigasi) untuk modul Detail Surah.
/// 
/// Variabel list ini menyimpan pengaturan navigasi spesifik untuk halaman yang menampilkan
/// rincian ayat dan bacaan dari satu surah secara lengkap.
final List<GetPage<dynamic>> surahDetailRoute = [
  // Objek halaman dari GetX untuk rute detail surah
  GetPage(
    // Mendefinisikan konvensi penamaan path rute (contoh: '/surah-detail')
    name: SurahDetailView.route,
    // Merujuk langsung ke konstruktor kelas tampilan utama Detail Surah
    page: SurahDetailView.new,
    // Menyisipkan mekanisme "binding" untuk menginjeksi pengontrol (controller) spesifik
    // agar data dimuat efisien ketika layar Detail Surah dibuka
    binding: SurahDetailBinding(),
  ),
];
