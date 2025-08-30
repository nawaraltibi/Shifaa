import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class SpecialtyItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback? onTap; // Corrected: Added onTap callback

  const SpecialtyItem({
    super.key,
    required this.imageUrl,
    required this.name,
    this.onTap, // Corrected: Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Corrected: Wrapped with GestureDetector to make it tappable
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                    child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
                errorWidget: (context, url, error) => const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primaryAppColor,
                  size: 32,
                ),
              ),
            ),
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
      ),
    );
  }
}

