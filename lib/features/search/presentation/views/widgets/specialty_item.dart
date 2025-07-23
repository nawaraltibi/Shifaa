import 'package:flutter/material.dart'; 


class SpecialtyItem extends StatelessWidget {
  const SpecialtyItem({
    super.key,
    required this.icon,
    required this.name,
  });

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
            color: Colors.blue.shade50, 
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade600,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          // style: AppTextStyles.regular12.copyWith(color: AppColors.secondaryTextColor),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
