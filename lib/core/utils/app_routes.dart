// في ملف: lib/core/routing/app_router.dart (أو ما يماثله)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/layout/main_layout_screen.dart';
import 'package:shifaa/features/appointments/presentation/views/appointment_view.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/views/profile_setup_view.dart';
import 'package:shifaa/features/auth/presentation/views/verify_otp_view.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/re_sched_appointment_view.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
import 'package:shifaa/features/chat/presentation/views/chats_list_view.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
import 'package:shifaa/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:shifaa/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:shifaa/features/search/presentation/views/search_screen.dart';
import 'package:shifaa/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  // مفتاح Navigator رئيسي للتطبيق كله
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'Root',
  );

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/', // ابدأ من شاشة البداية

    routes: [
      // --- المجموعة الأولى: مسارات بملء الشاشة (لا تحتوي على BottomNav) ---

      // مسارات أولية (Splash, Onboarding, Auth)
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: OnBoardingView.routeName,
        name: OnBoardingView.routeName,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: PasswordView.routeName,
        name: PasswordView.routeName,
        
        builder: (context, state) {
                    final phone = state.queryParams['phone'] ?? '';
                    final otp = state.queryParams['otp'] ?? '';
                    return PasswordView(phoneNumber: phone, otp: otp);

        },
      ),
      GoRoute(
        path: LoginView.routeName,
        name: LoginView.routeName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: ReSchedAppointmentView.routeName,
        name: ReSchedAppointmentView.routeName,
        builder: (context, state) => const ReSchedAppointmentView(),
      ),
      GoRoute(
        path: '/verify-otp-view',
        name: VerifyOtpView.routeName,
        builder: (context, state) {
          final phone = state.queryParams['phone'] ?? '';
          return VerifyOtpView(phoneNumber: phone);
        },
      ),
      // ... (أكمل باقي مسارات المصادقة هنا بنفس الطريقة)

      // مسارات داخلية تظهر بملء الشاشة
      GoRoute(
        path: DoctorDetailsView.routeName, // مثال: '/doctor-details'
        name: DoctorDetailsView.routeName,
        // ⭐️ استخدم parentNavigatorKey ليظهر فوق الـ Shell
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // تأكد من تمرير الـ ID بشكل صحيح
          final doctorId = state.extra as int? ?? 0;
          return DoctorDetailsView(doctorId: doctorId);
        },
      ),

      // في ملف إعدادات GoRouter
      GoRoute(
        path: ChatView.routeName, // مثال: '/chat-view'
        name: ChatView.routeName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // ✅ --- التعديل هنا: استقبل الـ Map --- ✅
          // 1. تحقق من أن extra هو من نوع Map
          final args = state.extra as Map<String, dynamic>?;

          // 2. استخرج البيانات مع قيم افتراضية آمنة
          final chatId = args?['chatId'] as int? ?? 0;
          final doctorName = args?['doctorName'] as String? ?? 'Doctor';
          final doctorImage =
              args?['doctorImage'] as String?; // يمكن أن يكون null
          final isMuted = args?['isMuted'] as bool? ?? false;

          // 3. مرر البيانات إلى ChatView
          return ChatView(
            chatId: chatId,
            doctorName: doctorName,
            doctorImage: doctorImage,
          );
        },
      ),

      GoRoute(
        path: '/notifications',
        name: NotificationsScreen.routeName,
        // ⭐️ استخدم parentNavigatorKey ليظهر فوق الـ Shell
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // --- المجموعة الثانية: ShellRoute الذي يحتوي على كل الشاشات ذات الـ BottomNav ---
      ShellRoute(
        // لا حاجة لمفتاح خاص هنا، سيعمل بشكل صحيح
        builder: (context, state, child) {
          final location = state.location;
          int selectedIndex = 0; // Home هو الافتراضي
          if (location.startsWith('/search')) {
            selectedIndex = 1;
          } else if (location.startsWith('/appointments') ||
              location.startsWith(ChatsListView.routeName)) {
            // ⭐️ دمجنا شرط قائمة المحادثات مع المواعيد
            selectedIndex = 2;
          } else if (location.startsWith('/profile')) {
            selectedIndex = 3;
          }

          return MainLayoutScreen(selectedIndex: selectedIndex, child: child);
        },
        routes: [
          // كل هذه المسارات ستظهر داخل MainLayoutScreen
          GoRoute(
            path: '/home',
            name: HomeView.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeView()),
          ),
          GoRoute(
            path: '/search',
            name: 'search', // أعطِ اسماً للمسار
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/appointments',
            name: 'appointments', // أعطِ اسماً للمسار
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AppointmentView()),
          ),
          GoRoute(
            path: ChatsListView.routeName, // مثال: '/chats'
            name: ChatsListView.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatsListView()),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile', // أعطِ اسماً للمسار
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Scaffold(
                body: Center(child: Text('Profile')),
              ), // استبدلها بشاشة البروفايل
            ),
          ),
        ],
      ),
    ],
  );
}
