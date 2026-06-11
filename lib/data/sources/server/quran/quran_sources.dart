/// Mengimpor model untuk representasi data surah.
import 'package:quran_player/data/models/quran/surah_model.dart';
/// Mengimpor model untuk representasi data ayat.
import 'package:quran_player/data/models/quran/ayah_model.dart';
/// Mengimpor Dio untuk fungsionalitas pembatalan permintaan HTTP.
import 'package:dio/dio.dart';

/// Sebuah kelas abstrak yang mendefinisikan antarmuka untuk sumber data Al-Qur'an.
///
/// Kelas ini berfungsi sebagai kontrak untuk implementasi yang berbeda
/// dalam mengambil data surah dan ayat dari berbagai sumber (misalnya, API jarak jauh, database lokal).
abstract class QuranSources {
  /// Mengambil daftar semua surah yang tersedia.
  ///
  /// Metode ini mengembalikan daftar objek [SurahModel] yang mewakili
  /// setiap surah dalam Al-Qur'an.
  ///
  /// [cancelToken] dapat digunakan untuk membatalkan permintaan HTTP yang sedang berlangsung.
  ///
  /// Mengembalikan [Future] yang akan menyelesaikan dengan [List<SurahModel>].
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken});

  /// Mengambil detail (ayat-ayat) dari surah tertentu.
  ///
  /// Metode ini memerlukan nomor surah dan edisi (misalnya, gaya bacaan atau terjemahan)
  /// untuk mengambil daftar ayat yang terkait dengan surah tersebut.
  ///
  /// [surahNumber] adalah nomor surah yang ingin diambil detailnya.
  /// [edition] adalah edisi atau gaya bacaan/terjemahan yang diinginkan untuk ayat-ayat tersebut.
  /// [cancelToken] dapat digunakan untuk membatalkan permintaan HTTP yang sedang berlangsung.
  ///
  /// Mengembalikan [Future] yang akan menyelesaikan dengan [List<AyahModel>]
  /// yang berisi semua ayat untuk surah yang ditentukan.
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  });
}