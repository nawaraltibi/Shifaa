class EndPoint {
  static const String baseUrl = "https://shifaa-backend.onrender.com/api/";

  // ثابتة
  static const String sendOtp = "patient/send-otp";
  static const String verifyOtp = "patient/login";
  static const String register = "patient/register";
  static const String verifyPassword = "patient/verify-password";
  static const String appointment = "appointments";
  static const String publicKey = "devices";

  // ديناميكية - دكتور
  static String doctorDetails(String doctorId) => "doctor/$doctorId";
  static String doctorSchedules(String doctorId) =>
      "doctor/$doctorId/schedules";
  static String rescheduleAppointment(int appointmentId) =>
      "appointments/$appointmentId";

  // 👇👇 روابط الشات
  static const String chat = "chats"; // POST لإنشاء محادثة جديدة
  // GET للحصول على تفاصيل المحادثة (بما في ذلك الرسائل)
  static String getChatDetails(int chatId) => "chats/$chatId";
  static String sendMessage(int chatId) =>
      "chats/$chatId/messages"; // POST إرسال رسالة
  static String muteChat(int chatId) => "chats/$chatId/mute";
}

class ApiKey {
  static const String status = "status";
  static const String message = "message";
  static const String token = "token";
  static const String data = "data";
  static const String error = "error";
}
