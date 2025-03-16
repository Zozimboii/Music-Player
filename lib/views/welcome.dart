// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:music_player/navigations/profile_login.dart';
// import 'package:music_player/views/profile.dart';
// import '../components/my_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import './signup.dart';
// import '../main.dart';
// import '../components/my_button.dart' as btn;
// import '../components/square_tile.dart' as tile;
// class WelcomePage extends StatefulWidget {
//   WelcomePage({super.key});

//   @override
//   State<WelcomePage> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   // 🔥 ฟังก์ชันล็อกอิน
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Profile()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'Login failed. Please try again.';
//       if (e.code == 'user-not-found') {
//         errorMessage = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         errorMessage = 'Wrong password. Try again.';
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // พื้นหลัง
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.teal[400]!,
//                   Colors.black.withOpacity(0.9),
//                   Colors.black.withOpacity(1),
//                 ],
//               ),
//             ),
//           ),

//           // Main Content
//           SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: SafeArea(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.1),

//                   // หัวข้อ Login
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       "Login By Email",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 20),

//                   // ฟอร์มล็อกอิน
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             MyTextField(
//                               controller: _emailController,
//                               hintText: 'Email',
//                               obscureText: false,
//                             ),
//                             SizedBox(height: 20),
//                             MyTextField(
//                               controller: _passwordController,
//                               hintText: 'Password',
//                               obscureText: true,
//                             ),
//                             SizedBox(height: 20),

//                             // ปุ่ม Sign In
//                             btn.MyButton(
//                               label: _isLoading ? 'Signing in...' : 'Sign In',
//                               onTap: _isLoading ? null : _login,
//                             ),

//                             SizedBox(height: 20),

//                             // "Or"
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Divider(thickness: 0.5, color: Colors.grey[400]),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                   child: Text('Or', style: TextStyle(color: Colors.white, fontSize: 16)),
//                                 ),
//                                 Expanded(
//                                   child: Divider(thickness: 0.5, color: Colors.grey[400]),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 20),

//                   // Sign up + Forgot Password
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => Signup()),
//                             );
//                           },
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         GestureDetector(
//                           onTap: () {
//                             // TODO: เพิ่มการ Reset Password
//                           },
//                           child: const Text(
//                             'Forgot Password?',
//                             style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }