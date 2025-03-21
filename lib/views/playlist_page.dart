import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';
import '../model/playlist_provider.dart';
import '../songs/song_data.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PlaylistProvider>(context, listen: false).loadPlaylist();
    });
  }

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
                            ))),
                    Consumer2<MusicProvider, PlaylistProvider>(builder:
                        (context, musicProvider, playlistProvider, child) {
                      bool isPlaying = musicProvider.currentSongIndex != null ||
                          playlistProvider.currentSongIndex != null;

                      return Container(
                        padding: EdgeInsets.only(
                            top: 120, bottom: isPlaying ? 85 : 0),
                        child: ListView.builder(
                          itemCount: playlist.length,
                          itemBuilder: (context, index) {
                            final song = playlist[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5), 
                              padding:
                                  EdgeInsets.all(12), 
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.5),
                                borderRadius:
                                    BorderRadius.circular(20), 
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(0.4), 
                                    blurRadius: 2, 
                                    spreadRadius: 1, 
                                    offset: Offset(
                                        0, 0), 
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(
                                        240, 2, 173, 136), 
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
                                subtitle: Text(song.artistName),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Add to Playlist') {
                                      playlistProvider.addSongToLibrary(song);
                                    } else if (value ==
                                        'Remove from Playlist') {
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
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
