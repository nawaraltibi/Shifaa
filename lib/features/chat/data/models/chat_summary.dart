import 'package:shifaa/features/book_appointments/data/models/doctor_model.dart';
import 'package:shifaa/features/chat/data/models/message.dart';

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

  String get fullName => '$firstName $lastName';

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

class LastMessage {
  final String text;
  final DateTime createdAt;

  LastMessage({required this.text, required this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      text: json['text'] ?? 'No messages yet',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ChatSummary {
  final int id;
  final DoctorModel doctor;
  final Message? lastMessage;
  final int unreadCount;

  ChatSummary({
    required this.id,
    required this.doctor,
    this.lastMessage,
    required this.unreadCount,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'],
      doctor: DoctorModel.fromJson(json['doctor']),
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  ChatSummary copyWith({
    int? id,
    DoctorModel? doctor,
    Message? lastMessage,
    int? unreadCount,
  }) {
    return ChatSummary(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
