import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
  });
  final String doctorName, specialty, imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // صورة الطبيب
            CircleAvatar(
              radius: 32.r,
              backgroundColor: AppColors.primaryAppColor,
              child: ClipOval(child: Image.asset(AppImages.imagesDoctor1)),
            ),
            SizedBox(width: 16.w),
            // الاسم والتخصص
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. George Doe', // بيانات وهمية
                  style: AppTextStyles.semiBold16,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Neurologist', // بيانات وهمية
                  style: AppTextStyles.regular13.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(), // يأخذ كل المساحة المتبقية
            // أيقونة الشات
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryAppColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primaryAppColor,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        const Divider(color: Color(0xFFF0F0F0), thickness: 1.5),
      ],
    );
  }
}
