import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class OnBoardingData {
  final String image;
  final String Function(BuildContext context) title;
  final String Function(BuildContext context) subtitle;

  OnBoardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class OnBoardingPageViewItem extends StatelessWidget {
  final OnBoardingData data;

  const OnBoardingPageViewItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset(data.image)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              data.title(context),
              style: AppTextStyles.semiBold22,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              data.subtitle(context),
              style: AppTextStyles.regular18.copyWith(
                color: const Color(0xFFA2A2A2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }
}
