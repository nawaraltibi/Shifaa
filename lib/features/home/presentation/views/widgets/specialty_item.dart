import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class SpecialtyItem extends StatelessWidget {
  const SpecialtyItem({super.key, required this.icon, required this.name});

  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryAppColor, size: 32),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            name,
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
