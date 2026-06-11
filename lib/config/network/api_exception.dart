import '/config/network/api_message.dart';
import '/config/network/api_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kelas dasar berselimut ([sealed]) yang berfungsi sebagai penampung 
/// untuk rincian error jaringan (API), mengimplementasikan [ApiMessage] agar pesan error dapat dikonversi.
sealed class NetworkExceptionData with ApiMessage {
  /// Konstruktor kelas data error, membutuhkan informasi opsional berupa [prefix], [message], dan [response].
  NetworkExceptionData({this.prefix, this.message, this.response});
  
  /// Awalan pesan error opsional.
  final String? prefix;
  
  /// Pesan error sesungguhnya.
  final String? message;
  
  /// Keseluruhan data respons API dari pemanggilan yang gagal.
  final Response? response;

  /// Membentuk string pesan error yang bersahabat.
  /// Jika HTTP status adalah 400, pesan dicoba diekstrak dari body JSON.
  @override
  String toString() {
    var result = '';
    if (response?.statusCode == 400) {
      final res = ApiResponse.fromJson(response?.data as Map<String, dynamic>);
      result = convertMessage(res.error ?? res.message);
    } else {
      result += (prefix != null) ? '$prefix, $message' : '$message';
    }
    return result;
  }
}

/// Mixin [NetworkException] mengimplementasikan tipe [Exception].
/// Digunakan untuk memetakan kegagalan HTTP dan error lainnya menjadi [NetworkExceptionData].
mixin NetworkException implements Exception {
  /// Memeriksa kode status HTTP dari [response] dan mengembalikan spesifik objek exception jaringan.
  NetworkExceptionData handleResponse(Response response) {
    final statusCode = response.statusCode!;
    return switch (statusCode) {
      400 || 403 || 422 => BadRequestException(response: response),
      401 => UnauthorisedException(),
      404 => NotFoundException(),
      409 => FetchDataException(),
      408 => SendTimeOutException(),
      413 => RequestEntityTooLargeException(),
      500 || 503 => InternalServerErrorException(),
      _ => FetchDataException(
          message: 'Received invalid status code: $statusCode',
          response: response,
        ),
    };
  }

  /// Memproses exception apa pun (terutama dari [DioException]) dan menerjemahkannya
  /// menjadi salah satu implementasi [NetworkExceptionData].
  NetworkExceptionData getErrorException(dynamic error) {
    if (error is Exception) {
      try {
        NetworkExceptionData networkExceptions;
        if (error is DioException) {
          networkExceptions = switch (error.type) {
            DioExceptionType.cancel => RequestCancelled(),
            DioExceptionType.connectionTimeout => ConnectionTimeOutException(),
            DioExceptionType.receiveTimeout => ReceiveTimeOutException(),
            DioExceptionType.sendTimeout => SendTimeOutException(),
            DioExceptionType.unknown => error.error is SocketException
                ? SocketException()
                : FetchDataException(),
            DioExceptionType.badResponse => handleResponse(error.response!),
            DioExceptionType.badCertificate => BadCertificateException(),
            DioExceptionType.connectionError => ConnectionTimeOutException(),
          };
        } else if (error is SocketException) {
          networkExceptions = SocketException();
        } else {
          networkExceptions = UnexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return FetchDataException();
      } catch (_) {
        return UnexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return UnableToProcess();
      } else {
        return UnexpectedError();
      }
    }
  }
}

/// Tipe exception untuk indikasi batas waktu koneksi telah habis.
final class ConnectionTimeOutException extends NetworkExceptionData {
  ConnectionTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe exception untuk indikasi batas waktu penerimaan data (receive timeout) telah habis.
final class ReceiveTimeOutException extends NetworkExceptionData {
  ReceiveTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe exception untuk indikasi batas waktu pengiriman data (send timeout) telah habis.
final class SendTimeOutException extends NetworkExceptionData {
  SendTimeOutException() : super(message: 'txt_connection_timeout'.tr);
}

/// Tipe exception saat server backend mengalami kendala (HTTP 500 / 503).
final class InternalServerErrorException extends NetworkExceptionData {
  InternalServerErrorException()
      : super(message: 'txt_internal_server_error'.tr);
}

/// Tipe exception jika data yang diminta melebihi batasan sistem (HTTP 413).
final class RequestEntityTooLargeException extends NetworkExceptionData {
  RequestEntityTooLargeException({super.response})
      : super(message: 'txt_request_entity_to_large'.tr);
}

/// Tipe exception general saat proses transmisi data gagal.
final class FetchDataException extends NetworkExceptionData {
  FetchDataException({String? message, super.response})
      : super(message: message ?? 'txt_error_during_communication'.tr);
}

/// Tipe exception jika file rute, atau resource pada API tidak tersedia (HTTP 404).
final class NotFoundException extends NetworkExceptionData {
  NotFoundException({String? message, super.response})
      : super(message: message ?? 'txt_not_found'.tr);
}

/// Tipe exception untuk API yang gagal karena parameter yang dikirim tidak sesuai (HTTP 400, 403, 422).
final class BadRequestException extends NetworkExceptionData {
  BadRequestException({super.response})
      : super(
          prefix: 'txt_bad_request'.tr,
          message: '${'txt_message'.tr}: ${response?.statusMessage}',
        );
}

/// Tipe exception di mana keamanan atau sertifikat di rute yang diakses bermasalah.
final class BadCertificateException extends NetworkExceptionData {
  BadCertificateException({super.response})
      : super(message: 'txt_bad_certificate'.tr);
}

/// Tipe exception yang menandakan gagalnya autentikasi pengguna (HTTP 401).
final class UnauthorisedException extends NetworkExceptionData {
  UnauthorisedException({super.response})
      : super(message: 'txt_unauthorized'.tr);
}

/// Tipe exception apabila masukan / inputan yang diproses tidak sah.
final class InvalidInputException extends NetworkExceptionData {
  InvalidInputException({super.response})
      : super(message: 'txt_invalid_input'.tr);
}

/// Tipe exception di mana request API sudah digagalkan secara paksa.
final class RequestCancelled extends NetworkExceptionData {
  RequestCancelled({super.response}) : super(message: 'txt_request_cancel'.tr);
}

/// Tipe exception apabila alat yang digunakan tidak tersambung ke koneksi internet manapun.
final class SocketException extends NetworkExceptionData {
  SocketException({super.response})
      : super(message: 'txt_no_internet_connection'.tr);
}

/// Tipe exception apabila error yang dialami masih ambigu.
final class UnexpectedError extends NetworkExceptionData {
  UnexpectedError({super.response}) : super(message: 'txt_unexpected_error'.tr);
}

/// Tipe exception pada saat format response tidak sesuai dugaan atau membatalkan format.
final class UnableToProcess extends NetworkExceptionData {
  UnableToProcess({super.response})
      : super(message: 'txt_unable_to_process'.tr);
}
