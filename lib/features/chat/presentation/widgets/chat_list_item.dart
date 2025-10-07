import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/utils/app_images.dart';

class ChatListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  }) : super(key: key);

  Widget _buildProfileImage() {
    final bool isNetworkImage =
        imageUrl.isNotEmpty && imageUrl.startsWith('http');

    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: 56,
        width: 56,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.imagesDoctor1,
          fit: BoxFit.cover,
          height: 56,
          width: 56,
        ),
      );
    } else {
      return Image.asset(
        AppImages.imagesDoctor1,
        fit: BoxFit.cover,
        height: 56,
        width: 56,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(child: _buildProfileImage()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.semiBold16),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(time, style: AppTextStyles.regular10),
                    const SizedBox(height: 8),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryAppColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: AppTextStyles.regular10.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFF6F8FB), thickness: 2),
        ],
      ),
    );
  }
}
