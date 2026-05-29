import 'package:dio/dio.dart';
import 'package:quran_player/config/network/api_request.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';

/// [QuranSourcesImpl] menangani eksekusi HTTP request ke API Al-Quran.
class QuranSourcesImpl implements QuranSources {
  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    // Memanggil endpoint daftar surah.
    final response = await ApiRequest.get(
      url: '/surah',
      cancelToken: cancelToken,
    );

    // Parsing manual data JSON ke model objek.
    final List data = response.data['data'] as List;
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
    // Memanggil endpoint detail surah beserta data audio per ayat.
    final response = await ApiRequest.get(
      url: '/surah/$surahNumber/$edition',
      cancelToken: cancelToken,
    );

    // Mengambil array 'ayahs' dari respon API.
    final List data = response.data['data']['ayahs'] as List;
    return data
        .map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
