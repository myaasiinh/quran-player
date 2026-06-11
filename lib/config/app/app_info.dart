import 'package:package_info_plus/package_info_plus.dart';

/// Kelas [AppInfo] digunakan untuk menyimpan informasi terkait aplikasi,
/// seperti versi, nomor build (build number), dan nama paket aplikasi.
/* author
   myaasiinh@gmail.com
*/
class AppInfo {
  /// Instance dari [PackageInfo] yang menyimpan detail paket aplikasi.
  static late PackageInfo packageInfo;

  /// Menginisialisasi informasi paket aplikasi dengan mengambil data dari platform.
  static Future<void> init() async {
    // Meminta platform untuk mengambil informasi package aplikasi saat ini.
    await PackageInfo.fromPlatform();
  }

  /// Menyimpan versi dari aplikasi (misal: "1.0.0").
  static String appVersion = AppInfo.packageInfo.version;
  
  /// Menyimpan nomor build dari aplikasi (misal: "1").
  static String buildNumber = AppInfo.packageInfo.buildNumber;
  
  /// Menyimpan nama paket dari aplikasi (misal: "com.example.app").
  static String packageName = AppInfo.packageInfo.packageName;
}
