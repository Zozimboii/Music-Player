import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../songs/song_data.dart';

class MusicProvider extends ChangeNotifier {
  final List<Song> _allSongs = [
    Song(
        songName: "DAY ONE",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/dayone.mp3"),
    Song(
        songName: "BF",
        aristName: "PUN x URBOYTJ",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/BF.mp3"),
    Song(
        songName: "I Just Wanna Know",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/IJustWannaKnow.mp3"),
    Song(
        songName: "Lonely In The City",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/LonelyInTheCity.mp3"),
    Song(
        songName: "Obsessed x Jaonaay",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/Obsessed.mp3"),
    Song(
        songName: "Goodbye",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/dayone.mp3"),
    Song(
        songName: "รอที่เส้นขอบฟ้า",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/Stay.mp3"),
    Song(
        songName: "Therapist",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/Therapist.mp3"),
    Song(
        songName: "เค้าว่า",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/เค้าว่า.mp3"),
    Song(
        songName: "Stay",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/Stay.mp3"),
    Song(
        songName: "ที่เดิม",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/ที่เดิม.mp3"),
    Song(
        songName: "นิทานในฝัน",
        aristName: "PUN",
        albumArtImagePath: "assets/images/albumpun.jpg",
        audiPath: "assets/videos/นิทานในฝัน.mp3"),
    Song(
        songName: "ดอกไม้ที่รอฝน",
        aristName: "THE TOYS x NONT TANONT",
        albumArtImagePath: "assets/images/albumnont.jpg",
        audiPath: "assets/videos/THE TOYS x NONT TANONT - ดอกไม้ที่รอฝน.mp3"),
    Song(
        songName: "โต๊ะริม",
        aristName: "NONT TANONT",
        albumArtImagePath: "assets/images/albumnont.jpg",
        audiPath: "assets/videos/NONT TANONT - โต๊ะริม.mp3"),
    Song(
        songName: "จำนน",
        aristName: "NONT TANONT",
        albumArtImagePath: "assets/images/albumnont.jpg",
        audiPath: "assets/videos/NONT TANONT - จำนน.mp3"),
    Song(
        songName: "พิง",
        aristName: "NONT TANONT",
        albumArtImagePath: "assets/images/albumnont.jpg",
        audiPath: "assets/videos/OFFICIAL MV - นนท ธนนท.mp3"),
    Song(
        songName: "วายร้าย",
        aristName: "URBOYTJ x SD Thaitanium",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJวายร้ายFtSD Thaitanium.mp3"),
    Song(
        songName: "หาไม่ได้",
        aristName: "URBOYTJ x HYE PAPER PLANES",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "aassets/videos/URBOYTJ - หาไมได  Ft HYE PAPER PLANES - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "ล้มทับ (FALLOUT)",
        aristName: "URBOYTJ",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - ลมทบ FALLOUT - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "ไม่ติด (DOUBLE)",
        aristName: "URBOYTJ x GAVIN_D",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - ไมตด DOUBLE Ft GAVIND - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "พ่อแม่ไม่สั่งสอน (SHH!)",
        aristName: "URBOYTJ x OG BOBBY",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - พอแมไมสงสอน SHH Ft OG BOBBY - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "ประโยคบอกเล่า (NONSENSE)",
        aristName: "URBOYTJ",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - ประโยคบอกเลา NONSENSE - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "ถามคำ",
        aristName: "URBOYTJ",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - ถามคำ QUESTION - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "คนขี้เหงา",
        aristName: "URBOYTJ",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - คนขเหงา URMAN- OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "คิดไม่ถึง (EMPTY)",
        aristName: "URBOYTJ x MAIYARAP",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - คดไมถง EMPTY FtMAIYARAP - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "คู่กัน (TOGETHER)",
        aristName: "URBOYTJ x SINGTO NUMCHOK",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - คกน TOGETHER Ft SINGTO NUMCHOK - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "การันตี (GUARANTEE)",
        aristName: "URBOYTJ x GUARANTEE",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - การนต GUARANTEE - OFFICIAL VISUALIZER.mp3"),
    Song(
        songName: "SELFMADE",
        aristName: "URBOYTJ x VIOLETTE WAUTIER",
        albumArtImagePath: "assets/images/TJ2.jpg",
        audiPath: "assets/videos/URBOYTJ - SELFMADE FTVIOLETTE WAUTIER - OFFICIAL VISUALIZER.mp3"),
  ];
  int? _currentSongIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  MusicProvider() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        notifyListeners();
      }
    });
    listenToDuration();
  }

  void playMusic() async {
    if (_currentSongIndex == null) return;

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
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      String currentArtist = _allSongs[_currentSongIndex!].aristName;

      int nextSongIndex = _allSongs.indexWhere((song) =>
          song.aristName == currentArtist &&
          _allSongs.indexOf(song) > _currentSongIndex!);

      if (nextSongIndex == -1) {
        nextSongIndex =
            _allSongs.indexWhere((song) => song.aristName == currentArtist);
      }

      currentSongIndex = nextSongIndex;
    }
    notifyListeners();
  }

  void playPreviousSong() {
    if (_audioPlayer.position.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex != null) {
        String currentArtist = _allSongs[_currentSongIndex!].aristName;

        if (_currentSongIndex! > 0) {
          String previousArtist = _allSongs[_currentSongIndex! - 1].aristName;

          if (currentArtist == previousArtist) {
            currentSongIndex = _currentSongIndex! - 1;
          }
        } else {
          for (int i = _allSongs.length - 1; i >= 0; i--) {
            if (_allSongs[i].aristName == currentArtist) {
              currentSongIndex = i;
              break;
            }
          }
        }
      }
    }
    notifyListeners();
  }

  // ฟังก์ชันฟังการเปลี่ยนแปลงของตำแหน่งและระยะเวลา
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

  List<Song> get allSongs => _allSongs;

  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
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
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      playMusic();
    }
    notifyListeners();
  }
}
