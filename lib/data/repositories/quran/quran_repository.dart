import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:dio/dio.dart';

abstract class QuranRepository {
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken});
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  });
}
