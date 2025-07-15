import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_image.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/session_price_text.dart';

class DoctorImportantInfo extends StatelessWidget {
  const DoctorImportantInfo({
    super.key,
    required this.specialization,
    required this.name,
    required this.image,
    required this.sessionPrice,
  });
  final String specialization;
  final String name;
  final String image;
  final int sessionPrice;
  @override
/*************  ✨ Windsurf Command ⭐  *************/
/*******  0cc0d9b2-83ba-4946-bbed-e48428e8c784  *******/
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specialization,
                style: AppTextStyles.regular13.copyWith(
                  color: AppColors.primaryAppColor,
                ),
              ),
              SizedBox(
                width: 145.w,
                child: Text(name, style: AppTextStyles.semiBold25),
              ),
              SizedBox(height: 50.h),
              SessionPriceText(price: sessionPrice),
            ],
          ),
        ),
        DoctorImage(image: image),
      ],
    );
  }
}
