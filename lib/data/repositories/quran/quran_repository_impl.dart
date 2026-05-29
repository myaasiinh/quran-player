import 'package:quran_player/config/base/base_repository.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';
import 'package:dio/dio.dart';

class QuranRepositoryImpl extends BaseRepository implements QuranRepository {
  QuranRepositoryImpl({required this.remote});
  final QuranSources remote;

  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    return loadCachedList<SurahModel>(
      cachedKey: 'surah_list',
      onLoad: () => remote.getSurahList(cancelToken: cancelToken),
      loadWhen: true,
    );
  }

  @override
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  }) async {
    return loadCachedList<AyahModel>(
      cachedKey: 'surah_detail_${surahNumber}_$edition',
      onLoad: () => remote.getSurahDetail(
        surahNumber: surahNumber,
        edition: edition,
        cancelToken: cancelToken,
      ),
      loadWhen: true,
    );
  }
}
