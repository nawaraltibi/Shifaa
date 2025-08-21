import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/chat/presentation/widgets/doctor_chat_image.dart';

class CustomChatAppBar extends StatelessWidget {
  const CustomChatAppBar({super.key});

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
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.w),
          ),
          SizedBox(width: 20.w),
          const DoctorChatImage(),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Dr. George Doe',
              style: AppTextStyles.bold12.copyWith(fontSize: 16.sp),
            ),
          ),
          Icon(Icons.more_horiz, color: Colors.black, size: 24.w),
        ],
      ),
    );
  }
}
