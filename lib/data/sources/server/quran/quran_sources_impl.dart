import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';
import 'package:quran_player/config/network/api_request.dart';
import 'package:dio/dio.dart';

class QuranSourcesImpl implements QuranSources {
  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    final response = await ApiRequest.get(
      url: '/surah',
      cancelToken: cancelToken,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  }) async {
    final response = await ApiRequest.get(
      url: '/surah/$surahNumber/$edition',
      cancelToken: cancelToken,
    );
    final data = response.data['data']['ayahs'] as List;
    return data
        .map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
