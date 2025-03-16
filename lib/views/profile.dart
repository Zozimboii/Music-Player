import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_player/main.dart';
import 'package:music_player/navigations/tabbar.dart';


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
              
                        // Profile picture
                        CircleAvatar(
                          radius: 60,
                          // backgroundImage: AssetImage("assets/person.jpeg"),
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
                            } else if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('No profile data found',
                                  style: TextStyle(color: Colors.white));
                            }
              
                            var data = snapshot.data!.data() as Map<String, dynamic>?;
              
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
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Tabbar(),
                  ));
                },
                          child: Text("ออกจากระบบ",style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 14),),
                        ),
              
                        // SizedBox(height: 32),
              
                        // Personal Info
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Personal Info",
                        //     style: TextStyle(
                        //       fontSize: 22,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 16),
              
                        // // List of all members (ถ้าต้องการให้แสดงเฉพาะของผู้ใช้เอง ควรเปลี่ยน query)
                        // StreamBuilder<QuerySnapshot>(
                        //   stream: FirebaseFirestore.instance
                        //       .collection('member')
                        //       .snapshots(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return CircularProgressIndicator();
                        //     } else if (snapshot.hasError) {
                        //       return Text('Error: ${snapshot.error}',
                        //           style: TextStyle(color: Colors.red));
                        //     } else if (!snapshot.hasData ||
                        //         snapshot.data!.docs.isEmpty) {
                        //       return Text(
                        //         'No members found',
                        //         style: TextStyle(color: Colors.white),
                        //       );
                        //     }
              
                        //     return ListView.builder(
                        //       shrinkWrap: true,
                        //       physics: NeverScrollableScrollPhysics(),
                        //       itemCount: snapshot.data!.docs.length,
                        //       itemBuilder: (context, index) {
                        //         var memberDoc = snapshot.data!.docs[index]
                        //             as DocumentSnapshot<Map<String, dynamic>>;
                        //         var memberData = memberDoc.data();
              
                        //         if (memberData == null) return SizedBox();
              
                        //         return Card(
                        //           color: Colors.white,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //           child: ListTile(
                        //             title: Text(
                        //               memberData['Name'] ?? 'No Name',
                        //               style: TextStyle(
                        //                 color: Colors.pink[800],
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //             subtitle: Text(
                        //               memberData['Email'] ?? 'No Email',
                        //               style: TextStyle(color: Colors.pink[600]),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),
              
                        // SizedBox(height: 50),
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