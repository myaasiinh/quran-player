// Mengimpor perpustakaan penggerak roda jejaring andalan perwakilan transfer pengangkut muatan [Dio] berserta bala tentara pendukung utilitas lainnya seperti Token Pembatal.
import 'package:dio/dio.dart';
// Mengimpor fasilitas antarmuka pengawal pelindung yang bertindak laksana bungkusan penjamin kemulusan negosiasi (ApiRequest) dengan perisai arsitektur anti-rusak internal.
import 'package:quran_player/config/network/api_request.dart';
// Mengimpor wujud konstruksi cetakan arsitektur pemodelan data rincian potong barisan spesifikasi satu kalimat sabda kitab suci (AyahModel).
import 'package:quran_player/data/models/quran/ayah_model.dart';
// Mengimpor wujud rupa model pemetaan (blueprint) dari konstruktor pendataan pengelompokan bab surat di dalam himpunan susunan jilid kitab (SurahModel).
import 'package:quran_player/data/models/quran/surah_model.dart';
// Mengimpor lembaran kontrak sumpah suci perjanjian kerja sama (Interface API Datasource) yang dinamakan `QuranSources`.
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';

/// Instansi nyata garda terdepan lapangan eksekutor [QuranSourcesImpl] adalah kepanjangan tangan dari sumpah perjanjian lisan yang diratifikasi 
/// dari dokumen cetak biru interface `QuranSources`.
/// 
/// Menyandang tanggung jawab berat bertindak selaku agen spionase di garda (Remote Data Source) yang diproyeksikan menginvasi dan mencongkel rahasia ke gerbang peladen langit maya (Backend Server).
/// Utusan mulia ini dibekali misi untuk menjaring setoran data-data vital semata bersentuhan reliji ilahiah 
/// (seperti pembongkaran daftar absen komplit perikop Susunan Surat serta mengebor menelan spesifikasi lantunan bunyi alunan ayat Al-Quran yang mendetail di setiap nomor urutnya).
class QuranSourcesImpl implements QuranSources {
  
  /// Mengklaim dan menguasai kendali mahkota keutamaan fungsi takhta warisan (Override Method) yang mewajibkan dedikasi menumpas tugas memungut inventaris indeks penanda buku nama-nama Surat se-Alquran penuh.
  @override
  Future<List<SurahModel>> getSurahList({CancelToken? cancelToken}) async {
    // Mengeksekusi manuver penggempuran intelijen permintaan koneksi HTTP berwujud serbuan murni pembacaan pasif armada tempur [GET] untuk berlayar meraba belahan URL '/surah'.
    // Titipan jimat `cancelToken` direstui diizinkan digendong menumpang serta di dalam rombongannya sebagai alat remot penarik tali komando putus hubungan (Aborter) 
    // jikalau tiba-tiba pemirsa manusia muak kebosanan urung menunggu hasil unduhan lama lalu mencabut tali mematikan layarnya secara sepihak di waktu genting.
    final response = await ApiRequest.get(
      url: '/surah',
      cancelToken: cancelToken,
    );

    // Sesudah harta rampasan berupa peti kemas kotak pesan balasan sahut-menyahut sukses dirampas (Response JSON), 
    // algojo pencacah mulai mengoyak perut kargonya secara manual bengis barbar (sebab parser murni itu kaku) 
    // lantas mencaplok kompartemen jeroan yang menyandang plat nama titik saraf sandi `['data']` secara beringas serta memaksanya berinkarnasi bersumpah wujud sejati laksana Array bertipe tumpukan Larik [List].
    final List data = response.data['data'] as List;
    
    // Beramai-ramai mendaur ulang dan menggilas deretan larik berantakan serabut amorf tersebut lewat sabuk mesin cetak (Mapping operation) 
    // agar dapat dipahat, dipoles telaten, lalu disihir ditransformasikan utuh wujudnya per setiap sel potongannya melahirkan prajurit hidup sempurna bergelar kesatria instansi [SurahModel.fromJson].
    // Selanjutnya barisan bala tentara kesatria anyar itu kembali digiring mengelompok di rantai belenggu kurungan paten berformat Array (toList).
    return data
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Menunaikan ikrar sumpah takhta warisan kepemimpinan pewarisan sakral kontrak kedua yang mengutus misi membelah lautan mengorek rahasia terperinci menyelusup menyelami perut bab surah spesifiknya lewat instrumen utusan (getSurahDetail).
  /// 
  /// Rincian sandi penunjuk jalan kompas argumen pemanggilan (Parameters):
  /// [surahNumber] mewakilkan dan menjunjung tinggi angka martabat perwakilan posisi identitas letak pendaratan indeks bab urutan kitab suci Al-Quran.
  /// [edition] menyimpan seuntaian lafadz string pembawa nama plat pengenal identifikasi unik (misal sandi rekaan 'ar.alafasy') yang mutlak difungsikan buat menunjuk lurus jarinya ke versi logat lidah lafadz makharijul huruf dari penyanyi nada syekh spesifik panutan sang qari rekamannya.
  @override
  Future<List<AyahModel>> getSurahDetail({
    required int surahNumber,
    required String edition,
    CancelToken? cancelToken,
  }) async {
    // Membara meletuskan tembakan roket misi jelajah permohonan jaringan kawat protokol [GET] sembari menggotong dua tabung muatan amunisi penyusun teka-teki sandi rahasia variabel muara (Path parameter interpolation string)
    // yang menggabungkan adonan peleburan nomer keramat seri indeks surah dan plat nama suci sang penyanyi tilawahnya.
    final response = await ApiRequest.get(
      url: '/surah/$surahNumber/$edition',
      cancelToken: cancelToken,
    );

    // Mendarat sukses mencuri gundukan tumpukan sarang laba-laba balasan hirarki rumit berlapis cangkang JSON bersarangnya sang peladen langit (Nested map tree JSON tree array payload traversal).
    // Turun melangkah meniti tangga cangkang terluar menginjak punggung jembatan `['data']` barulah bisa menyelam lolos hingga di perut dasar kantung harta tersimpan yakni di lubang subur kompartemen sebutan dahan `['ayahs']` yang niscaya hakikat jati dirinya murni tak terbantahkan adalah perwujudan klan marga Array [List].
    final List data = response.data['data']['ayahs'] as List;
    
    // Identik persis seia sekata sebagaimana rutinitas manufaktur pertambangan pembentukan galian yang lalu tadi, 
    // sekepal gumpalan lelehan besi leburan data JSON primitif ini diseret paksa dan diceburkan ke lubang cerobong kawah api pabrik manufaktur pemanggang penempa rupa dewa pelafal tunggal bernama cetakan agung (AyahModel.fromJson) 
    // hingga memercik menyemburkan tetes demi tetes keringat leburan menjadi wujud tentara laskar sempurna gagah berani lengkap berziraah lapis baja memboyong gelar kebesaran tunggal identitas hakiki sebuah kelas suci objek tipe pasukannya sang laskar (Array of AyahModel!).
    return data
        .map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
