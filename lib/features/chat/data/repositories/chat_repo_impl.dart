// repository impl
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:shifaa/features/chat/data/models/chat.dart';
import 'package:shifaa/features/chat/data/models/chat_summary.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Chat>> createChat(int doctorId) async {
    try {
      final chat = await remote.createChat(doctorId);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // في ملف ChatRepositoryImpl.dart

  // ✅✅✅ --- تم تعديل هذه الدالة بالكامل --- ✅✅✅
  @override
  // في ملف ChatRepositoryImpl.dart
  Future<Either<Failure, ChatModel>> getChatDetails(int chatId) async {
    try {
      final chat = await remote.getChatDetails(chatId);
      return Right(chat);
    } on DioException catch (e) {
      // ملاحظة: تأكد من أن اسم الدالة هو fromDioError وليس fromDiorError
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      // ✅✅✅ --- هذا هو الإصلاح --- ✅✅✅
      // نقوم بإنشاء كائن جديد من ServerFailure ونمرر له رسالة الخطأ
      return Left(ServerFailure(e.toString()));
    }
  }

  // في ملف ChatRepositoryImpl.dart، داخل دالة sendMessage

  @override
  Future<Either<Failure, Message>> sendMessage(
    int chatId, {
    String? text,
    File? file,
    List<Map<String, String>> encryptedKeysPayload = const [],
  }) async {
    try {
      String? originalFileName;
      if (file != null) {
        final encryptedFileName = file.path.split('/').last;
        originalFileName = encryptedFileName.replaceAll('.enc', '');

        // ✅✅✅ --- DEBUGGING --- ✅✅✅
        print("🕵️‍♂️ [Repo] Encrypted file name: $encryptedFileName");
        print("🕵️‍♂️ [Repo] Original file name extracted: $originalFileName");
      }

      final msg = await remote.sendMessage(
        chatId,
        text: text,
        file: file,
        originalFileName: originalFileName,
        encryptedKeysPayload: encryptedKeysPayload,
      );
      return Right(msg);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatSummary>>> getChats() async {
    try {
      // استدعِ الدالة من الـ remote data source
      final chats = await remote.getChats();
      // في حالة النجاح، أرجع البيانات داخل Right
      return Right(chats);
    } on DioException catch (e) {
      // في حالة حدوث خطأ من Dio، قم بتحويله إلى ServerFailure
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      // لأي خطأ آخر، قم بإرجاعه كـ ServerFailure
      return Left(ServerFailure(e.toString()));
    }
  }
}
