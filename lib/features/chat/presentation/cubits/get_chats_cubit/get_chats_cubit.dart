import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/core/utils/functions/crypto_helper.dart';
import 'package:shifaa/features/chat/data/models/chat_summary.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

part 'get_chats_state.dart';

class GetChatsCubit extends Cubit<GetChatsState> {
  final ChatRepository _chatRepository;

  GetChatsCubit(this._chatRepository) : super(GetChatsInitial());

  Future<void> fetchChats() async {
    emit(GetChatsLoading());

    final result = await _chatRepository.getChats();

    result.fold(
          (failure) {
        emit(GetChatsFailure(failure.message));
      },
          (chats) async {
        final List<ChatSummary> decryptedChats = [];

        for (final chat in chats) {
          if (chat.lastMessage != null && chat.lastMessage is MessageModel) {
            final messageToDecrypt = chat.lastMessage as MessageModel;
            final aesKey = await getAesKey(messageToDecrypt);

            if (aesKey.isNotEmpty) {
              final decryptedMessage = await decryptText(
                messageToDecrypt,
                aesKey,
              );

              final decryptedChat = chat.copyWith(
                lastMessage: decryptedMessage,
              );

              decryptedChats.add(decryptedChat);
            } else {
              decryptedChats.add(chat);
            }
          } else {
            decryptedChats.add(chat);
          }
        }

        emit(GetChatsSuccess(decryptedChats));
      },
    );
  }
}
