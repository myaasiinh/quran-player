import 'dart:async';

import 'package:get/get.dart';
import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';

/// [SurahListController] mengelola state dan logika bisnis untuk daftar surah.
class SurahListController extends BaseController<SurahModel> {
  SurahListController({required this.repository});

  final QuranRepository repository;

  // List lengkap surah yang belum difilter.
  final RxList<SurahModel> _fullList = <SurahModel>[].obs;

  // Query pencarian yang dimasukkan pengguna.
  final RxString searchQuery = ''.obs;

  @override
  void onReady() {
    // Memulai pemuatan data surah saat controller siap.
    unawaited(getSurahList());
    super.onReady();
  }

  /// [getSurahList] memuat data surah dari repository.
  Future<void> getSurahList() async {
    // loadData secara otomatis mengelola flag loading, error, dan success.
    await loadData(() async {
      final res = await repository.getSurahList(cancelToken: cancelToken);
      _fullList.value = res;
      _filterList(); // Terapkan filter (jika ada input search).
    });
  }

  /// [onSearch] dipanggil setiap kali pengguna mengetik di kolom pencarian.
  void onSearch(String value) {
    searchQuery.value = value;
    _filterList();
  }

  /// [_filterList] menyaring data surah berdasarkan query pencarian.
  void _filterList() {
    if (searchQuery.value.isEmpty) {
      // Jika query kosong, tampilkan daftar lengkap.
      loadFinish(list: _fullList);
    } else {
      // Pencarian case-insensitive berdasarkan nama Inggris dan Arab.
      final filtered = _fullList.where((e) {
        return (e.englishName
                    ?.toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ??
                false) ||
            (e.name?.contains(searchQuery.value) ?? false);
      }).toList();
      loadFinish(list: filtered);
    }
  }
}
