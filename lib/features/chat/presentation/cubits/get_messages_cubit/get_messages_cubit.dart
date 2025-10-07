import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/crypto_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/data/models/message_status.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

part 'get_messages_state.dart';

class GetMessagesCubit extends Cubit<GetMessagesState> {
  final ChatRepository repository;

  GetMessagesCubit(this.repository) : super(GetMessagesInitial());

  void replaceTempMessageWithSentMessage(int tempId, Message sentMessage) {
    if (state is! GetMessagesSuccess) return;

    final currentState = state as GetMessagesSuccess;
    final currentMessages = currentState.messages;

    final messageIndex = currentMessages.indexWhere((msg) => msg.id == tempId);

    if (messageIndex == -1) return;

    final List<Message> newMessages = List.from(currentMessages);

    newMessages[messageIndex] = sentMessage.copyWith(
      status: MessageStatus.sent,
      text: currentMessages[messageIndex].text,
      localFilePath: currentMessages[messageIndex].localFilePath,
      senderRole: currentMessages[messageIndex].senderRole,
    );

    emit(GetMessagesSuccess(newMessages));
  }

  Future<void> fetchMessages(int chatId) async {
    emit(GetMessagesLoading());
    final result = await repository.getChatDetails(chatId);

    result.fold((failure) => emit(GetMessagesFailure(failure.message)), (
        chat,
        ) async {
      final List<Message> processedMessages = [];
      for (final message in chat.messages) {
        if (message is MessageModel) {
          final aesKey = await getAesKey(message);
          final decryptedMessage = await decryptText(message, aesKey);
          processedMessages.add(decryptedMessage);
        } else {
          processedMessages.add(message);
        }
      }
      emit(GetMessagesSuccess(processedMessages));
    });
  }

  Future<void> addMessage(Message message) async {
    if (state is! GetMessagesSuccess) return;

    if (message.senderRole == 'patient' && message.id > 0) return;

    final currentMessages = (state as GetMessagesSuccess).messages;
    if (currentMessages.any((msg) => msg.id == message.id && msg.id > 0)) return;

    Message finalMessage = message;
    if (message.senderRole != 'patient' && message is MessageModel) {
      final aesKey = await getAesKey(message);
      finalMessage = await decryptText(message, aesKey);
    }

    final newMessages = [...currentMessages, finalMessage];
    emit(GetMessagesSuccess(newMessages));
  }

  void updateMessageStatus(int tempId, MessageStatus newStatus) {
    if (state is GetMessagesSuccess) {
      final currentMessages = (state as GetMessagesSuccess).messages;
      final messageIndex = currentMessages.indexWhere(
            (msg) => msg.id == tempId,
      );

      if (messageIndex != -1 && newStatus == MessageStatus.failed) {
        final updatedMessage = currentMessages[messageIndex].copyWith(
          status: newStatus,
        );
        final newMessages = List<Message>.from(currentMessages);
        newMessages[messageIndex] = updatedMessage;
        emit(GetMessagesSuccess(newMessages));
      }
    }
  }
}
