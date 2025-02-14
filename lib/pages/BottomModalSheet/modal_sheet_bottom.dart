import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ModalSheetBottom extends StatefulWidget {
  const ModalSheetBottom(
      this.id, this.title, this.artist, this.playlist, this.song, this.tapIndex,
      {super.key});
  final int id;
  final String title;
  final String artist;
  final ConcatenatingAudioSource playlist;
  final SongModel song;
  final int tapIndex;

  @override
  State<ModalSheetBottom> createState() => _ModalSheetBottomState();
}

class _ModalSheetBottomState extends State<ModalSheetBottom> {
  late OnAudioQuery audioQuery;
  late Future<Uint8List?> artworkFuture;

  List choices = const [
    {
      'title': 'Size',
      'description': 'Sizes',
    },
    {
      'title': 'Format',
      'description': 'Sizes',
    },
    {
      'title': 'Bitrate',
      'description': 'Sizes',
    },
    {
      'title': 'Sampling rate',
      'description': 'Sizes',
    },
  ];

  @override
  void initState() {
    audioQuery = OnAudioQuery();
    artworkFuture = audioQuery.queryArtwork(widget.id, ArtworkType.AUDIO);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.artist,
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

            // QueryArtworkWidget(
            //   controller: audioQuery,
            //   id: widget.id,
            //   type: ArtworkType.AUDIO,
            //   artworkBorder: BorderRadius.circular(10),
            //   nullArtworkWidget: Container(
            //     height: 50,
            //     width: 50,
            //     color: Colors.white60,
            //     child: const Icon(PhosphorIconsDuotone.musicNote,
            //         color: Colors.white),
            //   ),
            // ),
          ),
          trailing: GestureDetector(
            onTap: () {},
            child: const Icon(
              PhosphorIconsFill.heart,
              color: Color.fromRGBO(218, 218, 218, 1),
            ),
          ),
        ),
        const Divider(
          color: Colors.white24,
        ),
        ListTile(
          onTap: () {
            print(widget.playlist.length);
            print(widget.song);

            widget.playlist.insert(
              widget.tapIndex + 1,
              AudioSource.uri(
                Uri.parse(widget.song.uri!),
                tag: MediaItem(
                  // Specify a unique ID for each media item:
                  id: widget.song.id.toString(),
                  // Metadata to display in the notification:
                  album: widget.song.album,
                  title: widget.song.title,
                  artUri: Uri.parse('https://placehold.co/600x400'),
                ),
              ),
            );
            print('added');
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Play next",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsFill.arrowUUpRight,
            color: Colors.white,
            size: 20,
          ),
        ),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Go to album",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsFill.vinylRecord,
            color: Colors.white,
            size: 20,
          ),
        ),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Go to artist",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsRegular.user,
            color: Colors.white,
            size: 20,
          ),
        ),
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                    title: const Text('Details'),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'File path',
                            style: TextStyle(color: Colors.white60),
                          ),
                          Text('${widget.song.uri}'),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'File Name',
                            style: TextStyle(color: Colors.white60),
                          ),
                          Text('${widget.song.displayName}'),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        // textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsFill.info,
            color: Colors.white,
            size: 20,
          ),
        ),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Share",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsFill.shareNetwork,
            color: Colors.white,
            size: 20,
          ),
        ),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text(
            "Delete from device",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(
            PhosphorIconsFill.trash,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}
