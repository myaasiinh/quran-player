// Mengimpor gerbang kelas inti mesin jejaring paket Dio untuk memanifestasi dan mendelegasikan tugas-tugas kurir HTTP (Interceptor).
import 'package:dio/dio.dart';
// Mengimpor utilitas layanan pembantu cetak riwayat (logger tools) agar aktivitas jaringan mudah dilacak dan diterawang isi perutnya.
import 'package:quran_player/core/helper/app_logger.dart';

// Mengimpor kelas tetua (Superclass) `ApiTokenManager` yang mahir menyulap permasalahan regenerasi token dari kursi belakang agar urusannya diwakilkan kepadanya secara terpadu.
import '/config/network/api_token_manager.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas [ApiInterceptors] direkrut berprofesi selaku makelar/pencegat inspeksi jalur masuk-keluar (Middleman layer) atas semua aktivitas lalu-lintas jaringan HTTP.
/// 
/// Interceptor ini dibekali radar untuk menghentikan paket sejenak guna menayangkan aktivitas pengiriman log permohonan ke layar terminal debug (onRequest), 
/// mencatat kesuksesan respons balasan apa pun yang dianugerahkan dari peladen (onResponse), hingga bersiul dan melaporkan tatkala pengantaran menemui jalan buntu ditolak server (onError).
///
/// Principal Note: Ada tujuan filosofis pemisahan wewenang (Separation of concern) dalam arsitektur ini: Interceptor spesifik direkayasa 
/// lebih minimalis, apik nan elegan, sebatas sebagai petugas pencatat log (Observability) dan kurir penyampai isu galat semata, sementara urusan kerumitan manuver pergantian 
/// regenerasi token secara magis disisihkan dan digendong seutuhnya di punggung wali asuhnya yakni klas Induk abstraksi `ApiTokenManager`.
base class ApiInterceptors extends ApiTokenManager {
  /// Konstruktor pendirian awal instansi yang mewajibkan penyisipan jembatan kanal koneksivitas [Dio] 
  /// lewat argumen perantaranya, agar sosok wali (Parent Manager Token) mengantongi kompas dan akses remot 
  /// guna menerbangkan kembali armada paket muatan koneksi (retry connection) bilamana diperlukan nanti.
  ApiInterceptors(this._dio);
  
  /// Tempat berlabuhnya rujukan memori variabel (instance channel) komando HTTP dari mesin aslinya Dio secara eksklusif dan privat.
  final Dio _dio;

  /// Metode pemicu pengadang otomatis (Hook) milik Dio bernama [onRequest], sifatnya langsung bangkit bekerja
  /// tatkala segelintir niat paket permohonan HTTP baru saja hendak diterbangkan ke langit pelabuhan server backend. (Fase Pre-requesting).
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Menorehkan dengan detil terperinci pada papan jurnal konsol riwayat rute destinasi yang disasarnya (Berupa gabungan jenis aksi layaknya GET/POST beserta rentetan alur alamat URInya).
    AppLogger.debug('--> ${options.method} ${options.uri}');
    
    /// Mengintip keranjang kompartemen header (yang di dalamnya terdapat sisipan Token Auth dan preferensi format media layaknya json-content) lalu memaparkannya gamblang ke layar.
    AppLogger.debug('Headers: ${options.headers}');
    
    /// Membongkar boks pembungkus konten (data JSON payload inti pesan permohonan) dan menjabarkan rinciannya agar dapat di-audit keabsahan paketnya.
    AppLogger.debug('Body: ${options.data}');
    
    /// Menutup sesi inspeksi pembacaan isi paket prapemberangkatan (Request) di papan terminal dengan pembatas teks bergaris (END).
    AppLogger.debug('--> END ${options.method}');
    
    /// Meneruskan kembali paspor mandat perjalanan dan mendorong paket data konkret ini melewati pos pengecekan Handler, 
    /// sehingga ia resmi meroket diluncurkan menemui singgasana peladen API lewat kabel awan belantara internet.
    super.onRequest(options, handler);
  }

  /// Metode interupsi berbalas (Hook) bernama [onResponse], seketika terbangun gembira persis sejenak usai server backend
  /// menyahut seruan dengan melambaikan bendera putih kedamaian lewat kode status kemenangan (Misal HTTP indikator 200/201).
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    /// Mencatatkan pada kanvas terminal debugging rekapitulasi kemenangan angka kode status penerimaan berikut URL sumber penelusurannya kala itu.
    AppLogger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
    );
    
    /// Menerjemahkan dan melisankan wujud material komoditas balasan dari sang server yang memuat bongkahan json (Data payload) sarat bernilai ini.
    AppLogger.debug('Data: ${response.data}');
    
    /// Mengecap akhir perbincangan proses serah terima hasil komunikasi interaksi jaringan dua muka secara sah.
    AppLogger.debug('<-- END HTTP');
    
    /// Mengizinkan gembok penahan muatan dibuka, dan mendelegasikan (mengoperkan) gumpalan data balikan segar ini 
    /// ke arah tangan sang pemesan asal (Aplikasi/Widget UI) yang tadi memanggil API ini memohonnya.
    super.onResponse(response, handler);
  }

  /// Metode penangkap kondisi darurat bencana (Hook) bergelar [onError], aktif mencegat spesial di hari naas saat peladen server
  /// memicingkan matanya menolak permohonan kita beranjak masuk pintu backend (misalnya insiden blokade HTTP >= 400), 
  /// ataupun sewaktu terdampar mandek di tengah samudera ketiadaan pita sinyal konektivitas (Perkara Timeout koneksi putus tiba-tiba).
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    /// Menyiarkan rute alamat malang sang pemohon dan kode status digit nomor kemarahan eksekusi pembunuhan karakternya. (Lazimnya seperti 404, 500, 401).
    AppLogger.debug(
      '<-- ${err.response?.statusCode} ${err.response?.requestOptions.uri}',
    );
    
    /// Menjabarkan kronologi alur naratif keluhan duka cita dan jeritan lisan keterangan kegagalan teknis ini dari pihak modul jejaring internal Dio.
    AppLogger.debug('Message: ${err.message}');

    /// Mengulik kepastian jikalau runtuhnya kegagalan ini datang lantaran penampikan sepihak gerbang server backend (Membuktikan bahwa peladen backend sebenarnya sehat wal afiat dan peduli membalas surat rejeksi kita).
    if (err.response != null) {
      // Mengabarkan kembali nota sangkalan yang dilampirkan spesifik berisi alasan mendasar pengembaliannya oleh pakar server backend.
      AppLogger.debug('Response Data: ${err.response?.data}');
    }
    
    /// Cetak peringatan batas henti pengamatan rincian riwayat kegagalan (END of Error) di jurnal konsol developer log.
    AppLogger.debug('<-- END HTTP');

    /// Mengembalikan tongkat mandat urusan pelik ini di kepangkuan sang Bapak pemangku adat kelas (Parent instance `ApiTokenManager`), 
    /// lewat mediasi pemanggilan pintu `handleToken()`. Bapaknya (kelas pelindung token) nantinya yang bertugas mendeduksi/mendera vonis, apakah derita insiden ini
    /// memang cuma perkara usang isu HTTP awam belaka, atau sebuah malapetaka isu "Sesi Token Expired 401" 
    /// yang mendesak dibalas taktis untuk dilakukan manuver diam-diam menghidupkan dan merestorasi token paspor baru lantas me-retry tembakannya lagi ke sana.
    await handleToken(dio: _dio, err: err, handler: handler);
  }
}
