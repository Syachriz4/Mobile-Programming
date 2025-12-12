import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/running_page.dart';
import 'pages/hiking_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunHike Islami',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E27),
          elevation: 0,
        ),
      ),
      home: const MainApp(),
    );
  }
}

// ============= MAIN NAVIGATION =============
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const RunningPage(),
    const HikingPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // Callback untuk navigate ke tab tertentu dari child pages
  void navigateToTab(int index) {
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Run',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.terrain),
            label: 'Hike',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}