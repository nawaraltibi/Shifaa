import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';

class AuthWhiteContainer extends StatelessWidget {
  const AuthWhiteContainer({
    super.key,
    required this.child,
    required this.margin,
  });
  final Widget child;
  final double margin;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: margin.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r),
                topRight: Radius.circular(35.r),
              ),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: child,
              ),
            ),
          ),
          Positioned(
            right: 35.w,
            top: margin - 37.h,
            child: Image.asset(Assets.imagesDoctorElement),
          ),
        ],
      ),
    );
  }
}
