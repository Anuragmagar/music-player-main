import 'package:audio_app/pages/BottomMiniplayer/bottom_playerbutton_state.dart';
import 'package:audio_app/pages/BottomMiniplayer/bottom_linear_progress.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomMiniplayerContainer extends ConsumerStatefulWidget {
  const BottomMiniplayerContainer({super.key});

  @override
  _BottomMiniplayerContainerState createState() =>
      _BottomMiniplayerContainerState();
}

class _BottomMiniplayerContainerState
    extends ConsumerState<BottomMiniplayerContainer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    // final currentIndex = ref.watch(currentIndexProvider);
    // SongModel selectedSong = ref.watch(currentPlayingMusicProvider);

    // player.currentIndexStream.listen((p) {
    //   if (p != currentIndex) {
    //     // selectedSong = songs![currentIndex];
    //     ref.read(currentIndexProvider.notifier).update((state) => p!);
    //     setState(() {
    //       selectedSong = ref.watch(currentPlayingMusicProvider);
    //     });
    //   }
    // });
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: QueryArtworkWidget(
                  controller: audioQuery,
                  id: selectedSong.id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(10),
                  nullArtworkWidget: Container(
                    color: Colors.black,
                    height: 50,
                    width: 50,
                    child: const Icon(PhosphorIconsDuotone.musicNote),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          selectedSong.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          selectedSong.artist.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const BottomPlayerbuttonState(),
              // IconButton(
              //   icon: const Icon(Icons.close),
              //   onPressed: () {
              //     context.read(selectedVideoProvider).state =
              //         null;
              //   },
              // ),
            ],
          ),
        ),
        const BottomLinearProgress(),
      ],
    );
  }
}
