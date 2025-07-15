import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/custom_icon_button.dart';

class CustomDoctorDetailsAppBar extends StatelessWidget {
  const CustomDoctorDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
            size: 18.sp,
          ),
          onTap: () => Navigator.pop(context),
        ),
        CustomIconButton(
          icon: Image.asset(Assets.imagesChatIcon, height: 20.h, width: 20.w),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
