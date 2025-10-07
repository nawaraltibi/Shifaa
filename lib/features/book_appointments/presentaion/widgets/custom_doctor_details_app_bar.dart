import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/custom_icon_button.dart';
import 'package:shifaa/features/chat/presentation/cubits/create_chat_cubit/create_chat_cubit.dart';
import 'package:shifaa/features/chat/presentation/cubits/create_chat_cubit/create_chat_state.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';

class CustomDoctorDetailsAppBar extends StatelessWidget {
  const CustomDoctorDetailsAppBar({super.key, required this.doctorId});
  final int doctorId;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
              size: 18.sp,
            ),
            onTap: () => Navigator.pop(context),
          ),
          CustomIconButton(
            icon: Image.asset(
              AppImages.imagesChatIcon,
              height: 20.h,
              width: 20.w,
            ),
            onTap: () async {
              final cubit = context.read<CreateChatCubit>();

              cubit.startChat(doctorId);

              final state = await cubit.stream.firstWhere(
                (state) =>
                    state is CreateChatSuccess || state is CreateChatFailure,
              );

              if (state is CreateChatSuccess) {
                context.pushNamed(
                  ChatView.routeName,
                  extra: {
                    'chatId': doctorId,
                  },
                );
              } else if (state is CreateChatFailure) {
                if (state.error == "chat.unauthorized") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "يجب أن تكون حاجز موعد مع هذا الطبيب لتبدأ المحادثة.",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "حدث خطأ أثناء بدء المحادثة: ${state.error}",
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
