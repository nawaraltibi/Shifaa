import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Example: Add Authorization header if needed
    // options.headers['Authorization'] = 'Bearer YOUR_TOKEN';

    // You can also log the request
    print("➡️ API Request: ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // You can log response here if needed
    print(
      "✅ API Response: ${response.statusCode} ${response.requestOptions.uri}",
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can log errors here
    print("❌ API Error: ${err.type} | ${err.message}");

    super.onError(err, handler);
  }
}
