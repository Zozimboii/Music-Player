import 'package:flutter/material.dart';
import 'package:music_player/views/player.dart';

import 'package:provider/provider.dart';
import '../model/playlist_provider.dart';
import '../model/music_provider.dart';

class MusicPlayerBar extends StatelessWidget {
  const MusicPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicProvider, PlaylistProvider>(
      builder: (context, musicProvider, playlistProvider, child) {
        final isPlayingFromMusicProvider =
            musicProvider.currentSongIndex != null;
        final isPlayingFromPlaylistProvider =
            playlistProvider.currentSongIndex != null;

        final songList = isPlayingFromMusicProvider
            ? musicProvider.allSongs
            : playlistProvider.allSongs;

        final currentSongIndex = isPlayingFromMusicProvider
            ? musicProvider.currentSongIndex
            : playlistProvider.currentSongIndex;

        if (currentSongIndex == null || currentSongIndex >= songList.length)
          return SizedBox.shrink();

        final song = songList[currentSongIndex];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerPage(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(5)),
            
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Image.asset(song.albumArtImagePath,
                    width: 50, height: 50, fit: BoxFit.cover),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.songName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(song.artistName, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (isPlayingFromMusicProvider) {
                      musicProvider.togglePlayPause();
                    } else if (isPlayingFromPlaylistProvider) {
                      playlistProvider.togglePlayPause();
                    }
                  },
                  child: Icon(
                    (isPlayingFromMusicProvider && musicProvider.isPlaying) ||
                            (isPlayingFromPlaylistProvider &&
                                playlistProvider.isPlaying)
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
