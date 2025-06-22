import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_white_container.dart';
import 'package:shifaa/features/auth/presentation/widgets/welcome_text.dart';

class AuthTemplate extends StatelessWidget {
  const AuthTemplate({
    super.key,
    required this.child,
    this.isWelcomeVisible = false,
    required this.margin,
  });
  final Widget child;
  final bool isWelcomeVisible;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: AppColors.primaryAppColor)),
        Positioned(left: 0, top: 0, child: Image.asset(Assets.imagesNotebook)),
        AuthWhiteContainer(margin: margin, child: child),
        WelcomeText(isVisible: isWelcomeVisible),
      ],
    );
  }
}
