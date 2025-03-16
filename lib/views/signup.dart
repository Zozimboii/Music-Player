import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/loginPage.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart' as btn;
import './welcome.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> saveToFirebase(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // ✅ สมัครสมาชิกกับ Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ ดึง UID ของผู้ใช้ที่สร้างใหม่
      String uid = userCredential.user!.uid;

      // ✅ บันทึกข้อมูลลง Firestore (ใช้ UID เป็น doc ID)
      await FirebaseFirestore.instance.collection("member").doc(uid).set({
        "UID": uid,
        "email": email,
        "name": name,
        "Password": password,
      });

      // ✅ เพิ่มข้อมูลผู้ใช้ลงใน members collection
      await addUserToMembers();  // เรียกใช้ฟังก์ชันนี้ที่นี่

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful!")),
      );

      // ✅ ส่งไปหน้า LoginPage พร้อมกับ UID
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(uid: uid),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
Future<void> addUserToMembers() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    String name = user.displayName ?? "Anonymous"; // หรือรับจาก input

    CollectionReference members = FirebaseFirestore.instance.collection('member');

    // เพิ่มข้อมูลผู้ใช้ใหม่ใน members collection
    await members.doc(userId).set({
      'name': name,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'playlist': []  // เพิ่มข้อมูล playlist ว่าง ๆ ให้กับผู้ใช้
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
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
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Looks like you don't have an account. Let's create a new account for",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                  textAlign: TextAlign.start,
                                ),
                                const Text(
                                  "Enter your email below",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 20),
                                MyTextField(
                                  controller: nameController,
                                  hintText: 'Name',
                                  obscureText: false,
                                ),
                                SizedBox(height: 10),
                                MyTextField(
                                  controller: usernameController,
                                  hintText: 'Email',
                                  obscureText: false,
                                ),
                                SizedBox(height: 10),
                                MyTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                SizedBox(height: 20),
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'By selecting Agree & Continue below, I agree to our ',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: 'Terms of Service and Privacy Policy',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 71, 233, 133),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                btn.MyButtonAgree(
                                  text: "Agree and Continue",
                                  onTap: () async {
                                    await saveToFirebase(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}