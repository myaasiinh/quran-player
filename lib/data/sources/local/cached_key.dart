/// Kelas ini berisi konstanta string statis yang digunakan sebagai kunci untuk operasi caching.
/// Ini membantu dalam mengelola dan mereferensikan kunci cache secara terpusat dan konsisten di seluruh aplikasi.
class CachedKey {
  /// Kunci cache untuk daftar fitur sampel.
  static const SAMPLE_FEATURE_LIST = 'sample_feature_list';

  /// Kunci cache untuk detail fitur sampel tertentu.
  static const SAMPLE_FEATURE_DETAIL = 'sample_feature_detail';

  /// Kunci cache untuk data profil pengguna.
  static const PROFILE = 'user_profile';

  /// Kunci cache untuk data yang terkait dengan repositori pengguna (misalnya, data pengguna yang sering diakses atau konfigurasi repositori).
  static const USER_REPOSITORY = 'user_repository';
}