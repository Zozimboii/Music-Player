import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_player/main.dart';
import 'package:music_player/navigations/tabbar.dart';
import 'package:provider/provider.dart';

import '../model/playlist_provider.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic>? userData; // ✅ เพิ่มพารามิเตอร์

  const ProfilePage({super.key, this.userData}); // ✅ แก้ไข constructor
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No user logged in",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      body: MainLayout(
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(240, 2, 173, 136),
                    Colors.teal,
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
            ),

            // Profile content
            Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),

                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/panda.png",
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // User name from Firestore
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('member')
                              .doc(user.uid) // ใช้ UID ของผู้ใช้ปัจจุบัน
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.red));
                            } else if (!snapshot.hasData ||
                                !snapshot.data!.exists) {
                              return Text('No profile data found',
                                  style: TextStyle(color: Colors.white));
                            }

                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            String name = data?['name'] ?? 'No Name';
                            String email = data?['email'] ?? 'No Email';

                            return Column(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        // Edit profile button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            final playlistProvider =
                                Provider.of<PlaylistProvider>(context,
                                    listen: false);

                            await FirebaseAuth.instance.signOut();

                            // ล้างข้อมูล Playlist เมื่อออกจากระบบ
                            playlistProvider.clearPlaylist();

                            // รีเซ็ตหน้าและกลับไปยังหน้า Tabbar โดยลบ Stack ทั้งหมด
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Tabbar()),
                              (route) => false, // ลบทุกหน้าที่อยู่ก่อนหน้า
                            );
                          },
                          child: Text(
                            "ออกจากระบบ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
