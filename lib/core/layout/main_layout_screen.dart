// في ملف: lib/core/layout/main_layout_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/features/appointments/presentation/views/appointment_view.dart';
import 'package:shifaa/features/chat/presentation/views/chats_list_view.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const MainLayoutScreen({
    super.key,
    required this.child,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // ❌ تم حذف المنطق اليدوي لإخفاء وإظهار الـ BottomNav

    return Scaffold(
      body: child,
      // ⭐️ أصبح الـ BottomNavigationBar يُعرض دائماً بدون شروط
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
            
              context.go('/appointments');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryAppColor,
        unselectedItemColor: AppColors.secondaryTextColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          // ⭐️ قمت بتغيير الأيقونة والاسم ليعكس المحادثات
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
