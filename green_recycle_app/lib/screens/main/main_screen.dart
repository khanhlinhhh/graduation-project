import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'chatbot_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const SizedBox(), // Placeholder for camera FAB
    const ChatbotScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Navigate to camera screen
      Navigator.pushNamed(context, '/camera');
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is visible
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Hide bottom navigation bar when keyboard is visible
      bottomNavigationBar: isKeyboardVisible
          ? null
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex == 2 ? 0 : _currentIndex,
                  onTap: _onTabTapped,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: AppTheme.primaryColor,
                  unselectedItemColor: AppTheme.textSecondary,
                  selectedLabelStyle: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: AppTheme.bodySmall,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_outlined),
                      activeIcon: Icon(Icons.history),
                      label: 'Lịch sử',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code_scanner, color: Colors.transparent),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.smart_toy_outlined),
                      activeIcon: Icon(Icons.smart_toy),
                      label: 'Chatbot',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Cá nhân',
                    ),
                  ],
                ),
              ),
            ),
      // Hide FloatingActionButton when keyboard is visible
      floatingActionButton: isKeyboardVisible
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/camera'),
              backgroundColor: AppTheme.primaryColor,
              elevation: 8,
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
