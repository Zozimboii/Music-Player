class Song{
    final String songName;
    final String aristName;
    final String albumArtImagePath;
    final String audiPath;
    

    Song({
        required this.songName,
        required this.aristName,
        required this.albumArtImagePath,
        required this.audiPath,
    });


@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song &&
        other.songName == songName &&
        other.aristName == aristName &&
        other.audiPath == audiPath;
  }

  @override
  int get hashCode => songName.hashCode ^ aristName.hashCode ^ audiPath.hashCode;
}