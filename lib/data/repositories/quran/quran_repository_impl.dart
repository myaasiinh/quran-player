import 'package:dio/dio.dart';
import 'package:quran_player/config/base/base_repository.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';

/// [QuranRepositoryImpl] adalah implementasi konkret dari [QuranRepository].
/// Principal Note: Menggunakan BaseRepository untuk memanfaatkan CacheMixin.
/// Pola ini memungkinkan aplikasi berjalan responsif meski dalam kondisi offline.
class QuranRepositoryImpl extends BaseRepository implements QuranRepository {
  QuranRepositoryImpl({required this.remote});

  final QuranSources remote;

  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    // loadCachedList menangani pengambilan data dari cache lokal terlebih dahulu.
    // Jika cache kosong atau kadaluwarsa, ia akan menjalankan fungsi onLoad (remote call).
    return loadCachedList<SurahModel>(
      cachedKey: 'surah_list',
      onLoad: () => remote.getSurahList(cancelToken: cancelToken),
      loadWhen: true, // Selalu aktifkan caching untuk list surah statis.
    );
  }

  @override
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  }) async {
    // Menggunakan key dinamis berdasarkan nomor surah dan edisi reciter.
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
