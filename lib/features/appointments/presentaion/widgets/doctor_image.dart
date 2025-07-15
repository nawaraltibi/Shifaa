import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorImage extends StatelessWidget {
  const DoctorImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: true,
      child: Image.asset(image, height: 200.h, fit: BoxFit.contain),
    );
  }
}
