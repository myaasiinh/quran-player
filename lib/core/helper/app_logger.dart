/* Created by
   Antigravity - Principal Standards
*/

import 'package:logger/logger.dart';

/// Kelas utility untuk melakukan pencatatan log (logging) di seluruh aplikasi.
/// Membungkus package [Logger] agar penggunaannya lebih mudah dan konsisten.
class AppLogger {
  // Inisialisasi Logger dengan format tampilan PrettyPrinter.
  // Hanya menampilkan waktu dan waktu sejak aplikasi dimulai.
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Mencatat log pada level debug (d).
  /// Digunakan untuk informasi umum saat pengembangan.
  static void debug(String message) => _logger.d(message);

  /// Mencatat log pada level info (i).
  /// Digunakan untuk informasi alur normal aplikasi.
  static void info(String message) => _logger.i(message);

  /// Mencatat log pada level warning (w).
  /// Digunakan untuk peringatan atau keadaan yang mungkin berpotensi masalah.
  static void warning(String message) => _logger.w(message);

  /// Mencatat log pada level error (e).
  /// Digunakan untuk mencatat adanya error atau exception.
  /// [error] dan [stackTrace] bersifat opsional dan berguna untuk menelusuri penyebab error.
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
