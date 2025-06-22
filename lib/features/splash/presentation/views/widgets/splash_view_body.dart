import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Image.asset(Assets.imagesLogo)),
        const SizedBox(height: 63),
        Text(
          'Shifaa Clinic',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 32.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
