// file: lib/features/chat/presentation/cubits/get_chats_cubit/get_chats_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
// استيراد الموديل والـ Repository
import 'package:shifaa/features/chat/data/models/chat_summary.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';

// هذا السطر يربط هذا الملف بملف الـ State
part 'get_chats_state.dart';

class GetChatsCubit extends Cubit<GetChatsState> {
  // نحتاج إلى نسخة من الـ Repository لنتمكن من استدعاء دواله
  final ChatRepository _chatRepository;

  // الـ Constructor يطلب الـ Repository ويبدأ بالحالة الأولية
  GetChatsCubit(this._chatRepository) : super(GetChatsInitial());

  // هذه هي الدالة التي سنستدعيها من واجهة المستخدم
  Future<void> fetchChats() async {
    // 1. أخبر الواجهة أننا بدأنا التحميل
    emit(GetChatsLoading());

    // 2. استدعِ الدالة من الـ Repository وانتظر النتيجة
    final result = await _chatRepository.getChats();

    // 3. تعامل مع النتيجة (إما نجاح أو فشل)
    result.fold(
      // في حالة الفشل (Left)
      (failure) {
        // أخبر الواجهة بحدوث خطأ وأرسل لها رسالة الخطأ
        emit(GetChatsFailure(failure.message));
      },
      // في حالة النجاح (Right)
      (chats) {
        // أخبر الواجهة بنجاح العملية وأرسل لها قائمة المحادثات
        emit(GetChatsSuccess(chats));
      },
    );
  }
}
