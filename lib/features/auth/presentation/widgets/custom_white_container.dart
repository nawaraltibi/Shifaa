import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';

class CustomWhiteContainer extends StatelessWidget {
  const CustomWhiteContainer({
    super.key,
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;
  @override
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(
      context,
    ).viewInsets.bottom;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White container
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.r),
              topRight: Radius.circular(35.r),
            ),
          ),
          padding: EdgeInsets.only(
            left: 30.w,
            right: 30.w,
            bottom: bottomInset,
          ),
          child: Container(
            margin: EdgeInsets.only(top: 30.h),
            padding: EdgeInsets.only(top: 60.h),
            child: child,
          ),
        ),

        Positioned(
          top: -90.h,
          right: 35.w,
          child: Image.asset(
            AppImages.imagesDoctorElement,
            width: 0.3.sw,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
