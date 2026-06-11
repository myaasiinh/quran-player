// Mengimpor perpustakaan jaringan Dio dari direktori sentral untuk mendapatkan abstraksi parameter, cancel token, dan respons utamanya.
import 'package:dio/dio.dart';
// Mengimpor modul jembatan kustom konfigurasional pemesan yang mematri konstruksi pengaturan bawaan HttpClient kita (DioClient).
import '/config/network/api_config.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas abstrak statis [ApiRequest] diaktualisasikan semata-mata sebagai cangkang penutup perantara (Wrapper Abstraction),
/// ditujukan meringkas rentetan kode manakala kita perlu menggelar rutinitas memanggil HTTP client dari Dio.
/// 
/// Principal Note: Perancangan kokoh ini menyuguhkan implementasi arsitektur bertipe `Singleton` mutlak lewat akses `DioClient.find`.
/// Ia dipastikan mencengkram dengan otoritas penuh bahwa semua transaksi permintaan (Request) 
/// tak terkecuali akan serentak tunduk mematuhi satu pengaturan ikatan pusat tunggal 
/// (termasuk urusan durasi Timeout, pemantauan Header Interceptor, URL inti) demi keseragaman lalu-lintas jaringan sistem internalnya.
abstract class ApiRequest {
  /// Antarmuka fungsional jalan tol instan pendorong prosedur metode HTTP [GET].
  /// Tradisinya metode ini murni semata dialokasikan pada misi-misi observasi penelusuran data mentah, maupun ekstraksi objek (Read Operation) yang nongkrong diam di pangkuan Server-Backend.
  /// 
  /// Rincian Parameter:
  /// * `[url]` : (Atribut Wajib) Secarik rangkaian huruf pelengkap muara akhir URL (Endpoint Path) spesifik yang dibidik pelurunya.
  /// * `[queryParameters]` : (Atribut Bebas/Opsional) Bekal tas jinjing memuat struktur pengarsipan sisipan nilai-kunci (Map), difungsikan laiknya filter buntut url 
  ///   untuk menyaring hasil semacam pengurutan berhalaman (misal: '?page=1&sort=desc').
  /// * `[cancelToken]` : (Atribut Bebas/Opsional) Remot kendali darurat sakti pengeksekusi pencabutan tali komunikasi paksa, seandainya tiba-tiba permohonan harus dicekik mati tatkala belum kelar urusannya (misal aplikasi ditutup/layar disapu minggir user).
  static Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    // Membangunkan instansi penguasa tunggal `DioClient` milik kita, dan memerintahkan algojonya memuntahkan metode penarikan `get`,
    // sekaligus menitipkan kelengkapan tas ransel dokumen persyaratannya.
    return DioClient.find.get(
      url,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  /// Antarmuka fungsional rute super kilat sebagai wadah perayaan seremoni pengiriman masif permohonan HTTP [POST].
  /// Esensi diciptakannya adalah buat menggendong operasi fundamental menancapkan, menabung, serta mengekstrak objek susunan materi baru 
  /// (Create or Update mutations) yang mana substansi jasad informasinya dipendam di kedalaman ruang kargo rahasia (Data Body/Payload).
  /// 
  /// Rincian Parameter:
  /// * `[url]` : (Atribut Wajib) Rentetan abjad peta koordinat penanda sasaran lokasi altar persemayaman API tujuannya.
  /// * `[data]` : (Atribut Opsional) Perwujudan raga objek krusial, umumnya menyaru di dalam penampakan Map JSON dinamis merangkum konstruksi variabel muatan utamanya.
  /// * `[cancelToken]` : (Atribut Bebas/Opsional) Segel talisman pemutus urat nadi sinyal jaringan sepihak andai kata proses pengiriman berjalan terlalu alot membahayakan performa gawai.
  static Future<Response<dynamic>> post({
    required String url,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    // Memencet bel pintu saklar `post` otentik orisinal warisan bapak pengurus asrama Singleton 'DioClient'. 
    // Bersamaan seraya menyerahkan dan memboyong masuk beban muatan gerbong logistiknya (data payload) menembus lorong HTTP tersebut.
    return DioClient.find.post(
      url,
      data: data,
      cancelToken: cancelToken,
    );
  }
}
