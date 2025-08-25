// lib/features/chat/presentation/views/chats_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ✅ 1. استيراد الـ Cubit الجديد و get_it
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/chat/presentation/cubits/cubit/get_chats_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/chats_list_view_body.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({super.key});
  static const routeName = '/chats-view';

  @override
  Widget build(BuildContext context) {
    // ✅ 2. قم بلف الـ Scaffold بـ BlocProvider
    return BlocProvider(
      // 3. استخدم getIt لإنشاء نسخة جديدة من GetChatsCubit
      create: (context) => getIt<GetChatsCubit>(),
      child: const Scaffold(body: ChatsListViewBody()),
    );
  }
}
