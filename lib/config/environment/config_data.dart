import 'package:quran_player/config/network/api_token_manager.dart';

/// Kelas model data untuk menyimpan konfigurasi environment aplikasi
/// 
/// Memuat data seperti alamat peladen (base url), tipe otorisasi, 
/// kunci otorisasi klien, dan juga sertifikat SSL (SSL Pinning).
class ConfigData {
  /// Konstruktor dasar untuk menetapkan data environment.
  ConfigData({
    required this.baseUrl,
    required this.tokenType,
    required this.clientToken,
    this.sslFingerprints = const [],
    this.enableSslPinning = false,
    this.maxRetry = 3,
  });

  /// Alamat peladen dasar dari API.
  String baseUrl;
  /// Jenis token yang digunakan, misal Bearer atau tanpa token (NONE).
  TokenType tokenType;
  /// Kunci kredensial akses utama.
  String clientToken;
  /// Daftar sidik jari SSL untuk keamanan man-in-the-middle.
  List<String> sslFingerprints;
  /// Status apakah mengecek pin SSL.
  bool enableSslPinning;
  /// Percobaan ulang pengiriman ke server jika gagal.
  int maxRetry;

  /// Lingkungan pengembangan (Development)
  static final dev = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
  );

  /// Lingkungan pratinjau (Staging)
  static final stg = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
  );

  /// Lingkungan produksi yang siap rilis (Production)
  static final prod = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
    enableSslPinning: true,
    sslFingerprints: [
      // Tambahkan Sidik Jari SSL API Al-Quran disini jika dibutuhkan nantinya
    ],
  );
}
