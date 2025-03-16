import 'package:flutter/material.dart';
import 'package:music_player/model/playlist_provider.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';
import '../components/neu_box.dart';
import '../songs/song_data.dart';

class PlayerPage extends StatelessWidget {
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

    final Song currentSong = isMusicProviderActive
        ? musicProvider.allSongs[musicProvider.currentSongIndex!]
        : playlistProvider.allSongs[playlistProvider.currentSongIndex!];

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
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Add to Playlist') {
                        playlistProvider.addSongToLibrary(currentSong);
                      } else if (value == 'Remove from Playlist') {
                        playlistProvider.removeSongFromLibrary(currentSong);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      bool isInPlaylist =
                          playlistProvider.isInPlaylist(currentSong);
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
                          currentSong.albumArtImagePath,
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
                                  currentSong.songName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(currentSong.artistName),
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
