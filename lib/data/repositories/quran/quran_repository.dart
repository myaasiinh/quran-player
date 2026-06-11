/// Mengimpor model data untuk representasi Surah Al-Qur'an.
import 'package:quran_player/data/models/quran/surah_model.dart';
/// Mengimpor model data untuk representasi Ayah (ayat) Al-Qur'an.
import 'package:quran_player/data/models/quran/ayah_model.dart';
/// Mengimpor pustaka Dio untuk fungsionalitas HTTP, termasuk [CancelToken].
import 'package:dio/dio.dart';

/// Sebuah kontrak (interface) abstrak untuk operasi terkait data Al-Qur'an.
///
/// Kelas ini mendefinisikan metode-metode yang harus diimplementasikan
/// oleh repository konkret untuk mengambil daftar surah dan detail surah (ayat-ayat).
abstract class QuranRepository {
  /// Mengambil daftar semua surah dari sumber data.
  ///
  /// [cancelToken] Token opsional untuk membatalkan permintaan jika diperlukan.
  ///
  /// Mengembalikan [Future] yang berisi [List] dari [SurahModel].
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken});

  /// Mengambil detail (ayat-ayat) untuk surah tertentu.
  ///
  /// [surahNumber] Nomor surah yang ingin diambil detailnya.
  /// [edition] Edisi atau versi Al-Qur'an yang diinginkan (misalnya, 'quran-uthmani').
  /// [cancelToken] Token opsional untuk membatalkan permintaan jika diperlukan.
  ///
  /// Mengembalikan [Future] yang berisi [List] dari [AyahModel] untuk surah yang diminta.
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  });
}