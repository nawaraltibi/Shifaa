class EndPoint {
  static const String baseUrl = "https://your-api-base-url.com/api/v1/";

  static const String login = "auth/login";
  static const String register = "auth/register";
  static String getUser(String id) => "users/$id";
}

class ApiKey {
  static const String status = "status";
  static const String errorMessage = "errorMessage";
  static const String message = "message";
  static const String token = "token";
  static const String data = "data";
}
