import 'dart:async';

import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:get/get.dart';

class SurahListController extends BaseController<SurahModel> {
  SurahListController({required this.repository});

  final QuranRepository repository;

  final RxList<SurahModel> _fullList = <SurahModel>[].obs;

  final RxString searchQuery = ''.obs;

  @override
  void onReady() {
    unawaited(getSurahList());
    super.onReady();
  }

  Future<void> getSurahList() async {
    await loadData(() async {
      final res = await repository.getSurahList(cancelToken: cancelToken);
      _fullList.value = res;
      _filterList();
    });
  }

  void onSearch(String value) {
    searchQuery.value = value;
    _filterList();
  }

  void _filterList() {
    if (searchQuery.value.isEmpty) {
      loadFinish(list: _fullList);
    } else {
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
