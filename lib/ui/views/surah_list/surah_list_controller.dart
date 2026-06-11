import 'dart:async';

import 'package:get/get.dart';
import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';

/// [SurahListController] merupakan komponen vital yang bertanggung jawab
/// mengelola manajemen state dan logika bisnis operasional untuk layar daftar surah.
class SurahListController extends BaseController<SurahModel> {
  /// Konstruktor mewajibkan sebuah turunan instance `QuranRepository` disuntikkan.
  SurahListController({required this.repository});

  /// Instansiasi akses penghubung lapis sumber data (repository).
  final QuranRepository repository;

  // Variabel observasi internal yang menampung seluruh deretan data list surah sebelum melalui pemilahan (filter).
  final RxList<SurahModel> _fullList = <SurahModel>[].obs;

  // Variabel reaktif penyimpan kueri / string masukan pencarian yang diketik pengguna saat ini.
  final RxString searchQuery = ''.obs;

  /// Metode siklus pemuatan saat kontroller mulai tereksekusi pada antarmuka.
  @override
  void onReady() {
    // Memulai rutinitas penarikan data surah sesaat seusai controller dilaporkan siap.
    // Menghilangkan peringatan lint dengan membungkus ke dalam `unawaited`.
    unawaited(getSurahList());
    // Menjalankan inisiasi parent (induk) metode.
    super.onReady();
  }

  /// [getSurahList] berfungsi asinkronus untuk mendownload/menarik data himpunan surah lewat repository.
  Future<void> getSurahList() async {
    // Memanfaatkan helper metode [loadData] warisan dari `BaseController` untuk menangani indikator laju proses 
    // seperti status memuat (loading), keberhasilan (success), maupun kesalahan (error) secara transparan.
    await loadData(() async {
      // Memerintahkan repo untuk mengirim fetch surah sembari memantau token pembatalan proses.
      final res = await repository.getSurahList(cancelToken: cancelToken);
      // Mendistribusikan deret daftar temuan ke dalam variabel list utuh reaktif kita.
      _fullList.value = res;
      // Menjalankan evaluasi penyaringan seketika (antisipasi kemungkinan fitur auto-search nyala).
      _filterList();
    });
  }

  /// [onSearch] dieksekusi terus-menerus mengikuti irama ketukan papan tik pengguna pada bilah input kolom pencarian.
  void onSearch(String value) {
    // Merekam string parameter baru yang dimasukkan pencari.
    searchQuery.value = value;
    // Memicu siklus fungsi filter agar daftar yang ada terbaharui.
    _filterList();
  }

  /// [_filterList] bekerja menyaring set data surah dari _fullList yang patut ditampilkan
  /// merujuk pada validasi parameter filter di `searchQuery`.
  void _filterList() {
    // Cek apakah tidak ada sepotong kata kunci yang diketik
    if (searchQuery.value.isEmpty) {
      // Andai kosong sama sekali, lepas filter, lalu paparkan semua rentetan isi dari basis datanya.
      loadFinish(list: _fullList);
    } else {
      // Lakukan pencarian string dengan menyelaraskan kesepadanan kata abaikan gaya kapital 
      // (case-insensitive) komparasi untuk varian abjad nama di Bahasa Inggris maupun aslinya (Arab).
      final filtered = _fullList.where((e) {
        // Logika penyaringan: apakah atribut kata english memuat string kita (tolowercase),
        // atau apakah penamaan latin mengandung ejaan kueri (dengan safe check nullability)
        return (e.englishName
                    ?.toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ??
                false) ||
            (e.name?.contains(searchQuery.value) ?? false);
      }).toList();
      // Melaporkan ke base list controller agar update visual dengan daftar yang berhasil dicocokkan saja.
      loadFinish(list: filtered);
    }
  }
}
