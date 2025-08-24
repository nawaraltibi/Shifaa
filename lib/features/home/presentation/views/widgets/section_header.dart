import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
    this.count,
  });

  final String title;
  final int? count;
  final void Function()? onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTextStyles.semiBold18
                  .copyWith(color: AppColors.primaryTextColor),
            ),
            if (count != null)
              Text(
                ' ($count)',
                style: AppTextStyles.semiBold18
                    .copyWith(color: AppColors.secondaryTextColor),
              ),
          ],
        ),
        if (onSeeAllTap != null)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              'See All',
              style: AppTextStyles.regular12
                  .copyWith(color: AppColors.secondaryTextColor),
            ),
          ),
      ],
    );
  }
} 