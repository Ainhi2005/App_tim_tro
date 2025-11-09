import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../video/video_page.dart';
import '../map/map_page.dart';
import '../chat/chat_page.dart';
import '../account/account_page.dart';
import 'home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    VideoPage(),
    MapPage(),
    ChatPage(),
    AccountPage(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
