import 'package:dio/dio.dart';
import 'package:quran_player/config/base/base_repository.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';

/// [QuranRepositoryImpl] adalah kelas konkrit implementasi dari kontrak antarmuka API [QuranRepository].
/// Principal Note: Kelas ini mewarisi sifat dari [BaseRepository] untuk dapat memanfaatkan utilitas fitur [CacheMixin].
/// Pendekatan pola desain repository ini memastikan aplikasi berjalan secara mulus dan responsif meski saat status offline 
/// karena dukungan pengambilan file singgahan / cache.
class QuranRepositoryImpl extends BaseRepository implements QuranRepository {
  /// Konstruktor wajib injeksi dependensi untuk [QuranRepositoryImpl].
  /// Mensyaratkan abstraksi [QuranSources] (sebagai `remote`) disuntikkan secara dinamis guna mengeksekusi request jaringan sesungguhnya.
  QuranRepositoryImpl({required this.remote});

  /// Referensi Data Source layer api remote yang menangani komunikasi ke endpoint spesifik.
  final QuranSources remote;

  /// Metode pengambilan Daftar Surah Al-Quran.
  /// Menerima parameter pembatal opsional [cancelToken].
  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    // Fungsi loadCachedList (dari BaseRepository) mengambil alih tugas dengan menarik data statis di dalam cache lokal terlebih dahulu.
    // Apabila isi cache kosong atau waktunya telah kadaluwarsa, ia otomatis berpaling untuk menjalankan sub rutin dari param onLoad (pemanggilan remote call).
    return loadCachedList<SurahModel>(
      cachedKey: 'surah_list', // Identitas unik string konstan untuk file cache data list surah.
      onLoad: () => remote.getSurahList(cancelToken: cancelToken), // Fungsi tunda eksekusi (callback) panggilan backend list surah.
      loadWhen: true, // Boolean penentu. Selalu kembalikan nilai true untuk senantiasa mengaktifkan metode caching dikarenakan daftar surah itu statis selamanya (tidak ganti-ganti).
    );
  }

  /// Metode pengambilan Detail Ayat dalam suatu Surah (Surah spesifik).
  /// Menerima parameter [surahNumber] sebagai angka surah dan string edisi Qari/Reciter via [edition].
  @override
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  }) async {
    // Menyimpan sekaligus mengambil cache menggunakan key dinamis yang dikombinasikan berdasarkan nomor spesifik surah beserta varian edisi qari (reciter).
    return loadCachedList<AyahModel>(
      cachedKey: 'surah_detail_${surahNumber}_$edition', // ID file cache dibentuk berdasarkan parameter yang dikirim agar tidak konflik.
      onLoad: () => remote.getSurahDetail(
        surahNumber: surahNumber, // Mempassing data urutan nomor surah.
        edition: edition, // Mempassing identitas edisi murrotal.
        cancelToken: cancelToken, // Mempassing variabel token untuk opsionalitas pemberhentian/cancel koneksi HTTP.
      ),
      loadWhen: true, // Caching juga senantiasa dihidupkan untuk penghematan internet jika surat tersebut sudah pernah didownload ayatnya.
    );
  }
}
