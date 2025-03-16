import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:music_player/model/music_provider.dart';
import 'package:music_player/songs/song_data.dart';
import 'package:music_player/views/album/TJ.dart';
import 'package:provider/provider.dart';
import 'package:music_player/model/playlist_provider.dart';
import 'package:music_player/views/album/nont_tanont.dart';
import 'package:music_player/views/album/pun.dart';
import '../widgets/album_card.dart';
import '../widgets/song_card.dart';
import '../main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Song> randomSongs = []; // ตัวแปรเก็บผลลัพธ์การสุ่มเพลง

  @override
  void initState() {
    super.initState();
    // สุ่มเพลง 5 เพลงครั้งเดียวตอนเริ่มต้น
    final random = Random();
    final shuffledSongs =
        List<Song>.from(context.read<MusicProvider>().allSongs)
          ..shuffle(random);
    randomSongs = shuffledSongs.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            // ย้าย Container ไปไว้ที่ตำแหน่งสุดท้าย (พื้นหลังด้านหลัง)
            Positioned.fill(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .6,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(240, 2, 173, 136),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Recommended Songs",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Consumer2<MusicProvider, PlaylistProvider>(builder:
                                (context, musicProvider, playlistProvider,
                                    child) {
                              return Row(
                                children: randomSongs.map((song) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        playlistProvider.stopMusic();
                                        musicProvider.currentSongIndex =
                                            musicProvider.allSongs
                                                .indexOf(song);
                                      },
                                      child: SongCard(
                                        image:
                                            AssetImage(song.albumArtImagePath),
                                        label: song.songName,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Albums",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AlbumPunPage()),
                                  );
                                },
                                child: const AlbumCard(
                                  label: "PUN",
                                  image: AssetImage("assets/images/pun.png"),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AlbumNontPage()),
                                  );
                                },
                                child: const AlbumCard(
                                  label: "NONT TANONT",
                                  image: AssetImage("assets/images/nont.png"),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AlbumTJPage()),
                                  );
                                },
                                child: const AlbumCard(
                                  label: "Urboy TJ",
                                  image: AssetImage("assets/images/TJ.jpg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<PlaylistProvider>(
                          builder: (context, playlistProvider, child) {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId == null) {
                          return Padding(
                              padding: EdgeInsets.all(
                                  10)); // ถ้าไม่มี userId ให้ return Container() (ไม่แสดง UI)
                        }
                        if (playlistProvider.allSongs.isEmpty) {
                          return SizedBox
                              .shrink(); // ถ้าไม่มีเพลงใน Playlist ให้ไม่แสดงอะไรเลย
                        }
                        return Visibility(
                          visible: playlistProvider.allSongs.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: playlistProvider.allSongs.isNotEmpty
                                ? Text(
                                    "Your Playlists",
                                    style: TextStyle(fontSize: 22),
                                  )
                                : Container(),
                          ),
                        );
                      }),
                      Consumer2<MusicProvider, PlaylistProvider>(
                        builder:
                            (context, musicProvider, playlistProvider, child) {
                          final userId = FirebaseAuth.instance.currentUser?.uid;
                          if (userId == null) {
                            return Padding(
                                padding: EdgeInsets.all(
                                    10)); // ถ้าไม่มี userId ให้ return Container() (ไม่แสดง UI)
                          }
                          if (playlistProvider.allSongs.isEmpty) {
                            return SizedBox
                                .shrink(); // ถ้าไม่มีเพลงใน Playlist ให้ไม่แสดงอะไรเลย
                          }
                          return Visibility(
                            visible: playlistProvider.allSongs.isNotEmpty,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: playlistProvider.allSongs.map((song) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        musicProvider.stopMusic();

                                        playlistProvider.currentSongIndex =
                                            playlistProvider.allSongs
                                                .indexOf(song);
                                      },
                                      child: SongCard(
                                        image:
                                            AssetImage(song.albumArtImagePath),
                                        label: song.songName,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
