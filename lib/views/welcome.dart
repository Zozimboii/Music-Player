import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import './signup.dart';
import '../main.dart';
import '../components/my_button.dart' as btn;
import '../components/square_tile.dart' as tile;
class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // พื้นหลัง
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.teal[400]!,
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  
                  // ปุ่มย้อนกลับ
                  

                  // หัวข้อ Login
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Login By Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ฟอร์มล็อกอิน
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextField(
                              controller: usernameController,
                              hintText: 'Email',
                              obscureText: false,
                            ),
                            SizedBox(height: 20),

                            // ปุ่ม Sign In
                            btn.MyButton(
                              label: ('Sign In'),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Signup()),
                                  );
                                }
                              },
                            ),

                            SizedBox(height: 20),

                            // "Or"
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(thickness: 0.5, color: Colors.grey[400]),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Or', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                Expanded(
                                  child: Divider(thickness: 0.5, color: Colors.grey[400]),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // ปุ่ม Facebook, Google, Apple
                            // Column(
                            //   children: [
                            //     tile.SquareTile(imagePath: 'assets/google-logo.jpg', 
                            //     title: "Continue with Facebook"),
                            //     SizedBox(height: 10),
                            //     tile.SquareTile(imagePath: 'assets/facebook.png',
                            //     title: "Continue with Google"),
                            //     SizedBox(height: 10),
                            //     tile.SquareTile(imagePath: 'assets/apple.png', 
                            //     title: "Continue with Apple"),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sign up + Forgot Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}