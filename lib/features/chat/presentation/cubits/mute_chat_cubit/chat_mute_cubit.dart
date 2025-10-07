import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

part 'chat_mute_state.dart';

class ChatMuteCubit extends Cubit<ChatMuteState> {
  final ChatRepository _chatRepository;

  ChatMuteCubit(this._chatRepository) : super(ChatMuteInitial());

  Future<void> loadInitialMuteStatus(int chatId) async {
    final result = await _chatRepository.getChatDetails(chatId);
    result.fold(
          (_) => emit(ChatMuteSuccess(false)),
          (chat) => emit(ChatMuteSuccess(chat.muted)),
    );
  }

  Future<void> toggleMute(int chatId) async {
    emit(ChatMuteLoading());
    final result = await _chatRepository.muteChat(chatId);
    result.fold(
          (failure) => emit(ChatMuteFailure(failure.message)),
          (chat) => emit(ChatMuteSuccess(chat.muted)),
    );
  }
}
