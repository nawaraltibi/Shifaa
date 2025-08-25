// lib/features/chat/presentation/views/chat_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
// ✅ 1. قم باستيراد الـ Repository
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_messages_cubit/get_messages_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/chat_view_body.dart';

class ChatView extends StatelessWidget {
  final int chatId;

  const ChatView({super.key, required this.chatId});
  static const routeName = '/chat-view';

  @override
  Widget build(BuildContext context) {
    // ✅ 2. قم بلف الـ BlocProvider بـ RepositoryProvider
    return RepositoryProvider(
      // 3. استخدم getIt لإنشاء نسخة من ChatRepository
      create: (context) => getIt<ChatRepository>(),
      child: BlocProvider(
        // 4. الآن الـ Cubit يمكنه الوصول للـ Repository إذا احتاجه
        create: (context) => getIt<GetMessagesCubit>()..fetchMessages(chatId),
        // 5. والـ ChatViewBody يمكنه أيضاً الوصول للـ Repository
        child: Scaffold(body: ChatViewBody(chatId: chatId)),
      ),
    );
  }
}
