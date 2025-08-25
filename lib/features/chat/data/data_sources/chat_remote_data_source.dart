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

  // في ملف ChatRemoteDataSource.dart

  // ✅✅✅ --- تم تعديل هذه الدالة بالكامل --- ✅✅✅
  // في ملف ChatRemoteDataSource.dart

  Future<ChatModel> getChatDetails(int chatId) async {
    try {
      print("📤 Requesting chat details...");
      final res = await dio.get(EndPoint.getChatDetails(chatId));

      // ✅✅✅ --- DEBUGGING --- ✅✅✅
      // سنقوم بطباعة ال-JSON الخام الذي وصل من الخادم قبل أي محاولة تحليل
      print("🕵️‍♂️ [getChatDetails Response Body]: ${jsonEncode(res.data)}");
      // هذا هو السطر الذي يسبب الخطأ على الأغلب
      return ChatModel.fromJson(res.data["data"]["chat"]);
    } catch (e) {
      print('❌ getChatDetails ERROR: $e');
      rethrow;
    }
  }

  // ✅✅✅ --- تم تعديل هذه الدالة بالكامل --- ✅✅✅
  // في ملف ChatRemoteDataSource.dart، داخل دالة sendMessage

  // في ملف ChatRemoteDataSource.dart

  Future<Message> sendMessage(
    int chatId, {
    String? text,
    File? file,
    String? originalFileName,
    List<Map<String, String>> encryptedKeysPayload = const [],
  }) async {
    // ✅✅✅ --- الإصلاح هنا: نبني FormData مباشرة --- ✅✅✅

    // 1. أنشئ كائن FormData فارغاً
    final formData = FormData();

    // 2. أضف حقل النص إذا كان موجوداً
    if (text != null) {
      formData.fields.add(MapEntry('text', text));
    }

    // 3. أضف حقل الملف إذا كان موجوداً
    if (file != null && originalFileName != null) {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(file.path, filename: originalFileName),
        ),
      );
    }

    // 4. أضف حقول encrypted_keys مباشرة إلى formData.fields
    for (int i = 0; i < encryptedKeysPayload.length; i++) {
      final keyMap = encryptedKeysPayload[i];
      formData.fields.add(
        MapEntry('encrypted_keys[$i][device_id]', keyMap['device_id']!),
      );
      formData.fields.add(
        MapEntry('encrypted_keys[$i][encrypted_key]', keyMap['encrypted_key']!),
      );
    }

    // (يمكنك إبقاء أوامر الطباعة للـ debugging إذا أردت)
    print(
      "🕵️‍♂️ [DataSource] Sending FormData with files: ${formData.files.map((f) => f.value.filename).toList()}",
    );
    print(
      "🕵️‍♂️ [DataSource] Sending FormData with fields: ${formData.fields}",
    );

    // 5. أرسل الطلب
    final res = await dio.post(EndPoint.sendMessage(chatId), data: formData);
    return MessageModel.fromJson(res.data["data"]);
  }

  Future<List<ChatSummary>> getChats() async {
    try {
      // استخدم الثابت EndPoint.chat لجلب قائمة المحادثات
      final response = await dio.get(EndPoint.chat);

      // الـ API يرجع قائمة المحادثات داخل data['chats']
      final List<dynamic> chatListJson = response.data['data']['chats'];

      // حول كل عنصر JSON في القائمة إلى موديل ChatSummary باستخدام الـ factory
      return chatListJson.map((json) => ChatSummary.fromJson(json)).toList();
    } catch (e) {
      print('❌ getChats ERROR: $e');
      rethrow; // أعد رمي الخطأ ليتم التعامل معه في الـ Repository
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Unauthorized"]);
}
