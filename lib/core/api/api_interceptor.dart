import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPrefsHelper.instance.getToken();
    final locale = Intl.getCurrentLocale();

    final unauthenticatedEndpoints = [
      EndPoint.sendOtp,
      EndPoint.verifyOtp,
      EndPoint.register,
      EndPoint.verifyPassword,
    ];

    final isUnauthenticated = unauthenticatedEndpoints.any(
      (unauth) => options.path.contains(unauth),
    );

    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = locale == 'ar' ? 'ar' : 'en';
    if (!isUnauthenticated && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json';
    }

    print("➡️➡️➡️ --- Request --- ⬅️⬅️⬅️");
    print("URI: ${options.uri}");
    print("METHOD: ${options.method}");
    print("HEADERS: ${options.headers}");

    if (options.data is FormData) {
      final formData = options.data as FormData;
      print("BODY (FormData Fields): ${formData.fields}");
      print(
        "BODY (FormData Files): ${formData.files.map((f) => f.value.filename)}",
      );
    } else {
      print("BODY: ${options.data}");
    }
    print("➡️➡️➡️ --- End Request --- ⬅️⬅️⬅️");
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

    final response = err.response;
    if (response != null) {
      print("⛔ Status Code: ${response.statusCode}");
      print("⛔ Response Headers: ${response.headers}");

      try {
        print("⛔ Response Body: ${response.data}");
      } catch (e) {
        print("⚠️ Failed to parse response body: $e");
      }

      if (response.data is! Map && response.data is! List) {
        print("⛔ Raw Response Body as String: ${response.data.toString()}");
      }
    } else {
      print("❌ No response from server (might be a network issue).");
    }

    super.onError(err, handler);
  }
}
