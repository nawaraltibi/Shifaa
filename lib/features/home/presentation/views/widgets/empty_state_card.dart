import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class EmptyStateCard extends StatelessWidget {
  final String message;
  final double height;

  const EmptyStateCard({
    super.key,
    required this.message,
    this.height = 230, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
