/* Created by
   Antigravity - Principal Standards
*/

import 'package:dio/dio.dart';

/// Kelas dasar (parent) untuk semua jenis eksepsi kustom di aplikasi.
///
/// Mewarisi dari antarmuka bawaan [Exception].
abstract class AppException implements Exception {
  /// Konstruktor dasar menetapkan pesan dan opsional kode error.
  AppException(this.message, [this.code]);
  
  /// Pesan yang menjelaskan jenis kesalahan secara ramah pengguna (user-friendly).
  final String message;
  /// Kode galat atau kode status HTTP yang dikembalikan dari API.
  final String? code;

  /// Modifikasi bawaan fungsi string agar hanya mencetak pesan ralat saja.
  @override
  String toString() => message;
}

/// Eksepsi terkait kesalahan di pihak peladen (Server) secara umum, e.g 500, 502, dll.
class ServerException extends AppException {
  /// Memanggil konstruktor dasar dengan pesan baku, bila tidak ditentukan eksplisit.
  ServerException([super.message = 'Server error occurred', super.code]);
}

/// Eksepsi jika aplikasi mendeteksi tidak ada sambungan internet lokal.
class NetworkException extends AppException {
  /// Memanggil konstruktor dasar dengan nilai pesan jaringan.
  NetworkException([super.message = 'No internet connection']);
}

/// Eksepsi untuk menandakan hilangnya/kedaluwarsanya sesi kredensial akun pengguna.
class UnauthorisedException extends AppException {
  /// Menetapkan kode standar [401] ke konstruktor dan pesan kustomnya.
  UnauthorisedException([String message = 'Unauthorized access'])
      : super(message, '401');
}

/// Eksepsi jika format parameter inputan tidak valid dengan harapan API atau lokal.
class ValidationException extends AppException {
  /// Memanggil konstruktor bawaan untuk mendefinisikan ralat validasi sederhana.
  ValidationException([super.message = 'Invalid input data']);
}

/// Pembantu utilitas untuk memetakan ralat eksternal (Dio) atau lainnya
/// menuju format pengecualian kustom milik aplikasi ([AppException]).
class ExceptionMapper {
  /// Memetakan objek [error] secara otomatis berdasarkan tipenya.
  static AppException map(dynamic error) {
    // Khusus memproses error dari library Http Dio
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          // Ubah indikasi habis waktu ini ke mode ralat jaringan
          return NetworkException('Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          // Periksa jika HTTP bad response merujuk pada ketidak-otorisasian
          if (statusCode == 401) return UnauthorisedException();
          
          // Tangani secara default ke error peladen
          return ServerException(
            // Coba ambil field `message` atau gunakan pesan baku 'Server error'
            (error.response?.data?['message'] as String?) ?? 'Server error',
            statusCode?.toString(),
          );
        default:
          // Mode perlindungan ekstra ketika Dio memberikan ralat generik anomali
          return NetworkException();
      }
    }
    // Jika data yang diterima ternyata sudah terformat, langsung loloskan
    if (error is AppException) return error;
    // Tangani kemungkinan terburuk tipe error lain sebagai ServerException
    return ServerException(error.toString());
  }
}
