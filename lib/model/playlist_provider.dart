import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../songs/song_data.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistProvider extends ChangeNotifier {
  Future<void> loadPlaylist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        // ดึงข้อมูล Playlist จาก Firestore
        DocumentSnapshot memberDoc = await FirebaseFirestore.instance
            .collection('member')
            .doc(userId)
            .get();
        if (memberDoc.exists) {
          List playlistData = memberDoc['playlist'] ?? [];
          // แปลงข้อมูลเป็น Song objects
          _allSongs = playlistData.map<Song>((songData) {
            return Song(
              songName: songData['songName'] ?? 'Unknown Song',
              artistName: songData['artistName'] ?? 'Unknown Artist',
              albumArtImagePath:
                  songData['albumArtImagePath'] ?? 'assets/images/default.jpg',
              audioPath: songData['audioPath'] ?? 'assets/music/default.mp3',
            );
          }).toList();
          // แจ้งให้ผู้ใช้รู้ว่า playlist ได้ถูกโหลดแล้ว
        }
        notifyListeners();
      }
    } catch (e) {
      print("Error loading playlist: $e");
    }
  }

  Future<List<String>> getUserPlaylist() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      DocumentSnapshot memberDoc = await FirebaseFirestore.instance
          .collection('member')
          .doc(userId)
          .get();
      if (memberDoc.exists) {
        List<String> playlist = List<String>.from(memberDoc['playlist']);
        return playlist;
      }
    }
    notifyListeners();
    return [];
  }

  void listenToPlaylistUpdates() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('member')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        List playlistData = snapshot['playlist'] ?? [];
        _allSongs = playlistData.map<Song>((songData) {
          return Song(
            songName: songData['songName'] ?? 'Unknown Song',
            artistName: songData['artistName'] ?? 'Unknown Artist',
            albumArtImagePath:
                songData['albumArtImagePath'] ?? 'assets/images/pun.png',
            audioPath:
                songData['audioPath'] ?? 'assets/videos/assets/videos/BF.mp3',
          );
        }).toList();
        notifyListeners();
      }
    });
  }

  Future<void> addToPlaylist(Song newSong) async {
    await addSongToPlaylist(newSong);
    await loadPlaylist(); // โหลด Playlist ใหม่
  }

  Future<void> addSongToPlaylist(Song song) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc = FirebaseFirestore.instance.collection('member').doc(userId);

    await userDoc.update({
      "playlist": FieldValue.arrayUnion([
        {
          "songName": song.songName,
          "artistName": song.artistName,
          "albumArtImagePath": song.albumArtImagePath,
          "audioPath": song.audioPath
        }
      ])
    });
    notifyListeners();
  }

  Future<void> removeSongFromPlaylist(Song song) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc = FirebaseFirestore.instance.collection('member').doc(userId);

    // ลบเพลงออกจาก Playlist ใน Firestore
    await userDoc.update({
      "playlist": FieldValue.arrayRemove([
        {
          "songName": song.songName,
          "artistName": song.artistName,
          "albumArtImagePath": song.albumArtImagePath,
          "audioPath": song.audioPath,
        }
      ])
    });

    // รีเฟรชข้อมูล Playlist
    await loadPlaylist(); // โหลด Playlist ใหม่
  }

  void clearPlaylist() {
    allSongs.clear();
    notifyListeners();
  }

  Future<void> savePlaylist(List<Map<String, String>> songs) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('member').doc(userId).set({
      'songs': songs, // เปลี่ยนจาก List<String> เป็น List<Map<String, String>>
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  List<Song> _allSongs = [];

  bool isInPlaylist(Song song) {
    return _allSongs.contains(song);
  }

  List<Song> get allSongs => _allSongs;

  int? _currentSongIndex;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlaylistProvider() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        notifyListeners();
      }
    });
    listenToDuration();
  }

  void addSongToLibrary(Song song) {
    if (!_allSongs.contains(song)) {
      _allSongs.add(song);
      notifyListeners();
    }
  }

  void removeSongFromLibrary(Song song) {
    if (_allSongs.contains(song)) {
      _allSongs.remove(song);
      notifyListeners();
    }
  }

  Future<void> playMusic(int index) async {
    if (index < 0 || index >= _allSongs.length) return;

    _currentSongIndex = index;
    final String path = _allSongs[_currentSongIndex!].audioPath;

    try {
      await _audioPlayer.stop();
      // ถ้าใช้ setAsset() ให้ตรวจสอบว่า path อยู่ใน assets
      if (path.startsWith('assets/')) {
        await _audioPlayer.setAsset(path); // ใช้สำหรับไฟล์ใน assets
      } else {
        await _audioPlayer.setUrl(path); // ใช้สำหรับไฟล์จาก URL หรือจากที่อื่น
      }
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing music: $e");
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentSongIndex = null;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex == null) return;

    String currentArtist = _allSongs[_currentSongIndex!].artistName;
    int nextSongIndex = _allSongs.indexWhere((song) =>
        song.artistName == currentArtist &&
        _allSongs.indexOf(song) > _currentSongIndex!);

    if (nextSongIndex == -1) {
      nextSongIndex =
          _allSongs.indexWhere((song) => song.artistName == currentArtist);
    }

    if (nextSongIndex != -1) {
      currentSongIndex = nextSongIndex;
    }
  }

  void playPreviousSong() {
    if (_audioPlayer.position.inSeconds > 2) {
      seek(Duration.zero);
      return;
    }

    if (_currentSongIndex == null) return;

    String currentArtist = _allSongs[_currentSongIndex!].artistName;
    int previousSongIndex = _allSongs.lastIndexWhere((song) =>
        song.artistName == currentArtist &&
        _allSongs.indexOf(song) < _currentSongIndex!);

    if (previousSongIndex == -1) {
      previousSongIndex =
          _allSongs.lastIndexWhere((song) => song.artistName == currentArtist);
    }

    if (previousSongIndex != -1) {
      currentSongIndex = previousSongIndex;
    }
  }

  void listenToDuration() {
    _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        _totalDuration = newDuration;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }

  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  Set<int> _favoriteSongs = {};

  bool isFavorite(int? index) {
    if (index == null) return false;
    return _favoriteSongs.contains(index);
  }

  void toggleFavorite(int? index) {
    if (index == null) return;
    if (_favoriteSongs.contains(index)) {
      _favoriteSongs.remove(index);
    } else {
      _favoriteSongs.add(index);
    }
    notifyListeners();
  }

  set currentSongIndex(int? newIndex) {
    if (newIndex != null && (newIndex < 0 || newIndex >= _allSongs.length))
      return;
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      playMusic(newIndex);
    }
    notifyListeners();
  }
}
