import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_player/navigations/tabbar.dart';
import 'package:music_player/views/signup.dart';


class LoginPage extends StatefulWidget {
  final String? uid;
  const LoginPage({super.key, this.uid});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("member").doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Future<void> loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      Map<String, dynamic>? userData = await fetchUserData(uid);

      if (userData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Tabbar(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User data not found in Firestore"),
          backgroundColor: Colors.red,
        ));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'wrong-password')
        errorMessage = "Incorrect password.";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังเหมือน Profile
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(240, 2, 173, 136),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
            
                        // ช่องกรอกอีเมล
                        _buildTextField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email,
                        ),
            
                        SizedBox(height: 20),
            
                        // ช่องกรอกรหัสผ่าน
                        _buildTextField(
                          controller: passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          obscureText: true,
                        ),
            
                        SizedBox(height: 30),
            
                        // ปุ่ม Continue
                        isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () => loginUser(context),
                                child: Text("Continue"),
                              ),
            
                        SizedBox(height: 20),
            
                        // ปุ่มสมัครสมาชิก
                         Padding(
                           padding: const EdgeInsets.only(left: 75.0),
                           child: Row(
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.tealAccent),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Signup()), // Make sure to use the correct syntax
                              );
                            },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(color: Colors.redAccent,fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                         ),
                        
            
                        SizedBox(height: 100),
                        GestureDetector(
                          onTap:(){
                      
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Tabbar()));
                          } ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back,size: 50,),
                              SizedBox(width: 10,),
                              Text('Back to Music')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter your $label";
        return null;
      },
    );
  }
}
