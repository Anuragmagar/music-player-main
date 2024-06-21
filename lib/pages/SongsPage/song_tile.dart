import 'dart:typed_data';

import 'package:audio_app/pages/BottomModalSheet/modal_sheet_bottom.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SongTile extends ConsumerStatefulWidget {
  final int index;
  const SongTile({required this.index, super.key});

  @override
  _SongTileState createState() => _SongTileState();
}

String formatDuration(int? milliseconds) {
  if (milliseconds == null) {
    return 'Unknown duration';
  }

  Duration duration = Duration(milliseconds: milliseconds);
  String minutes = '${duration.inMinutes}'.padLeft(2, '0');
  String seconds = '${duration.inSeconds % 60}'.padLeft(2, '0');
  return '$minutes:$seconds';
}

class _SongTileState extends ConsumerState<SongTile> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  late Future<Uint8List?> artworkFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final songs = ref.watch(songListProvider);
    if (songs != null && songs.isNotEmpty) {
      artworkFuture =
          audioQuery.queryArtwork(songs[widget.index].id, ArtworkType.AUDIO);
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    // int? songIndex = player.currentIndex;
    // SongModel song = songs![songIndex];

    if (songs == null) {
      return const Center(child: Text('No songs available in your device'));
    }

    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      children: songs
          .map(
            (song) => AudioSource.uri(
              Uri.parse(song.uri!),
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: song.id.toString(),
                // Metadata to display in the notification:
                album: song.album,
                title: song.title,
                artUri: Uri.parse('https://placehold.co/600x400'),
              ),
            ),
          )
          .toList(),
    );

    return ListTile(
      onTap: () async {
        ref.read(isMiniplayerOpenProvider.notifier).update((state) => true);
        player.setAudioSource(playlist,
            initialIndex: widget.index, initialPosition: Duration.zero);
        player.play();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        songs[widget.index].title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${songs[widget.index].artist}・${formatDuration(songs[widget.index].duration)}',
        style: const TextStyle(color: Color.fromRGBO(218, 218, 218, 1)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: FutureBuilder<Uint8List?>(
          future: artworkFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(
                snapshot.data!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              );
            } else {
              return Container(
                height: 50,
                width: 50,
                color: Colors.white60,
                child: const Icon(
                  PhosphorIconsDuotone.musicNote,
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
      trailing: IconButton(
        icon: const Icon(
          PhosphorIconsFill.dotsThreeOutlineVertical,
          color: Color.fromRGBO(218, 218, 218, 1),
        ),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: const Color.fromRGBO(42, 41, 49, 1),
            context: context,
            builder: (BuildContext context) {
              return ModalSheetBottom(
                songs[widget.index].id,
                songs[widget.index].title,
                songs[widget.index].artist ?? "Unknown Artist",
                playlist,
                songs[widget.index],
                widget.index,
              );
            },
          );
        },
        padding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
