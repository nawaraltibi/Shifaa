import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/layout/main_layout_screen.dart';
import 'package:shifaa/features/appointments/presentation/views/appointment_view.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/auth/presentation/views/verify_otp_view.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/re_sched_appointment_view.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
import 'package:shifaa/features/chat/presentation/views/chats_list_view.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
import 'package:shifaa/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:shifaa/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:shifaa/features/search/presentation/views/search_screen.dart';
import 'package:shifaa/features/splash/presentation/views/splash_view.dart';
import 'package:shifaa/features/treatmeant_plan/presentation/views/treatment_view.dart';

import '../../features/home/presentation/views/upcoming_appointments_view.dart';
import '../../features/home/presentation/views/widgets/previous_appointments_view.dart';

abstract class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'Root',
  );

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: OnBoardingView.routeName,
        name: OnBoardingView.routeName,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: PreviousAppointmentsView.routeName,
        name: PreviousAppointmentsView.routeName,
        builder: (context, state) => const PreviousAppointmentsView(),
      ),
      GoRoute(
        path: UpcomingAppointmentsView.routeName,
        name: UpcomingAppointmentsView.routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UpcomingAppointmentsView(),
          restorationId: UpcomingAppointmentsView.routeName,
        ),
      ),
      GoRoute(
        path: TreatmentView.routeName,
        name: TreatmentView.routeName,
        builder: (context, state) => const TreatmentView(),
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
      GoRoute(
        path: DoctorDetailsView.routeName,
        name: DoctorDetailsView.routeName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final doctorId = state.extra as int? ?? 0;
          return DoctorDetailsView(doctorId: doctorId);
        },
      ),
      GoRoute(
        path: ChatView.routeName,
        name: ChatView.routeName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final chatId = args['chatId'] as int? ?? 0;
          final doctorName = args['doctorName'] as String? ?? 'Doctor';
          final doctorImage = args['doctorImage'] as String?;
          final isMuted = args['isMuted'] as bool? ?? false;
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final location = state.location;
          int selectedIndex = 0;
          if (location.startsWith('/search'))
            selectedIndex = 1;
          else if (location.startsWith('/appointments') ||
              location.startsWith(ChatsListView.routeName))
            selectedIndex = 2;
          else if (location.startsWith('/profile'))
            selectedIndex = 3;
          return MainLayoutScreen(selectedIndex: selectedIndex, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: HomeView.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeView()),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/appointments',
            name: 'appointments',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AppointmentView()),
          ),
          GoRoute(
            path: ChatsListView.routeName,
            name: ChatsListView.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatsListView()),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Scaffold(body: Center(child: Text('Profile'))),
            ),
          ),
        ],
      ),
    ],
  );
}
