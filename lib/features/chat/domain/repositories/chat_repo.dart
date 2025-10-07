// repository interface
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/chat/data/models/chat.dart';
import 'package:shifaa/features/chat/data/models/chat_summary.dart';
import 'package:shifaa/features/chat/data/models/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Chat>> createChat(int doctorId);
  Future<Either<Failure, ChatModel>> getChatDetails(int chatId);
  Future<Either<Failure, Message>> sendMessage(
    int chatId, {
    String? text,
    File? file,
    String? originalFileName,
    List<Map<String, String>> encryptedKeysPayload = const [],
  });
  Future<Either<Failure, List<ChatSummary>>> getChats();
  Future<Either<Failure, Chat>> muteChat(int chatId);
}
