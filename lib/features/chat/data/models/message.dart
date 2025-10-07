import 'package:shifaa/features/chat/data/models/message_status.dart';

class EncryptedKeyTarget {
  final int deviceId;
  final String encryptedKey;

  EncryptedKeyTarget({required this.deviceId, required this.encryptedKey});

  factory EncryptedKeyTarget.fromJson(Map<String, dynamic> json) {
    final idValue = json['device_id'] ?? json['id'];
    return EncryptedKeyTarget(
      deviceId: idValue is int ? idValue : int.tryParse(idValue.toString()) ?? 0,
      encryptedKey: json['encrypted_key'] ?? '',
    );
  }
}

class Message {
  final int id;
  final String? text;
  final String? file;
  final String senderRole;
  final int senderId;
  final DateTime createdAt;
  final MessageStatus status;
  final String? localFilePath;
  final List<EncryptedKeyTarget> encryptedKeys;

  Message({
    required this.id,
    this.text,
    this.file,
    required this.senderRole,
    required this.senderId,
    required this.createdAt,
    this.status = MessageStatus.sent,
    this.localFilePath,
    this.encryptedKeys = const [],
  });

  Message copyWith({
    int? id,
    String? text,
    String? file,
    String? senderRole,
    int? senderId,
    DateTime? createdAt,
    MessageStatus? status,
    String? localFilePath,
    List<EncryptedKeyTarget>? encryptedKeys,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      file: file ?? this.file,
      senderRole: senderRole ?? this.senderRole,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      localFilePath: localFilePath ?? this.localFilePath,
      encryptedKeys: encryptedKeys ?? this.encryptedKeys,
    );
  }
}

class MessageModel extends Message {
  MessageModel({
    required int id,
    String? text,
    String? file,
    required String senderRole,
    required int senderId,
    required DateTime createdAt,
    MessageStatus status = MessageStatus.sent,
    String? localFilePath,
    List<EncryptedKeyTarget> encryptedKeys = const [],
  }) : super(
    id: id,
    text: text,
    file: file,
    senderRole: senderRole,
    senderId: senderId,
    createdAt: createdAt,
    status: status,
    localFilePath: localFilePath,
    encryptedKeys: encryptedKeys,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final List<EncryptedKeyTarget> keys;
    if (json['devices'] != null && json['devices'] is List) {
      keys = (json['devices'] as List)
          .map((e) => EncryptedKeyTarget.fromJson(e))
          .toList();
    } else {
      keys = [];
    }

    return MessageModel(
      id: json["id"] ?? 0,
      text: json["text"],
      file: json["file"],
      senderRole: json["sender_type"] ?? "",
      senderId: json["sender_id"] ?? 0,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
      encryptedKeys: keys,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "file": file,
      "sender_type": senderRole,
      "sender_id": senderId,
      "created_at": createdAt.toIso8601String(),
      "devices": encryptedKeys
          .map((e) => {"id": e.deviceId, "encrypted_key": e.encryptedKey})
          .toList(),
    };
  }
}
