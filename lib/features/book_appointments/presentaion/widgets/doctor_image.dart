import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_images.dart';

class DoctorImage extends StatelessWidget {
  const DoctorImage({super.key, required this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Transform.flip(
        flipX: true,
        child: Image.asset(
          AppImages.imagesDoctor1,
          height: 200.h,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Transform.flip(
        flipX: true,
        child: Image.network(
          image!,
          height: 210.h,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primaryAppColor,
                  ),
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AppImages.imagesDoctor1,
              height: 200.h,
              fit: BoxFit.contain,
            );
          },
        ),
      );
    }
  }
}
