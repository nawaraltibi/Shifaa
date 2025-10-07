import 'package:shifaa/features/chat/data/models/doctor_patient_chat_model.dart';
import 'package:shifaa/features/chat/data/models/message.dart';

class Chat {
  final int id;
  final bool muted;
  final DateTime createdAt;
  final List<Message> messages;
  final DoctorModel? doctor;
  final PatientModel? patient;

  Chat({
    required this.id,
    required this.muted,
    required this.createdAt,
    this.messages = const [],
    this.doctor,
    this.patient,
  });
}

class ChatModel extends Chat {
  ChatModel({
    required int id,
    required bool muted,
    required DateTime createdAt,
    List<Message> messages = const [],
    DoctorModel? doctor,
    PatientModel? patient,
  }) : super(
    id: id,
    muted: muted,
    createdAt: createdAt,
    messages: messages,
    doctor: doctor,
    patient: patient,
  );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final chatData = json['chat'] ?? json;

    return ChatModel(
      id: chatData["id"] ?? 0,
      muted: chatData["muted"] ?? false,
      createdAt: chatData["created_at"] != null
          ? DateTime.parse(chatData["created_at"])
          : DateTime.now(),
      messages: (chatData["messages"] != null && chatData["messages"] is List)
          ? (chatData["messages"] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList()
          : [],
      doctor: chatData["doctor"] != null
          ? DoctorModel.fromJson(chatData["doctor"])
          : null,
      patient: chatData["patient"] != null
          ? PatientModel.fromJson(chatData["patient"])
          : null,
    );
  }
}
