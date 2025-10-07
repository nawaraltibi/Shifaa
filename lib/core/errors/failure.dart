import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(String message, {this.statusCode}) : super(message);

  @override
  String toString() => message;

  factory ServerFailure.fromDiorError(DioException e) {
    print(
      '❌ DioException: ${e.response?.statusCode} | Data: ${e.response?.data}',
    );
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('Connection timeout with server');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('Send timeout');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Receive timeout');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled');
      case DioExceptionType.connectionError:
        return const ServerFailure('No internet connection');
      case DioExceptionType.unknown:
        return const ServerFailure('Unexpected error occurred');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic data) {
    const defaultMsg = 'An error occurred. Please try again.';

    if (data is String && data.startsWith('<!DOCTYPE html>')) {
      return const ServerFailure(
        'Server returned an HTML error page (likely 500 Internal Server Error)',
        statusCode: 500,
      );
    }
    if (statusCode == 200 || statusCode == 201) {
      return ServerFailure(
        data['message'] ?? 'Success',
        statusCode: statusCode,
      );
    }

    if (data is Map && data['message'] is String) {
      final msg = data['message'] as String;

      if (statusCode == 422 && data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        final detailedErrors = errors.entries
            .map((e) => "${e.key}: ${(e.value as List).join(", ")}")
            .join("\n");
        return ServerFailure("$msg\n$detailedErrors", statusCode: statusCode);
      }

      if (statusCode == 400 ||
          statusCode == 401 ||
          statusCode == 403 ||
          statusCode == 404) {
        return ServerFailure(msg, statusCode: statusCode);
      }

      return ServerFailure(msg, statusCode: statusCode);
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
      case 404:
        return ServerFailure(
          data?['error']?['message'] ?? defaultMsg,
          statusCode: statusCode,
        );
      case 422:
        if (data is Map && data['errors'] is Map<String, dynamic>) {
          final errors = data['errors'] as Map<String, dynamic>;
          final detailedErrors = errors.entries
              .map((e) => "${e.key}: ${(e.value as List).join(", ")}")
              .join("\n");
          return ServerFailure(detailedErrors, statusCode: statusCode);
        }
        return ServerFailure(
          data?['message'] ?? defaultMsg,
          statusCode: statusCode,
        );
      case 500:
        final msg = (data is Map && data['message'] is String)
            ? data['message']
            : data.toString();
        return ServerFailure(
          msg ?? 'Server error. Try again later.',
          statusCode: 500,
        );

      default:
        return ServerFailure(defaultMsg, statusCode: statusCode);
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
