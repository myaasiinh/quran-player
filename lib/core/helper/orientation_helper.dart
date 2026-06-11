import 'package:flutter/services.dart';

/// Kelas pembantu untuk mengatur orientasi layar pada aplikasi.
class AppOrientation {
  /// Mengunci atau menetapkan orientasi layar yang diizinkan untuk aplikasi.
  /// 
  /// [orientations] adalah daftar [DeviceOrientation] yang diperbolehkan.
  /// Contoh: `DeviceOrientation.portraitUp` untuk mengunci posisi portrait.
  static Future<void> lock(List<DeviceOrientation> orientations) {
    return SystemChrome.setPreferredOrientations(orientations);
  }
}
