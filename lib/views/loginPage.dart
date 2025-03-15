import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart' as btn;
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // พื้นหลังแบบ Gradient
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  // หัวข้อ Login
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Log in",
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
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                            ),
                            SizedBox(height: 20),

                            // ปุ่ม Continue
                            btn.MyButton(
                              label: ('Continue!'),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  print('valid');
                                } else {
                                  print('not valid');
                                }
                              },
                            ),

                            SizedBox(height: 20),

                            // Forgot Password
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
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