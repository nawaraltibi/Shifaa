// file: lib/features/chat/data/models/chat_summary.dart

// موديل بسيط لمعلومات الطرف الآخر في المحادثة (في حالتك، الطبيب)
class ChatParticipant {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;

  ChatParticipant({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  // دالة مساعدة للحصول على الاسم الكامل بسهولة
  String get fullName => '$firstName $lastName';

  // Factory constructor لتحويل الـ JSON إلى هذا الموديل
  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '', // رابط الصورة
    );
  }
}

// موديل بسيط لآخر رسالة في المحادثة
class LastMessage {
  final String text;
  final DateTime createdAt;

  LastMessage({required this.text, required this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      // ملاحظة: النص هنا قد يكون مشفراً. حالياً سنأخذه كما هو.
      text: json['text'] ?? 'No messages yet',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// الموديل الرئيسي الذي يمثل كل عنصر في قائمة المحادثات
class ChatSummary {
  final int id;
  final ChatParticipant doctor; // الطرف الآخر هو الطبيب
  final LastMessage? lastMessage; // قد تكون المحادثة جديدة (nullable)
  // ملاحظة: الـ API لا يرسل عدد الرسائل غير المقروءة حالياً
  final int unreadCount;

  ChatSummary({
    required this.id,
    required this.doctor,
    this.lastMessage,
    this.unreadCount = 0, // سنفترض أنها صفر حالياً
  });

  // الـ Factory constructor الرئيسي الذي يجمع كل الأجزاء
  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'] ?? 0,
      doctor: ChatParticipant.fromJson(json['doctor']),
      // تحقق إذا كانت آخر رسالة موجودة قبل محاولة تحليلها
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      // unreadCount: json['unread_messages_count'] ?? 0, // أبقِ هذا جاهزاً للمستقبل
    );
  }
}
