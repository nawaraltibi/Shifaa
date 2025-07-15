import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_white_container.dart';
import 'package:shifaa/features/auth/presentation/widgets/welcome_text.dart';

class AuthTemplate extends StatelessWidget {
  const AuthTemplate({
    super.key,
    required this.child,
    this.isWelcomeVisible = false,
    required this.containerHeight,
  });

  static const routeName = '/test';

  final double containerHeight;
  final Widget child;
  final bool isWelcomeVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryAppColor,
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(Assets.imagesNotebook),
          ),
          const Spacer(),

          if (isWelcomeVisible) const WelcomeText(),

          const SizedBox(height: 20),

          CustomWhiteContainer(
            height: containerHeight,
            child: Material(
              // ✅ هذا هو المهم
              color: Colors.transparent,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
