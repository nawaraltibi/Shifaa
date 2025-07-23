import 'package:flutter/material.dart';
// قم باستيراد الملفات الضرورية من مشروعك
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:shifaa/features/search/presentation/views/search_screen.dart';


class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

 
  static const List<Widget> _screenOptions = <Widget>[
    HomeViewBody(), 
    SearchScreen(), 
   
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screenOptions,
        physics: const NeverScrollableScrollPhysics(),
      ),

  
  
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryAppColor,
        unselectedItemColor: AppColors.secondaryTextColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

