import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class SessionPriceText extends StatelessWidget {
  const SessionPriceText({super.key, required this.price});
  final int price;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '\$$price',
            style: AppTextStyles.regular25.copyWith(
              color: const Color(0xFF5C85D9),
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: '/session',
            style: AppTextStyles.regular13.copyWith(
              color: const Color(0xFF8F8F8F),
            ),
          ),
        ],
      ),
    );
  }
}
