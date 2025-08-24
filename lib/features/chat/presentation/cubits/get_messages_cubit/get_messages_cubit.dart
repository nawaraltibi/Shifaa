import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/crypto_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/data/models/message_status.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

part 'get_messages_state.dart';

class GetMessagesCubit extends Cubit<GetMessagesState> {
  final ChatRepository repository;

  GetMessagesCubit(this.repository) : super(GetMessagesInitial());
  // في ملف: get_messages_cubit.dart
  // داخل كلاس: GetMessagesCubit

  // ✅✅✅ --- النسخة الجديدة والمحسّنة من الدالة --- ✅✅✅
  void replaceTempMessageWithSentMessage(int tempId, Message sentMessage) {
    if (state is! GetMessagesSuccess) return;

    final currentState = state as GetMessagesSuccess;
    final currentMessages = currentState.messages;

    // 1. ابحث عن الرسالة المؤقتة
    final messageIndex = currentMessages.indexWhere((msg) => msg.id == tempId);

    // 2. إذا لم تجدها، لا تفعل شيئاً (ربما تم تحديثها بالفعل)
    if (messageIndex == -1) {
      print(
        "⚠️ Temp message with id $tempId not found. Maybe already updated by Pusher.",
      );
      return;
    }

    // 3. أنشئ قائمة جديدة تماماً من الرسائل الحالية
    final List<Message> newMessages = List.from(currentMessages);

    // 4. استبدل الرسالة المؤقتة بالرسالة النهائية من السيرفر
    //    مع التأكد من أن حالتها هي 'sent' وأن النص الأصلي (غير المشفر) موجود
    newMessages[messageIndex] = sentMessage.copyWith(
      status: MessageStatus.sent,
      // احتفظ بالنص الأصلي والمسار المحلي من الرسالة المؤقتة
      text: currentMessages[messageIndex].text,
      localFilePath: currentMessages[messageIndex].localFilePath,
      senderRole: currentMessages[messageIndex].senderRole,
    );

    print(
      "✅ Replacing temp message $tempId with final message ${sentMessage.id}. Emitting new state.",
    );

    // 5. أصدر حالة جديدة مع القائمة الجديدة
    //    هذا سيجبر الواجهة على إعادة البناء
    emit(GetMessagesSuccess(newMessages));
  }

  // --- دالة جلب الرسائل الأولية ---
  Future<void> fetchMessages(int chatId) async {
    emit(GetMessagesLoading());
    final result = await repository.getChatDetails(chatId);

    result.fold((failure) => emit(GetMessagesFailure(failure.message)), (
      chat,
    ) async {
      // ✅✅✅ --- الإصلاح الحاسم هنا --- ✅✅✅
      // سنحاول فك تشفير كل الرسائل القادمة من الخادم
      final List<Message> processedMessages = [];
      for (final message in chat.messages) {
        if (message is MessageModel) {
          // دائماً حاول فك التشفير. decryptForMe ستعيد الرسالة كما هي إذا فشلت.
          final aesKey = await getAesKey(message);
          final decryptedMessage = await decryptText(message, aesKey);
          processedMessages.add(decryptedMessage);
        } else {
          // هذا لن يحدث في هذه الدالة، ولكنه جيد كاحتياط
          processedMessages.add(message);
        }
      }
      emit(GetMessagesSuccess(processedMessages));
    });
  }

  // --- دالة إضافة الرسائل الجديدة (من Pusher أو المؤقتة) ---
  Future<void> addMessage(Message message) async {
    if (state is! GetMessagesSuccess) return;

    // تجاهل رسائلك أنت القادمة من Pusher لأنها معروضة مسبقاً كرسالة مؤقتة
    if (message.senderRole == 'patient' && message.id > 0) {
      print("✅ Ignoring own message from Pusher (ID: ${message.id})");
      return;
    }

    final currentMessages = (state as GetMessagesSuccess).messages;
    if (currentMessages.any((msg) => msg.id == message.id && msg.id > 0)) {
      print("✅ Ignoring duplicate message from Pusher (ID: ${message.id})");
      return; // تجنب إضافة نفس الرسالة مرتين
    }

    Message finalMessage = message;
    // ✅✅✅ --- الإصلاح هنا أيضاً --- ✅✅✅
    // إذا كانت الرسالة من Pusher ومن الطرف الآخر، فك تشفيرها
    if (message.senderRole != 'patient' && message is MessageModel) {
      final aesKey = await getAesKey(message);
      finalMessage = await decryptText(message, aesKey);
    }

    final newMessages = [...currentMessages, finalMessage];
    emit(GetMessagesSuccess(newMessages));
  }

  // --- دالة تحديث حالة الرسالة (تبقى كما هي) ---
  void updateMessageStatus(int tempId, MessageStatus newStatus) {
    if (state is GetMessagesSuccess) {
      final currentMessages = (state as GetMessagesSuccess).messages;
      final messageIndex = currentMessages.indexWhere(
        (msg) => msg.id == tempId,
      );

      if (messageIndex != -1) {
        if (newStatus == MessageStatus.failed) {
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
}
