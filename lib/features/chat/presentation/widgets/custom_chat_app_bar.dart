import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/chat/presentation/cubits/mute_chat_cubit/chat_mute_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/doctor_chat_image.dart';

class CustomChatAppBar extends StatelessWidget {
  final int chatId;
  final String doctorName;
  final String? doctorImage;

  const CustomChatAppBar({
    super.key,
    required this.chatId,
    required this.doctorName,
    this.doctorImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30.h,
        left: 20.w,
        right: 20.w,
        bottom: 10.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.w),
          ),
          SizedBox(width: 20.w),
          DoctorChatImage(imageUrl: doctorImage, width: 40, height: 40),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              doctorName,
              style: AppTextStyles.bold12.copyWith(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BlocConsumer<ChatMuteCubit, ChatMuteState>(
            listenWhen: (previous, current) {
              return previous is ChatMuteLoading && current is ChatMuteSuccess;
            },
            listener: (context, state) {
              if (state is ChatMuteSuccess) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                final snackBar = SnackBar(
                  content: Text(
                    state.isMuted ? 'Chat Muted' : 'Chat Unmuted',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: state.isMuted
                      ? Colors.redAccent
                      : Colors.green,
                  duration: const Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              bool isLoading = state is ChatMuteLoading;
              bool isMuted = false;

              if (state is ChatMuteSuccess) {
                isMuted = state.isMuted;
              } else if (context.read<ChatMuteCubit>().state
              is ChatMuteSuccess) {
                isMuted =
                    (context.read<ChatMuteCubit>().state as ChatMuteSuccess)
                        .isMuted;
              }

              if (isLoading) {
                return SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(strokeWidth: 2.0),
                );
              }

              return GestureDetector(
                onTap: () {
                  if (!isLoading) {
                    context.read<ChatMuteCubit>().toggleMute(chatId);
                  }
                },
                child: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_up,
                  color: isMuted ? Colors.red : Colors.black,
                  size: 24.w,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
