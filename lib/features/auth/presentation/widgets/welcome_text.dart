import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30.w),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to ',
            style: AppTextStyles.medium24.copyWith(color: Colors.white),
          ),
          Text(
            'Shifaa!',
            style: AppTextStyles.medium34.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
