import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/chat/data/models/chat.dart';
import 'package:shifaa/features/chat/data/models/chat_summary.dart';
import 'package:shifaa/features/chat/data/models/message.dart';

class ChatAlreadyExistsException implements Exception {
  final String message;
  ChatAlreadyExistsException([this.message = "Chat already exists"]);
}

class ChatRemoteDataSource {
  final Dio dio;
  ChatRemoteDataSource(this.dio);

  Future<Chat> createChat(int doctorId) async {
    final res = await dio.post(EndPoint.chat, data: {"doctor_id": doctorId});
    print("DEBUG: Full response from createChat: ${jsonEncode(res.data)}");
    if (res.data["success"] == false) {
      final message = res.data["message"];
      if (message == "chat.already_exists") {
        return ChatModel.fromJson(res.data["data"]["chat"]);
      }
      if (message == "chat.unauthorized") {
        throw UnauthorizedException("You must book an appointment first");
      }
      throw Exception("Unknown error: $message");
    }
    return ChatModel.fromJson(res.data["data"]["chat"]);
  }

  Future<ChatModel> getChatDetails(int chatId) async {
    try {
      print("📤 Requesting chat details...");
      final res = await dio.get(EndPoint.getChatDetails(chatId));
      print("🕵️‍♂️ [getChatDetails Response Body]: ${jsonEncode(res.data)}");
      return ChatModel.fromJson(res.data["data"]["chat"]);
    } catch (e) {
      print('❌ getChatDetails ERROR: $e');
      rethrow;
    }
  }

  Future<Message> sendMessage(
      int chatId, {
        String? text,
        File? file,
        String? originalFileName,
        List<Map<String, String>> encryptedKeysPayload = const [],
      }) async {
    final Map<String, dynamic> dataMap = {
      'text': text,
      'encrypted_keys': encryptedKeysPayload,
    };
    if (file != null && originalFileName != null) {
      dataMap['file'] = await MultipartFile.fromFile(
        file.path,
        filename: originalFileName,
      );
    }
    final formData = FormData.fromMap(dataMap);
    print("📤 [FINAL CHECK] Sending FormData built with fromMap:");
    print("   - Fields: ${formData.fields}");
    print(
      "   - Files: ${formData.files.map((f) => 'Key: ${f.key}, Filename: ${f.value.filename}').toList()}",
    );
    try {
      final res = await dio.post(EndPoint.sendMessage(chatId), data: formData);
      print("✅✅✅ SUCCESS! API Response: ${res.data}");
      return MessageModel.fromJson(res.data["data"]);
    } on DioException catch (e) {
      print("⛔️ DioException Response Body: ${e.response?.data}");
      rethrow;
    }
  }

  Future<List<ChatSummary>> getChats() async {
    try {
      final response = await dio.get(EndPoint.chat);
      final List<dynamic> chatListJson = response.data['data']['chats'];
      return chatListJson.map((json) => ChatSummary.fromJson(json)).toList();
    } catch (e) {
      print('❌ getChats ERROR: $e');
      rethrow;
    }
  }

  Future<Chat> muteChat(int chatId) async {
    try {
      final response = await dio.post(EndPoint.muteChat(chatId));
      return ChatModel.fromJson(response.data['data']['chat']);
    } catch (e) {
      print('❌ muteChat ERROR: $e');
      rethrow;
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Unauthorized"]);
}
