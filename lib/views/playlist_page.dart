import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';
import '../model/playlist_provider.dart';
import '../songs/song_data.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
 
    final List<Song> playlist = playlistProvider.allSongs;

    return MainLayout(
      child: Scaffold(
        body: playlist.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(240, 2, 173, 136),
                      Color.fromARGB(132, 2, 173, 136),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(1),
                    ],
                  ),
                ),
                child: Center(child: Text("Your playlist is empty")))
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(240, 2, 173, 136),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 70),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Your Playlist',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )
                            )
                            ),
                             Consumer2<MusicProvider, PlaylistProvider>(
          builder: (context, musicProvider, playlistProvider, child) {
            bool isPlaying = musicProvider.currentSongIndex != null ||
                             playlistProvider.currentSongIndex != null;

                    return Container(
                      padding: EdgeInsets.only(top: 120,bottom: isPlaying ? 140 : 60),
                      child: ListView.builder(
                        itemCount: playlist.length,
                        itemBuilder: (context, index) {
                          final song = playlist[index];
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5), // เพิ่มระยะห่างรอบๆ container
                            padding: EdgeInsets.all(12), // เพิ่มระยะห่างด้านใน
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // สีพื้นหลังแบบโปร่งใสเล็กน้อย
                              borderRadius:
                                  BorderRadius.circular(20), // ทำให้ขอบโค้งมน
                              boxShadow: [
                                BoxShadow(
                                 color: Colors.white.withOpacity(0.4), // เงาสีขาวเรืองแสง
        blurRadius: 2, // ความเบลอของแสง
        spreadRadius: 1, // การกระจายของแสง
        offset: Offset(0, 0), // เงาอยู่ตรงกลาง ไม่มีการเลื่อน
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(
                                      240, 2, 173, 136), // สีเขียวหลัก
                                  Color.fromARGB(132, 2, 173, 136),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: ListTile(
                              leading: Image.asset(song.albumArtImagePath,
                                  width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(song.songName),
                              onTap: () {
                                musicProvider.stopMusic();

                                playlistProvider.currentSongIndex =
                                    playlistProvider.allSongs.indexOf(song);
                              },
                              subtitle: Text(song.aristName),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Add to Playlist') {
                                    playlistProvider.addSongToLibrary(song);
                                  } else if (value == 'Remove from Playlist') {
                                    playlistProvider
                                        .removeSongFromLibrary(song);
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Add to Playlist'),
                                          ],
                                        ),
                                      )
                                    else
                                      PopupMenuItem<String>(
                                        value: 'Remove from Playlist',
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_circle),
                                            SizedBox(
                                              width: 10,
                                            ),
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
          }
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
