class Song{
    final String songName;
    final String artistName;
    final String albumArtImagePath;
    final String audioPath;
    

    Song({
        required this.songName,
        required this.artistName,
        required this.albumArtImagePath,
        required this.audioPath,
    });


@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song &&
        other.songName == songName &&
        other.artistName == artistName &&
        other.audioPath == audioPath;
  }

  @override
  int get hashCode => songName.hashCode ^ artistName.hashCode ^ audioPath.hashCode;
}