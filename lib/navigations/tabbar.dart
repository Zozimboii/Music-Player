import 'package:flutter/material.dart';
import '../views/playlist_page.dart';
import '../navigations/profile_login.dart';
import '../views/homaPage.dart';
import '../views/profile.dart';
import '../views/search.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedTab = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<Widget> _pages = [
    Homepage(),
    SearchPage(),
    PlaylistPage(),
    Profile(),
  ];
  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => _pages[_selectedTab],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              currentIndex: _selectedTab,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: "HOME"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined), label: "SEARCH"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_outlined), label: "LIST"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outlined), label: "PROFILE"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
