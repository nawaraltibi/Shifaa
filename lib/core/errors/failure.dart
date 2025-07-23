import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDiorError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('Connection timeout with API server');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('Send timeout with API server');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Receive timeout with API server');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate with API server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response!.statusCode!,
          e.response!.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Request to API server was cancelled');
      case DioExceptionType.connectionError:
        return const ServerFailure('No Internet Connection');
      case DioExceptionType.unknown:
        return const ServerFailure('Oops, there was an error. Please try again.');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 404) {
      return const ServerFailure('Your request was not found, please try later.');
    } else if (statusCode == 500) {
      return const ServerFailure('There is a problem with the server, please try later.');
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
   
      if (response is Map<String, dynamic> &&
          response.containsKey('error') &&
          response['error'] is Map<String, dynamic> &&
          response['error'].containsKey('message')) {
        return ServerFailure(response['error']['message']);
      }
      return const ServerFailure('An error occurred, please try again.');
    } else {
      return const ServerFailure('There was an error, please try again.');
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
