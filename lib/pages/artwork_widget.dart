import 'dart:async';

import 'package:audio_app/pages/lyrics/lyrics_page.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ArtworkWidget extends ConsumerStatefulWidget {
  const ArtworkWidget({super.key});

  @override
  _ArtworkWidgetState createState() => _ArtworkWidgetState();
}

class _ArtworkWidgetState extends ConsumerState<ArtworkWidget> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  late StreamSubscription<int?> indexStream;

  @override
  void dispose() {
    indexStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel song = songs![songIndex];

    indexStream = player.currentIndexStream.listen((p) {
      if (p != songIndex) {
        setState(() {
          songIndex = p!;
          song = songs[songIndex];
        });
      }
    });

    return Stack(
      children: [
        QueryArtworkWidget(
          artworkHeight: 350,
          artworkWidth: double.infinity,
          size: 900,
          controller: audioQuery,
          id: song.id,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.zero,
          nullArtworkWidget: Container(
            color: Colors.white60,
            height: 350,
            width: double.infinity,
            child: const Icon(
              PhosphorIconsDuotone.musicNote,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LyricsPage(song);
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(166, 170, 167, .75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    PhosphorIconsBold.waveform,
                    color: Colors.white,
                    // size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
