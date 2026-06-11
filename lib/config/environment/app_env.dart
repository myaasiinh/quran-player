import '/config/environment/config_data.dart';

/* author
   myaasiinh@gmail.com
*/

/// Enum [Environment] mendefinisikan berbagai tingkatan lingkungan eksekusi (environment) aplikasi.
enum Environment { PRODUCTION, STAGING, DEVELOPMENT }

/// Ekstensi [EnvExtension] memberikan properti pembantu untuk mengecek status lingkungan saat ini.
extension EnvExtension on Environment {
  /// Mengembalikan true jika aplikasi berjalan di lingkungan STAGING.
  bool get isStaging => this == Environment.STAGING;

  /// Mengembalikan true jika aplikasi berjalan di lingkungan DEVELOPMENT.
  bool get isDev => this == Environment.DEVELOPMENT;

  /// Mengembalikan true jika aplikasi berjalan di lingkungan PRODUCTION.
  bool get isProduction => this == Environment.PRODUCTION;
}

/// Kelas [AppEnv] mengatur dan menyimpan nilai konfigurasi dari lingkungan saat ini.
class AppEnv {
  /// Menyimpan [ConfigData] yang berisi konfigurasi spesifik dari environment (seperti baseURL).
  static late ConfigData config;

  /// Mengambil jenis [Environment] berdasarkan nilai string 'ENV' dari parameter platform.
  /// Secara default, jika tidak diatur, akan mengembalikan [Environment.DEVELOPMENT].
  static Environment get env {
    const envStr = String.fromEnvironment('ENV', defaultValue: 'DEV');
    switch (envStr) {
      case 'PROD':
        return Environment.PRODUCTION;
      case 'STG':
        return Environment.STAGING;
      case 'DEV':
      default:
        return Environment.DEVELOPMENT;
    }
  }

  /// Mengatur konfigurasi [config] di memori sesuai dengan [Environment] dan [ConfigData] yang dilempar.
  static void set({
    required Environment environment,
    required ConfigData configuration,
  }) {
    config = configuration;
  }
}
