class EndPoint {
  static const String baseUrl = "https://shifaa-backend.onrender.com/api/";

  static const String sendOtp = "patient/send-otp";
  static const String verifyOtp = "patient/login";
  static const String register = "patient/register";
  static const String verifyPassword = "patient/verify-password";
  static const String appointment = "appointments";
  static const String publicKey = "devices";

  static String doctorDetails(String doctorId) => "doctor/$doctorId";

  static String doctorSchedules(String doctorId) =>
      "doctor/$doctorId/schedules";

  static String rescheduleAppointment(int appointmentId) =>
      "appointments/$appointmentId";

  static String cancelAppointment(int appointmentId) => "$appointmentId/cancel";

  static const String chat = "chats";

  static String getChatDetails(int chatId) => "chats/$chatId";

  static String sendMessage(int chatId) => "chats/$chatId/messages";

  static String muteChat(int chatId) => "chats/$chatId/mute";
}

class ApiKey {
  static const String status = "status";
  static const String message = "message";
  static const String token = "token";
  static const String data = "data";
  static const String error = "error";
}
