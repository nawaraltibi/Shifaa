import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/treatmeant_plan/models/appointment_models.dart';

class AppointmentsSection extends StatelessWidget {
  final List<AppointmentInfo> appointments;

  const AppointmentsSection({Key? key, required this.appointments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < appointments.length; i++)
          _buildAppointmentItem(
            context,
            appointments[i],
            i == appointments.length - 1, // التحقق إذا كان العنصر الأخير
          ),
      ],
    );
  }

  Widget _buildAppointmentItem(
    BuildContext context,
    AppointmentInfo appointment,
    bool isLast,
  ) {
    // الهامش السفلي الذي يسبب المشكلة
    final double bottomMargin = !isLast ? 40.h : 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- عمود الخط الزمني ---
          SizedBox(
            width: 50.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // الخط العمودي
                // **** التعديل النهائي هنا ****
                // استبدلنا Positioned.fill بـ Positioned عادي
                // وحددنا نقطة النهاية (bottom) لتكون بقيمة الهامش
                Positioned(
                  top: 50.h, // نقطة البداية (تحت التاريخ)
                  bottom: bottomMargin, // نقطة النهاية (قبل الهامش السفلي)
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center, // محاذاة في المنتصف
                    child: Container(width: 2.w, color: AppColors.purple),
                  ),
                ),
                // مربع التاريخ
                _buildTimelineDot(context, appointment.date),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // --- عمود المحتوى ---
          Expanded(
            child: Container(
              // نستخدم نفس قيمة الهامش هنا
              margin: EdgeInsets.only(bottom: isLast ? 0 : bottomMargin),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.purple.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time:',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        appointment.time,
                        style: AppTextStyles.medium12.copyWith(
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Type:',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        appointment.type,
                        style: AppTextStyles.medium12.copyWith(
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Doctor's Notes:",
                    style: AppTextStyles.medium12.copyWith(
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    appointment.doctorNotes,
                    style: AppTextStyles.regular10.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot(BuildContext context, DateTime date) {
    return Container(
      width: 45.w,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.purple, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: AppTextStyles.regular10.copyWith(color: AppColors.purple),
          ),
          Text(
            DateFormat('dd').format(date),
            style: AppTextStyles.semiBold18.copyWith(color: AppColors.purple),
          ),
        ],
      ),
    );
  }
}
