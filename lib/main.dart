import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import './navigations/tabbar.dart';
import './model/playlist_provider.dart';
import './model/music_provider.dart';
import 'components/music_player_bar.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PlaylistProvider()),
    ChangeNotifierProvider(create: (context) => MusicProvider())
  ], child: MyWidget()));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white10,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
          )),
      home: Tabbar(),
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          Positioned(
            left: 10,
            right: 10,
            bottom: 65,
            child: Consumer2<MusicProvider, PlaylistProvider>(
              builder: (context, musicProvider, playlistProvider, child) {
                return musicProvider.currentSongIndex != null ||
                        playlistProvider.currentSongIndex != null
                    ? MusicPlayerBar() //currentSongIndex ถูกเซ็ตค่า
                    : SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
