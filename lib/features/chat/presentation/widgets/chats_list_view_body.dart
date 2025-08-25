// lib/features/chat/presentation/widgets/chats_view_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/features/chat/presentation/cubits/cubit/get_chats_cubit.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
// استيراد الـ Cubit والحالات
import 'package:shifaa/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:shifaa/features/chat/presentation/widgets/chats_custom_app_bar.dart';
// سنحتاج هذه المكتبة لعرض الوقت بشكل جميل
import 'package:timeago/timeago.dart' as timeago;

// 1. حول الـ Widget إلى StatefulWidget
class ChatsListViewBody extends StatefulWidget {
  const ChatsListViewBody({super.key});

  @override
  State<ChatsListViewBody> createState() => _ChatsListViewBodyState();
}

class _ChatsListViewBodyState extends State<ChatsListViewBody> {
  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when the widget is inserted into the tree.
  ///
  /// Fetches the chats from the server on the first build of the widget.
  /// Uses a try-catch block to avoid errors if the `GetChatsCubit` is not registered.
  /// *****  75d0db47-da68-41e8-a528-813490ac4375  ******
  void initState() {
    super.initState();
    // 2. اطلب جلب المحادثات فور بناء الواجهة لأول مرة
    // استخدمنا try-catch لتجنب الأخطاء إذا كان الـ Cubit غير مسجل
    try {
      context.read<GetChatsCubit>().fetchChats();
    } catch (e) {
      print("Error fetching chats on init: $e");
      // يمكنك عرض رسالة خطأ هنا إذا أردت
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 40.h),
      child: Column(
        children: [
          const ChatsCustomAppBar(),
          SizedBox(height: 30.h),
          const Divider(color: Color(0xFFE3E9F1), thickness: 2),

          // 3. استخدم Expanded و BlocBuilder لمراقبة الحالات
          Expanded(
            child: BlocBuilder<GetChatsCubit, GetChatsState>(
              builder: (context, state) {
                // --- حالة التحميل ---
                if (state is GetChatsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // --- حالة الفشل ---
                if (state is GetChatsFailure) {
                  return Center(
                    child: Text('An error occurred: ${state.errorMessage}'),
                  );
                }
                // --- حالة النجاح ---
                if (state is GetChatsSuccess) {
                  // إذا لم تكن هناك محادثات
                  if (state.chats.isEmpty) {
                    return const Center(child: Text('You have no chats yet.'));
                  }
                  // إذا كانت هناك محادثات، اعرضها في ListView
                  return ListView.builder(
                    padding: EdgeInsets.zero, // لإزالة أي padding افتراضي
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return ChatListItem(
                        // 4. استخدم البيانات الحقيقية من الموديل
                        imageUrl: chat.doctor.avatar,
                        name: chat.doctor.fullName,
                        lastMessage: chat.lastMessage?.text ?? 'No messages',
                        // استخدم مكتبة timeago لعرض الوقت بشكل "منذ 5 دقائق"
                        time: chat.lastMessage != null
                            ? timeago.format(chat.lastMessage!.createdAt)
                            : '',
                        // حالياً هذا الحقل ثابت، سيتم تحديثه لاحقاً من الـ API
                        unreadCount: chat.unreadCount,
                        onTap: () {
                          // TODO: هنا تضع الكود للانتقال إلى شاشة المحادثة
                          // Navigator.pushNamed(context, ChatDetailsScreen.routeName, arguments: chat.id);
                          print('Tapped on chat with ID: ${chat.id}');
                          context.goNamed(ChatView.routeName, extra: chat.id);
                        },
                      );
                    },
                  );
                }
                // --- الحالة الأولية (قبل بدء التحميل) ---
                return const Center(child: Text('Welcome! Loading chats...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
