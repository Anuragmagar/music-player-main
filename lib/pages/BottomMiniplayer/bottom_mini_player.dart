import 'package:audio_app/pages/BottomMiniplayer/bottom_miniplayer_container.dart';
import 'package:audio_app/pages/player_screen.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomMiniPlayer extends ConsumerStatefulWidget {
  const BottomMiniPlayer({super.key});

  @override
  _BottomMiniPlayerState createState() => _BottomMiniPlayerState();
}

class _BottomMiniPlayerState extends ConsumerState<BottomMiniPlayer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final songs = ref.read(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel selectedSong = songs![songIndex];

    // SongModel song = songs![songIndex];
    player.currentIndexStream.listen((p) {
      if (p != songIndex) {
        setState(() {
          selectedSong = songs[songIndex];
        });
      }
    });

    return GestureDetector(
      onTap: () {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromRGBO(24, 24, 26, 1),
          systemNavigationBarDividerColor: Color.fromRGBO(24, 24, 26, 1),
        ));
        Get.to(() => PlayerScreen(selectedSong),
            transition: Transition.downToUp);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(42, 41, 49, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        child: const BottomMiniplayerContainer(),
      ),
    );
  }
}
