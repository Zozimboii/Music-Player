import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/model/playlist_provider.dart';
import 'package:provider/provider.dart';
import '../model/music_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final allSongs = musicProvider.allSongs;

    final filteredSongs = allSongs.where((song) {
      return song.songName.toLowerCase().contains(_searchQuery) ||
          song.aristName.toLowerCase().contains(_searchQuery);
    }).toList();

    return MainLayout(
      child: Scaffold(
       
        body: Stack(
          
          children: [ Container(
            padding: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(240, 2, 173, 136),
           
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by song name or artist...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
              child: Consumer2<MusicProvider, PlaylistProvider>(
              builder: (context, musicProvider, playlistProvider, child) {
                bool isPlaying = musicProvider.currentSongIndex != null ||
                                 playlistProvider.currentSongIndex != null;
                  List shuffledSongs = List.from(filteredSongs)..shuffle();
                  return Padding(
            padding: EdgeInsets.only(bottom: isPlaying ? 140 : 60), // เงื่อนไขให้เว้นที่ด้านล่าง
            child: ListView.builder(
              itemCount: shuffledSongs.length,
              itemBuilder: (context, index) {
                final song = shuffledSongs[index];
            
                return ListTile(
                  leading: song.albumArtImagePath.isNotEmpty
                      ? Image.asset(song.albumArtImagePath,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.music_note),
                  title: Text(song.songName),
                  subtitle: Text(song.aristName),
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
                );
              },
            ),
                  );
                },
              ),
            ),
               
              ],
            ),
          ),
          ]
        ),
        
      ),
    );
  }
}
