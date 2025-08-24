import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/notifications/presentation/view/screens/notifications_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Khaled',
              style: AppTextStyles.semiBold22.copyWith(color: AppColors.primaryTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              'How are you doing today?',
              style: AppTextStyles.regular14.copyWith(color: AppColors.secondaryTextColor),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => context.goNamed('/notifications'),
              icon: const Icon(Icons.notifications_none_outlined, size: 28),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.grid_view_outlined, size: 28),
            ),
          ],
        ),
      ],
    );
  }
} 