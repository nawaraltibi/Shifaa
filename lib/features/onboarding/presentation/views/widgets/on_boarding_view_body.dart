import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/onboarding/presentation/views/widgets/on_boarding_page_view_item.dart';
import 'package:shifaa/features/onboarding/presentation/views/widgets/page_view_animated_button.dart';
import 'package:shifaa/generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingData> onboardingPages = [
    OnBoardingData(
      image: Assets.imagesOnboardingScreen1,
      title: (context) => S.of(context).onBoardingTitle1,
      subtitle: (context) => S.of(context).onBoardingSubtitle1,
    ),
    OnBoardingData(
      image: Assets.imagesOnboardingScreen2,
      title: (context) => S.of(context).onBoardingTitle2,
      subtitle: (context) => S.of(context).onBoardingSubtitle2,
    ),
    OnBoardingData(
      image: Assets.imagesOnboardingScreen3,
      title: (context) => S.of(context).onBoardingTitle3,
      subtitle: (context) => S.of(context).onBoardingSubtitle3,
    ),
  ];

  void _nextPage(BuildContext context) {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(LoginView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPageView(),
        const SizedBox(height: 16),
        PageViewAnimatedButton(
          currentPage: _currentPage,
          totalPages: onboardingPages.length,
          onPressed: () => _nextPage(context),
        ),
        SizedBox(height: 70.h),
      ],
    );
  }

  Expanded buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: onboardingPages.length,
        itemBuilder: (context, index) {
          return OnBoardingPageViewItem(data: onboardingPages[index]);
        },
      ),
    );
  }
}
