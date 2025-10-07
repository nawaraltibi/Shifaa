import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_chats_cubit/get_chats_cubit.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
import 'package:shifaa/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:shifaa/features/chat/presentation/widgets/chats_custom_app_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsListViewBody extends StatefulWidget {
  const ChatsListViewBody({super.key});

  @override
  State<ChatsListViewBody> createState() => _ChatsListViewBodyState();
}

class _ChatsListViewBodyState extends State<ChatsListViewBody> {
  @override
  void initState() {
    super.initState();
    try {
      context.read<GetChatsCubit>().fetchChats();
    } catch (e) {
      print("Error fetching chats on init: $e");
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
          Expanded(
            child: BlocBuilder<GetChatsCubit, GetChatsState>(
              builder: (context, state) {
                if (state is GetChatsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetChatsFailure) {
                  return Center(
                    child: Text('An error occurred: ${state.errorMessage}'),
                  );
                }
                if (state is GetChatsSuccess) {
                  if (state.chats.isEmpty) {
                    return const Center(child: Text('You have no chats yet.'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return ChatListItem(
                        imageUrl: chat.doctor.avatar ?? AppImages.imagesDoctor1,
                        name: chat.doctor.fullName,
                        lastMessage: chat.lastMessage?.text ?? 'No messages',
                        time: chat.lastMessage != null
                            ? timeago.format(chat.lastMessage!.createdAt)
                            : '',
                        unreadCount: chat.unreadCount,
                        onTap: () {
                          final chatArgs = {
                            'chatId': chat.id,
                            'doctorName': chat.doctor.fullName,
                            'doctorImage': chat.doctor.avatar,
                          };
                          context.pushNamed(
                            ChatView.routeName,
                            extra: chatArgs,
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Welcome! Loading chats...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
