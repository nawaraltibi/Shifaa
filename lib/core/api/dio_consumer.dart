import 'package:dio/dio.dart';
import 'package:shifaa/core/api/api_interceptor.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options
      ..baseUrl = EndPoint.baseUrl
      ..connectTimeout = const Duration(seconds: 20)
      ..sendTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 20);

    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDiorError(e);
    }
  }

  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFromData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
      );
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDiorError(e);
    }
  }

  @override
  Future patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFromData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDiorError(e);
    }
  }

  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFromData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDiorError(e);
    }
  }

  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFromData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDiorError(e);
    }
  }
}
