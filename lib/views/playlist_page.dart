import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/views/player.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';
import '../model/playlist_provider.dart';
import '../songs/song_data.dart';

// class PlaylistPage extends StatelessWidget {
//   const PlaylistPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final playlistProvider = Provider.of<PlaylistProvider>(context);

//     final List<Song> playlist = playlistProvider.allSongs;

//     return MainLayout(
//       child: Scaffold(
//         body: playlist.isEmpty
//             ? Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color.fromARGB(240, 2, 173, 136),
//                       Color.fromARGB(132, 2, 173, 136),
//                       Colors.black.withOpacity(0.7),
//                       Colors.black.withOpacity(0.9),
//                       Colors.black.withOpacity(1),
//                     ],
//                   ),
//                 ),
//                 child: Center(child: Text("Your playlist is empty")))
//             : Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color.fromARGB(240, 2, 173, 136),
//                       Colors.black.withOpacity(0.9),
//                       Colors.black.withOpacity(1),
//                       Colors.black.withOpacity(1),
//                     ],
//                   ),
//                 ),
//                 child: Stack(
//                   children: [

//                     Padding(
//                         padding: EdgeInsets.symmetric(vertical: 70),
//                         child: Align(
//                             alignment: Alignment.topCenter,
//                             child: Text(
//                               'Your Playlist',
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             )
//                             )
//                             ),
//                              Consumer2<MusicProvider, PlaylistProvider>(
//           builder: (context, musicProvider, playlistProvider, child) {
//             bool isPlaying = musicProvider.currentSongIndex != null ||
//                              playlistProvider.currentSongIndex != null;

//                     return Container(
//                       padding: EdgeInsets.only(top: 120,bottom: isPlaying ? 85 : 0),
//                       child: ListView.builder(
//                         itemCount: playlist.length,
//                         itemBuilder: (context, index) {
//                           final song = playlist[index];
//                           return Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5), // เพิ่มระยะห่างรอบๆ container
//                             padding: EdgeInsets.all(12), // เพิ่มระยะห่างด้านใน
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(
//                                   0.5), // สีพื้นหลังแบบโปร่งใสเล็กน้อย
//                               borderRadius:
//                                   BorderRadius.circular(20), // ทำให้ขอบโค้งมน
//                               boxShadow: [
//                                 BoxShadow(
//                                  color: Colors.white.withOpacity(0.4), // เงาสีขาวเรืองแสง
//         blurRadius: 2, // ความเบลอของแสง
//         spreadRadius: 1, // การกระจายของแสง
//         offset: Offset(0, 0), // เงาอยู่ตรงกลาง ไม่มีการเลื่อน
//                                 ),
//                               ],
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   Color.fromARGB(
//                                       240, 2, 173, 136), // สีเขียวหลัก
//                                   Color.fromARGB(132, 2, 173, 136),
//                                   Colors.black.withOpacity(0.7),
//                                 ],
//                               ),
//                             ),
//                             child: ListTile(
//                               leading: Image.asset(song.albumArtImagePath,
//                                   width: 50, height: 50, fit: BoxFit.cover),
//                               title: Text(song.songName),
//                               onTap: () {
//                                 musicProvider.stopMusic();

//                                 playlistProvider.currentSongIndex =
//                                     playlistProvider.allSongs.indexOf(song);
//                               },
//                               subtitle: Text(song.artistName),
//                               trailing: PopupMenuButton<String>(
//                                 onSelected: (value) {
//                                   if (value == 'Add to Playlist') {
//                                     playlistProvider.addSongToLibrary(song);
//                                   } else if (value == 'Remove from Playlist') {
//                                     playlistProvider
//                                         .removeSongFromLibrary(song);
//                                   }
//                                 },
//                                 itemBuilder: (BuildContext context) {
//                                   bool isInPlaylist =
//                                       playlistProvider.isInPlaylist(song);
//                                   return [
//                                     if (!isInPlaylist)
//                                       PopupMenuItem<String>(
//                                         value: 'Add to Playlist',
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.playlist_add),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text('Add to Playlist'),
//                                           ],
//                                         ),
//                                       )
//                                     else
//                                       PopupMenuItem<String>(
//                                         value: 'Remove from Playlist',
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.remove_circle),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text('Remove from Playlist'),
//                                           ],
//                                         ),
//                                       ),
//                                   ];
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//           }
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }class PlaylistPage extends StatelessWidget {

// อันนี้ล่าสุด show ได้
// class PlaylistPage extends StatelessWidget {
//   const PlaylistPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     final playlistProvider = Provider.of<PlaylistProvider>(context);

//     final List<Song> playlist = playlistProvider.allSongs;
//     if (userId != null) {
//       createPlaylistIfNotExists(userId); // เช็คและสร้าง Playlist หากไม่มี
//     }

//     return MainLayout(
//       child: Scaffold(
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('member')
//               .doc(userId) // ใช้ userId เพื่อดึงข้อมูลสมาชิก
//               .snapshots(),
//           builder: (context, memberSnapshot) {
//             if (memberSnapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }

//             if (!memberSnapshot.hasData || !memberSnapshot.data!.exists) {
//               return Center(child: Text("Member not found"));
//             }

//             // ดึงข้อมูลสมาชิกที่ตรงกับ userId
//             final memberDoc = memberSnapshot.data!;
//             final playlistData = memberDoc['playlist'] ?? [];

//             // เช็คโครงสร้างข้อมูลใน playlistData
//             List<Song> playlist = [];
//             try {
//               playlist = playlistData.map<Song>((songData) {
//                 if (songData is String) {
//                   // ถ้าเป็นแค่ชื่อเพลง (รูปแบบเก่า) ให้ใส่ค่า default
//                   return Song(
//                     songName: songData,
//                     artistName: "Unknown Artist",
//                     albumArtImagePath: "assets/images/albumpun.jpg",
//                     audioPath: "assets/videos/dayone.mp3",
//                   );
//                 } else if (songData is Map<String, dynamic>) {
//                   // รูปแบบที่ถูกต้อง
//                   return Song(
//                     songName: songData['songName'] ?? 'Unknown Song',
//                     artistName: songData['artistName'] ?? 'Unknown Artist',
//                     albumArtImagePath: songData['albumArtImagePath'] ??
//                         'assets/images/albumpun.jpg',
//                     audioPath:
//                         songData['audioPath'] ?? 'assets/videos/dayone.mp3',
//                   );
//                 } else {
//                   throw Exception('Invalid song data');
//                 }
//               }).toList();
//             } catch (e) {
//               return Center(child: Text('Error processing playlist data: $e'));
//             }

//             if (playlist.isEmpty) {
//               return Center(child: Text("Your playlist is empty"));
//             }

//             return ListView.builder(
//               itemCount: playlist.length,
//               itemBuilder: (context, index) {
//                 final song = playlist[index];
//                 return ListTile(
//                   leading: Image.asset(song.albumArtImagePath),
//                   title: Text(song.songName),
//                   subtitle: Text(song.artistName),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ฟังก์ชันสำหรับเช็คและสร้าง Playlist ถ้ายังไม่มี
//   Future<void> createPlaylistIfNotExists(String userId) async {
//     final memberSnapshot =
//         await FirebaseFirestore.instance.collection('member').doc(userId).get();

//     if (!memberSnapshot.exists) {
//       await FirebaseFirestore.instance.collection('member').doc(userId).set({
//         'playlist': [], // สร้าง Playlist ว่างๆ
//       });
//     }
//   }
// }
class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    
    playlistProvider.loadPlaylist();  // โหลด Playlist เมื่อหน้าเปิด
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(title: Text('My Playlist')),
        body: ListView.builder(
          itemCount: playlistProvider.allSongs.length,
          itemBuilder: (context, index) {
            final song = playlistProvider.allSongs[index];
            return ListTile(
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              onTap: () {
                musicProvider.stopMusic();
                 playlistProvider.currentSongIndex =
                                            playlistProvider.allSongs
                                                .indexOf(song);// เล่นเพลงเมื่อคลิก
              },
            );
          },
        ),
      ),
    );
  }


  
}
