import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';

class ApiInterceptor extends Interceptor {
  @override
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPrefsHelper.instance.getToken();
    final locale = Intl.getCurrentLocale();

    // Define endpoints that do NOT require token
    final unauthenticatedEndpoints = [
      EndPoint.sendOtp,
      EndPoint.verifyOtp,
      EndPoint.register,
      EndPoint.verifyPassword,
    ];

    // Check if current request matches one of them
    final isUnauthenticated = unauthenticatedEndpoints.any(
      (unauth) => options.path.contains(unauth),
    );

    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': locale == 'ar' ? 'ar' : 'en',
      if (!isUnauthenticated && token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    });

    print("➡️ API Request: ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      "✅ API Response: ${response.statusCode} ${response.requestOptions.uri}",
    );
    print("Response Body: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ API Error: ${err.type} | ${err.message}");
    if (err.response != null) {
      print("Error Response Body: ${err.response?.data}");
    }
    super.onError(err, handler);
  }
}
