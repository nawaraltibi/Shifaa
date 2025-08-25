import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class ChatsCustomAppBar extends StatelessWidget {
  const ChatsCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(size: 30.sp, Icons.arrow_back, color: const Color(0xFFCECECE)),
        SizedBox(width: 104.w),
        Text('Chats', style: AppTextStyles.semiBold22),
      ],
    );
  }
}
