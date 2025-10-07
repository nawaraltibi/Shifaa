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

  @override
  Future<Either<Failure, ChatModel>> getChatDetails(int chatId) async {
    try {
      final chat = await remote.getChatDetails(chatId);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
      int chatId, {
        String? text,
        File? file,
        String? originalFileName,
        List<Map<String, String>> encryptedKeysPayload = const [],
      }) async {
    try {
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
      final chats = await remote.getChats();
      return Right(chats);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> muteChat(int chatId) async {
    try {
      final chat = await remote.muteChat(chatId);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
