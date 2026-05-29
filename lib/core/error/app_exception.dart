/* Created by
   Antigravity - Principal Standards
*/

import 'package:dio/dio.dart';

/// Base class for all application exceptions.
abstract class AppException implements Exception {
  AppException(this.message, [this.code]);
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred', super.code]);
}

class NetworkException extends AppException {
  NetworkException([super.message = 'No internet connection']);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message = 'Unauthorized access'])
      : super(message, '401');
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Invalid input data']);
}

/// Helper to map Dio/External errors to AppExceptions
class ExceptionMapper {
  static AppException map(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException('Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return UnauthorisedException();
          return ServerException(
            (error.response?.data?['message'] as String?) ?? 'Server error',
            statusCode?.toString(),
          );
        default:
          return NetworkException();
      }
    }
    if (error is AppException) return error;
    return ServerException(error.toString());
  }
}
