import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';

// ✅✅✅ --- تم تعديل توقيع الدالة لتقبل دالة جديدة --- ✅✅✅
Widget buildMessageComposer({
  required TextEditingController messageController,
  required VoidCallback onSendPressed,
  required VoidCallback onAttachmentPressed,
}) {
  // ... الكود هنا لا يتغير
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              filled: true,
              fillColor: const Color(0xFFF0F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  icon: Icon(Icons.attachment, color: Colors.grey, size: 24.w),
                  onPressed: onAttachmentPressed,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        FloatingActionButton(
          elevation: 2,
          onPressed: onSendPressed,
          backgroundColor: AppColors.primaryAppColor,
          shape: const CircleBorder(),
          child: Icon(Icons.send, color: Colors.white, size: 24.w),
        ),
      ],
    ),
  );
}
