import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/playlist_provider.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';
import '../components/neu_box.dart';
import '../songs/song_data.dart';

class PlayerPage extends StatefulWidget {
  final Song song; // รับข้อมูลเพลง

  const PlayerPage({super.key, required this.song});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    final bool isMusicProviderActive = musicProvider.currentSongIndex != null;
    final bool isPlaylistProviderActive =
        playlistProvider.currentSongIndex != null;

    if (!isMusicProviderActive && !isPlaylistProviderActive) {
      return Scaffold(
        body: Center(child: Text("No song is currently playing")),
      );
    }

    final Song? currentSong = isMusicProviderActive
    ? (musicProvider.currentSongIndex != null && musicProvider.currentSongIndex! < musicProvider.allSongs.length)
        ? musicProvider.allSongs[musicProvider.currentSongIndex!]
        : null
    : (playlistProvider.currentSongIndex != null && playlistProvider.currentSongIndex! < playlistProvider.allSongs.length)
        ? playlistProvider.allSongs[playlistProvider.currentSongIndex!]
        : null;

    String formatTime(Duration duration) {
      String twoDigitSeconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "${duration.inMinutes}:$twoDigitSeconds";
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    isMusicProviderActive
                        ? "Playing from Album"
                        : "Playing from Playlist",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Consumer<PlaylistProvider>(
  builder: (context, playlistProvider, snapshot) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // ถ้ายังไม่ได้ล็อกอิน แสดงข้อความเตือน
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเข้าสู่ระบบก่อนเพิ่มเพลงใน Playlist'),
              backgroundColor: Colors.red,
            ),
          );
          return; // ออกจากฟังก์ชัน ไม่ต้องเพิ่มเพลง
        }
      final song = widget.song;
        if (value == 'Add to Playlist') {
          // เพิ่มเพลงไปยัง Playlist
          await playlistProvider.addToPlaylist(song);
          // บันทึก Playlist ที่อัปเดตใน Firestore
          await playlistProvider.savePlaylist(
            playlistProvider.allSongs.map((s) => {
              "songName": s.songName,
              "artistName": s.artistName,
              "albumArtImagePath": s.albumArtImagePath,
              "audioPath": s.audioPath,
            }).toList(),
          );
        } else if (value == 'Remove from Playlist') {
          // ลบเพลงออกจาก Playlist
          await playlistProvider.removeSongFromPlaylist(song);
          playlistProvider.stopMusic();
          Navigator.pop(context);
        }
      },
      itemBuilder: (BuildContext context) {
        final song = widget.song;
        bool isInPlaylist = playlistProvider.isInPlaylist(song);
        return [
          // เมื่อลิสต์เพลงไม่อยู่ใน Playlist
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
          // เมื่อลิสต์เพลงอยู่ใน Playlist
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
    );
  },
)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: NeuBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          currentSong?.albumArtImagePath  ?? 'assets/images/albumnont.jpg',
                          width: 400,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong?.songName ?? 'Unknown Song',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(currentSong?.artistName ?? 'Unknown Artist'),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                isMusicProviderActive
                                    ? (musicProvider.isFavorite(
                                            musicProvider.currentSongIndex)
                                        ? Icons.favorite
                                        : Icons.favorite_outline)
                                    : (playlistProvider.isFavorite(
                                            playlistProvider.currentSongIndex)
                                        ? Icons.favorite
                                        : Icons.favorite_outline),
                              ),
                              color: (isMusicProviderActive &&
                                          musicProvider.isFavorite(musicProvider
                                              .currentSongIndex)) ||
                                      (!isMusicProviderActive &&
                                          playlistProvider.isFavorite(
                                              playlistProvider
                                                  .currentSongIndex))
                                  ? Colors.red
                                  : Colors.grey,
                              onPressed: () {
                                if (isMusicProviderActive) {
                                  musicProvider.toggleFavorite(
                                      musicProvider.currentSongIndex);
                                } else {
                                  playlistProvider.toggleFavorite(
                                      playlistProvider.currentSongIndex);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 0)),
                    child: Slider(
                      min: 0,
                      max: (isMusicProviderActive
                              ? musicProvider.totalDuration
                              : playlistProvider.totalDuration)
                          .inSeconds
                          .toDouble(),
                      value: (isMusicProviderActive
                              ? musicProvider.currentDuration
                              : playlistProvider.currentDuration)
                          .inSeconds
                          .toDouble(),
                      activeColor: Colors.green,
                      onChanged: (double value) {},
                      onChangeEnd: (double value) {
                        if (isMusicProviderActive) {
                          musicProvider.seek(Duration(seconds: value.toInt()));
                        } else {
                          playlistProvider
                              .seek(Duration(seconds: value.toInt()));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(isMusicProviderActive
                            ? musicProvider.currentDuration
                            : playlistProvider.currentDuration)),
                        Text(formatTime(isMusicProviderActive
                            ? musicProvider.totalDuration
                            : playlistProvider.totalDuration)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isMusicProviderActive) {
                          musicProvider.playPreviousSong();
                        } else {
                          playlistProvider.playPreviousSong();
                        }
                      },
                      child: NeuBox(child: Icon(Icons.skip_previous)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        if (isMusicProviderActive) {
                          musicProvider.togglePlayPause();
                        } else {
                          playlistProvider.togglePlayPause();
                        }
                      },
                      child: NeuBox(
                          child: Icon((isMusicProviderActive
                                  ? musicProvider.isPlaying
                                  : playlistProvider.isPlaying)
                              ? Icons.pause
                              : Icons.play_arrow)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isMusicProviderActive) {
                          musicProvider.playNextSong();
                        } else {
                          playlistProvider.playNextSong();
                        }
                      },
                      child: NeuBox(child: Icon(Icons.skip_next)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
