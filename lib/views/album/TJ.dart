import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/playlist_provider.dart';
import '../../main.dart';
import 'package:provider/provider.dart';
import '../../model/music_provider.dart';

class AlbumTJPage extends StatefulWidget {
  const AlbumTJPage({super.key});

  @override
  State<AlbumTJPage> createState() => _AlbumTJPageState();
}

class _AlbumTJPageState extends State<AlbumTJPage> {
  @override
  Widget build(BuildContext context) {

    final musicProvider = Provider.of<MusicProvider>(context);
    final allSongs = musicProvider.allSongs;
    final tjSongs =
        allSongs.where((song) => song.artistName.contains("URBOYTJ")).toList();
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(title: Text("Playlist Urboy TJ")),
        body: Consumer2<MusicProvider, PlaylistProvider>(
          builder: (context, musicProvider, playlistProvider, child) {
            bool isPlaying = musicProvider.currentSongIndex != null ||
                playlistProvider.currentSongIndex != null;

            return Padding(
              padding: EdgeInsets.only(
                  bottom: isPlaying ? 80 : 0), // ใช้เงื่อนไขในการตั้งค่า bottom
              child: ListView.builder(
                itemCount: tjSongs.length,
                itemBuilder: (context, index) {
                  final song = tjSongs[index];

                  return GestureDetector(
                    onTap: () {
                      playlistProvider.stopMusic();
                      musicProvider.currentSongIndex =
                          musicProvider.allSongs.indexOf(song);
                    },
                    child: ListTile(
                      leading: song.albumArtImagePath.isNotEmpty
                          ? Image.asset(song.albumArtImagePath,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.music_note),
                      title: Text(
                        song.songName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        song.artistName,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            // ถ้ายังไม่ได้ล็อกอิน แสดงข้อความเตือน
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'กรุณาเข้าสู่ระบบก่อนเพิ่มเพลงใน Playlist'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // ออกจากฟังก์ชัน ไม่ต้องเพิ่มเพลง
                          }
                          if (value == 'Add to Playlist') {
                            // เพิ่มเพลงไปยัง Playlist
                            await playlistProvider.addToPlaylist(song);
                            // บันทึก Playlist ที่อัปเดตใน Firestore โดยเก็บข้อมูลทั้งหมดของเพลง
                            await playlistProvider.savePlaylist(
                              playlistProvider.allSongs
                                  .map((s) => {
                                        "songName": s.songName,
                                        "artistName": s.artistName,
                                        "albumArtImagePath":
                                            s.albumArtImagePath,
                                        "audioPath": s.audioPath,
                                      })
                                  .toList(),
                            );
                          } else if (value == 'Remove from Playlist') {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'กรุณาเข้าสู่ระบบก่อนลบเพลงจาก Playlist'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            await playlistProvider.removeSongFromPlaylist(song);
                            playlistProvider.stopMusic();
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          bool isInPlaylist =
                              playlistProvider.isInPlaylist(song);
                          return [
                            if (!isInPlaylist)
                              PopupMenuItem<String>(
                                value: 'Add to Playlist',
                                child: Row(
                                  children: [
                                    Icon(Icons.playlist_add),
                                    SizedBox(width: 10),
                                    Text('Add to Playlist'),
                                  ],
                                ),
                              )
                            else
                              PopupMenuItem<String>(
                                value: 'Remove from Playlist',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 10),
                                    Text('Remove from Playlist'),
                                  ],
                                ),
                              ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
