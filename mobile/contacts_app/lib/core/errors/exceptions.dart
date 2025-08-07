import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class AppException implements Exception, Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  bool? get stringify => true;

  String get formattedMessage => '$runtimeType: $message${code != null ? ' (code: $code)' : ''}';
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    required super.message,
    this.statusCode,
    super.stackTrace,
  }) : super(code: statusCode?.toString());

  factory ServerException.fromDioError(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final responseData = dioError.response?.data;

    String extractMessage(dynamic data) {
      if (data is Map) return data['message'] ?? data['error'] ?? data.toString();
      return data.toString();
    }

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerException(
          message: 'Connection timeout with server',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.sendTimeout:
        return ServerException(
          message: 'Request sending timeout',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Response receiving timeout',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.badCertificate:
        return ServerException(
          message: 'Invalid SSL certificate',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: extractMessage(responseData),
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request cancelled',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'Connection error: ${dioError.message}',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: 'Unexpected error: ${dioError.message}',
          statusCode: statusCode,
          stackTrace: dioError.stackTrace,
        );
    }
  }

  @override
  String toString() => formattedMessage;
}

class CacheException extends AppException {
  CacheException({
    required super.message,
    super.stackTrace,
    super.code,
  });

  @override
  String toString() => formattedMessage;
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.stackTrace,
    super.code,
  });

  @override
  String toString() => formattedMessage;
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException({
    required super.message,
    this.errors,
    super.stackTrace,
  }) : super(code: 'VALIDATION_ERROR');

  @override
  List<Object?> get props => [...super.props, errors];

  @override
  String toString() {
    if (errors == null) return formattedMessage;
    return '$formattedMessage\nValidation Errors: $errors';
  }
}