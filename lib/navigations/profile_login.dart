import 'package:flutter/material.dart';
import '../views/welcome.dart';

void main() {
  runApp(const Profile());
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dribbble Auth App',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}