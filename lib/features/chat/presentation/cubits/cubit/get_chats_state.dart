// file: lib/features/chat/presentation/cubits/get_chats_cubit/get_chats_state.dart

// هذا السطر يربط هذا الملف بملف الـ Cubit
part of 'get_chats_cubit.dart';

// يجعل الكلاسات غير قابلة للتغيير، وهي ممارسة جيدة

abstract class GetChatsState {}

// 1. الحالة الأولية: عندما تفتح الشاشة لأول مرة
class GetChatsInitial extends GetChatsState {}

// 2. حالة التحميل: عندما نكون في انتظار رد الـ API
class GetChatsLoading extends GetChatsState {}

// 3. حالة النجاح: عندما تصل البيانات بنجاح
class GetChatsSuccess extends GetChatsState {
  final List<ChatSummary> chats; // ستحمل قائمة المحادثات
  GetChatsSuccess(this.chats);
}

// 4. حالة الفشل: عندما يحدث خطأ ما
class GetChatsFailure extends GetChatsState {
  final String errorMessage; // ستحمل رسالة الخطأ
  GetChatsFailure(this.errorMessage);
}
