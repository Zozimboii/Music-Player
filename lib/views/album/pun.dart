import 'package:flutter/material.dart';
import 'package:music_player/model/playlist_provider.dart';

import '../../main.dart';
import 'package:provider/provider.dart';
import '../../model/music_provider.dart';

class AlbumPunPage extends StatefulWidget {
  const AlbumPunPage({super.key});

  @override
  State<AlbumPunPage> createState() => _AlbumPunPageState();
}

class _AlbumPunPageState extends State<AlbumPunPage> {
  @override
  Widget build(BuildContext context) {
   
    final musicProvider = Provider.of<MusicProvider>(context);
    final allSongs = musicProvider.allSongs;
    final punSongs =
        allSongs.where((song) => song.aristName.contains("PUN")).toList();
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(title: Text("Album PUN")),
        body: Consumer2<MusicProvider, PlaylistProvider>(
          builder: (context, musicProvider, playlistProvider, child) {
            bool isPlaying = musicProvider.currentSongIndex != null ||
                             playlistProvider.currentSongIndex != null;

            return Padding(
              padding: EdgeInsets.only(bottom: isPlaying ? 140 : 60), // ใช้เงื่อนไขในการตั้งค่า bottom
              child: ListView.builder(
                itemCount: punSongs.length,
                itemBuilder: (context, index) {
                  final song = punSongs[index];

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
                        song.aristName,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Add to Playlist') {
                            playlistProvider.addSongToLibrary(song);
                          } else if (value == 'Remove from Playlist') {
                            playlistProvider.removeSongFromLibrary(song);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          bool isInPlaylist = playlistProvider.isInPlaylist(song);
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