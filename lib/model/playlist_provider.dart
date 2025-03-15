import 'package:flutter/material.dart';
import '../songs/song_data.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistProvider extends ChangeNotifier {
  List<Song> _allSongs = [
    
  ];

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
    final String path = _allSongs[_currentSongIndex!].audiPath;

    await _audioPlayer.stop();
    await _audioPlayer.setAsset(path);
    await _audioPlayer.play();

    _isPlaying = true;
    notifyListeners();
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

    String currentArtist = _allSongs[_currentSongIndex!].aristName;
    int nextSongIndex = _allSongs.indexWhere((song) =>
        song.aristName == currentArtist &&
        _allSongs.indexOf(song) > _currentSongIndex!);

    if (nextSongIndex == -1) {
      nextSongIndex =
          _allSongs.indexWhere((song) => song.aristName == currentArtist);
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

    String currentArtist = _allSongs[_currentSongIndex!].aristName;
    int previousSongIndex = _allSongs.lastIndexWhere((song) =>
        song.aristName == currentArtist &&
        _allSongs.indexOf(song) < _currentSongIndex!);

    if (previousSongIndex == -1) {
      previousSongIndex =
          _allSongs.lastIndexWhere((song) => song.aristName == currentArtist);
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
    if (newIndex != null && (newIndex < 0 || newIndex >= _allSongs.length)) return;
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      playMusic(newIndex);
    }
    notifyListeners();
  }
}
