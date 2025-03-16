import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/views/profile.dart';
import '../views/playlist_page.dart';
import '../views/loginPage.dart';
import '../views/homaPage.dart';
import '../views/search.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedTab = 0;
  bool isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser; // ตรวจสอบว่าเป็นผู้ใช้ที่ล็อกอินอยู่หรือไม่
    isLoggedIn = user != null; // ถ้ามี user หมายความว่า user ได้ล็อกอิน
  }

  final List<Widget> _pages = [
    Homepage(),
    SearchPage(),
    PlaylistPage(),
    ProfilePage(),
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
      body: IndexedStack(
        index: _selectedTab,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          if (index == 3 && !isLoggedIn) {
            // ถ้ายังไม่ได้ล็อกอิน และกดที่โปรไฟล์ ให้ไปหน้า LoginPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            setState(() {
              _selectedTab = index;
            });
          }
        },
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
    );
  }
}
