// lib/features/chat/presentation/views/chat_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
// ✅ 1. قم باستيراد الـ Repository
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_messages_cubit/get_messages_cubit.dart';
import 'package:shifaa/features/chat/presentation/cubits/mute_chat_cubit/chat_mute_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/chat_view_body.dart';

// في ملف: lib/features/chat/presentation/views/chat_view.dart

class ChatView extends StatelessWidget {
  final int chatId;
  final String doctorName;
  final String? doctorImage;

  const ChatView({
    super.key,
    required this.chatId,
    required this.doctorName,
    this.doctorImage,
  });

  static const routeName = '/chat-view';

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => getIt<ChatRepository>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<GetMessagesCubit>()..fetchMessages(chatId),
          ),
          BlocProvider(
            create: (context) =>
                ChatMuteCubit(context.read<ChatRepository>())
                  ..loadInitialMuteStatus(chatId),
          ),
        ],
        child: Scaffold(
          body: ChatViewBody(
            chatId: chatId,
            doctorName: doctorName,
            doctorImage: doctorImage,
          ),
        ),
      ),
    );
  }
}
