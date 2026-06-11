import '/config/network/api_message.dart';
import '/config/network/api_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas dasar berselimut ([sealed]) yang berfungsi sebagai penampung 
/// untuk rincian error jaringan (API), mengimplementasikan [ApiMessage] 
/// agar pesan error dapat dikonversi dengan mudah.
sealed class NetworkExceptionData with ApiMessage {
  /// Konstruktor kelas data error, membutuhkan informasi opsional berupa 
  /// [prefix], [message], dan [response].
  NetworkExceptionData({this.prefix, this.message, this.response});
  
  /// Awalan pesan error yang bersifat opsional.
  final String? prefix;
  
  /// Pesan error utama yang mendeskripsikan masalah.
  final String? message;
  
  /// Keseluruhan data respons API dari pemanggilan yang gagal.
  final Response? response;

  /// Membentuk string pesan error yang bersahabat untuk pengguna.
  /// Jika kode status HTTP adalah 400, pesan dicoba diekstrak dari isi JSON respons.
  @override
  String toString() {
    // Menginisialisasi hasil sebagai string kosong
    var result = '';
    
    // Mengecek apakah respons memiliki kode status 400 (Bad Request)
    if (response?.statusCode == 400) {
      // Melakukan parsing data respons menjadi objek ApiResponse
      final res = ApiResponse.fromJson(response?.data as Map<String, dynamic>);
      // Mengonversi dan mengambil pesan error atau pesan umum dari respons
      result = convertMessage(res.error ?? res.message);
    } else {
      // Jika bukan 400, gabungkan prefix dan message jika prefix tidak null
      result += (prefix != null) ? '$prefix, $message' : '$message';
    }
    
    // Mengembalikan hasil string pesan
    return result;
  }
}

/// Mixin [NetworkException] mengimplementasikan antarmuka [Exception].
/// Digunakan untuk memetakan kegagalan HTTP dan error lainnya menjadi 
/// turunan kelas [NetworkExceptionData].
mixin NetworkException implements Exception {
  /// Memeriksa kode status HTTP dari [response] dan mengembalikan 
  /// objek eksepsi jaringan yang spesifik berdasarkan kodenya.
  NetworkExceptionData handleResponse(Response response) {
    // Mengambil nilai status code dari respons
    final statusCode = response.statusCode!;
    
    // Menggunakan ekspresi switch untuk memetakan kode status ke eksepsi
    return switch (statusCode) {
      // Jika status 400, 403, atau 422, kembalikan BadRequestException
      400 || 403 || 422 => BadRequestException(response: response),
      // Jika status 401, kembalikan UnauthorisedException
      401 => UnauthorisedException(),
      // Jika status 404, kembalikan NotFoundException
      404 => NotFoundException(),
      // Jika status 409, kembalikan FetchDataException
      409 => FetchDataException(),
      // Jika status 408, kembalikan SendTimeOutException
      408 => SendTimeOutException(),
      // Jika status 413, kembalikan RequestEntityTooLargeException
      413 => RequestEntityTooLargeException(),
      // Jika status 500 atau 503, kembalikan InternalServerErrorException
      500 || 503 => InternalServerErrorException(),
      // Jika kode status lainnya, kembalikan eksepsi umum dengan pesan spesifik
      _ => FetchDataException(
          message: 'Received invalid status code: $statusCode',
          response: response,
        ),
    };
  }

  /// Memproses exception apa pun (terutama dari [DioException]) dan menerjemahkannya
  /// menjadi salah satu implementasi [NetworkExceptionData].
  NetworkExceptionData getErrorException(dynamic error) {
    // Mengecek apakah error merupakan tipe turunan dari Exception
    if (error is Exception) {
      try {
        // Deklarasi variabel untuk menyimpan eksepsi jaringan spesifik
        NetworkExceptionData networkExceptions;
        
        // Memeriksa jika error merupakan eksepsi dari package Dio
        if (error is DioException) {
          // Melakukan pemetaan tipe DioException ke eksepsi lokal menggunakan switch
          networkExceptions = switch (error.type) {
            // Pemetaan jika request dibatalkan
            DioExceptionType.cancel => RequestCancelled(),
            // Pemetaan untuk timeout koneksi
            DioExceptionType.connectionTimeout => ConnectionTimeOutException(),
            // Pemetaan untuk timeout penerimaan data
            DioExceptionType.receiveTimeout => ReceiveTimeOutException(),
            // Pemetaan untuk timeout pengiriman data
            DioExceptionType.sendTimeout => SendTimeOutException(),
            // Pemetaan untuk kesalahan tak diketahui
            DioExceptionType.unknown => error.error is SocketException
                ? SocketException()
                : FetchDataException(),
            // Pemetaan jika respons buruk, gunakan fungsi handleResponse
            DioExceptionType.badResponse => handleResponse(error.response!),
            // Pemetaan untuk sertifikat yang buruk
            DioExceptionType.badCertificate => BadCertificateException(),
            // Pemetaan untuk masalah koneksi
            DioExceptionType.connectionError => ConnectionTimeOutException(),
          };
        } else if (error is SocketException) {
          // Jika error secara spesifik berupa SocketException
          networkExceptions = SocketException();
        } else {
          // Jika error tipe lain, anggap sebagai error tidak terduga
          networkExceptions = UnexpectedError();
        }
        // Mengembalikan objek eksepsi jaringan yang telah dipetakan
        return networkExceptions;
      } on FormatException catch (_) {
        // Menangkap kesalahan format JSON dan mengembalikan FetchDataException
        return FetchDataException();
      } catch (_) {
        // Menangkap kesalahan umum lainnya
        return UnexpectedError();
      }
    } else {
      // Jika objek error bukan turunan dari Exception, lakukan pengecekan berbasis string
      if (error.toString().contains('is not a subtype of')) {
        // Jika ada isu tipe (casting type error)
        return UnableToProcess();
      } else {
        // Jika tidak dikenali
        return UnexpectedError();
      }
    }
  }
}

/// Tipe eksepsi untuk mengindikasikan bahwa batas waktu koneksi telah habis.
final class ConnectionTimeOutException extends NetworkExceptionData {
  /// Konstruktor memanggil super constructor dengan pesan lokalisasi batas waktu koneksi.
  ConnectionTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe eksepsi untuk mengindikasikan bahwa batas waktu penerimaan data telah habis.
final class ReceiveTimeOutException extends NetworkExceptionData {
  /// Konstruktor memanggil super constructor dengan pesan lokalisasi batas waktu penerimaan.
  ReceiveTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe eksepsi untuk mengindikasikan bahwa batas waktu pengiriman data telah habis.
final class SendTimeOutException extends NetworkExceptionData {
  /// Konstruktor memanggil super constructor dengan pesan lokalisasi batas waktu pengiriman.
  SendTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe eksepsi saat server backend mengalami kendala (misal: HTTP 500 atau 503).
final class InternalServerErrorException extends NetworkExceptionData {
  /// Konstruktor memanggil super constructor dengan pesan lokalisasi kesalahan internal.
  InternalServerErrorException()
      : super(message: 'txt_internal_server_error'.tr);
}

/// Tipe eksepsi jika payload data yang diminta melebihi batasan server (HTTP 413).
final class RequestEntityTooLargeException extends NetworkExceptionData {
  /// Konstruktor menerima [response] asli dan mengatur pesan error ke entitas terlalu besar.
  RequestEntityTooLargeException({super.response})
      : super(message: 'txt_request_entity_to_large'.tr);
}

/// Tipe eksepsi umum untuk kesalahan saat proses transmisi atau pengambilan data.
final class FetchDataException extends NetworkExceptionData {
  /// Konstruktor menerima [message] opsional dan [response]. Jika pesan tidak ada, gunakan default.
  FetchDataException({String? message, super.response})
      : super(message: message ?? 'txt_error_during_communication'.tr);
}

/// Tipe eksepsi jika rute, file, atau resource yang dicari tidak ditemukan di server (HTTP 404).
final class NotFoundException extends NetworkExceptionData {
  /// Konstruktor menerima [message] dan [response]. Akan menampilkan default jika pesan kosong.
  NotFoundException({String? message, super.response})
      : super(message: message ?? 'txt_not_found'.tr);
}

/// Tipe eksepsi untuk respons klien yang buruk akibat parameter tidak sesuai (HTTP 400, 403, 422).
final class BadRequestException extends NetworkExceptionData {
  /// Konstruktor mengekstrak [statusMessage] dari respons untuk melengkapi pesan kesalahan.
  BadRequestException({super.response})
      : super(
          prefix: 'txt_bad_request'.tr,
          message: '${'txt_message'.tr}: ${response?.statusMessage}',
        );
}

/// Tipe eksepsi saat terdapat masalah pada keamanan sertifikat server tujuan.
final class BadCertificateException extends NetworkExceptionData {
  /// Konstruktor meneruskan [response] dan menampilkan pesan sertifikat tidak valid.
  BadCertificateException({super.response})
      : super(message: 'txt_bad_certificate'.tr);
}

/// Tipe eksepsi yang menandakan sesi tidak memiliki izin atau gagal autentikasi (HTTP 401).
final class UnauthorisedException extends NetworkExceptionData {
  /// Konstruktor meneruskan respons dan memberikan pesan kesalahan tidak sah (unauthorized).
  UnauthorisedException({super.response})
      : super(message: 'txt_unauthorized'.tr);
}

/// Tipe eksepsi yang digunakan saat input data yang diproses tidak valid.
final class InvalidInputException extends NetworkExceptionData {
  /// Konstruktor meneruskan respons dan memberikan pesan input tidak sah.
  InvalidInputException({super.response})
      : super(message: 'txt_invalid_input'.tr);
}

/// Tipe eksepsi yang menyatakan permintaan jaringan secara sengaja dibatalkan oleh klien.
final class RequestCancelled extends NetworkExceptionData {
  /// Konstruktor memberikan pesan bahwa permintaan (request) berhasil dibatalkan.
  RequestCancelled({super.response}) : super(message: 'txt_request_cancel'.tr);
}

/// Tipe eksepsi ketika perangkat gagal menyambung ke internet.
final class SocketException extends NetworkExceptionData {
  /// Konstruktor memberikan peringatan tidak ada koneksi internet.
  SocketException({super.response})
      : super(message: 'txt_no_internet_connection'.tr);
}

/// Tipe eksepsi untuk menampung seluruh error lain yang belum diidentifikasi.
final class UnexpectedError extends NetworkExceptionData {
  /// Konstruktor menampilkan pesan umum error tak terduga.
  UnexpectedError({super.response}) : super(message: 'txt_unexpected_error'.tr);
}

/// Tipe eksepsi di mana format respons API gagal di-parsing atau tidak sesuai skema.
final class UnableToProcess extends NetworkExceptionData {
  /// Konstruktor menginformasikan bahwa data tidak bisa diproses secara valid.
  UnableToProcess({super.response})
      : super(message: 'txt_unable_to_process'.tr);
}
