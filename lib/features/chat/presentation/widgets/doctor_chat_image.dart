import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DoctorChatImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const DoctorChatImage({
    super.key,
    this.imageUrl,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Color(0xFFf1f4ff),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.grey,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            AppImages.imagesDoctor1,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
