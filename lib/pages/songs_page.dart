import 'package:audio_app/pages/SongsPage/song_tile.dart';
import 'package:audio_app/pages/Sorting.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  // State<SongsPage> createState() => _SongsPageState();
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  // Indicate if application has permission to the library.
  int songsCount = 0;
  // Main method.
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();

    // requestPermission();
    // checkPermissionStatus().then((value) {
    //   print(value);
    // });
    getSongs();
  }

  // Future<bool> checkPermissionStatus() async {
  //   final permission = Permission.storage;

  //   return await permission.status.isGranted;
  // }

  // Future<void> requestPermission() async {
  //   final permission = Permission.storage;

  //   if (await permission.isDenied) {
  //     await permission.request();
  //   }
  // }

  // Future<void> requestStoragePermission() async {
  //   if (await Permission.storage.isPermanentlyDenied) {
  //     // The user opted to never again see the permission request dialog for this
  //     // app. The only way to change the permission's status now is to let the
  //     // user manually enables it in the system settings.
  //     openAppSettings();
  //   }
  //   if (await Permission.storage.request().isGranted) {
  //     // Permission granted, proceed with accessing the audio files
  //     getSongs();
  //   } else {
  //     // Permission denied, show a message to the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please grant storage permission to use the app'),
  //       ),
  //     );
  //   }
  // }

  // checkAndRequestPermissions({bool retry = true}) async {
  //   // The param 'retryRequest' is false, by default.
  //   _hasPermission = await audioQuery.checkAndRequest(
  //     retryRequest: retry,
  //   );

  //   // Only call update the UI if application has all required permissions.
  //   _hasPermission
  //       ? setState(() {})
  //       : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content:
  //               const Text('Please grant storage permission to use the app'),
  //           action: SnackBarAction(
  //             label: 'Grant',
  //             onPressed: () {
  //               checkAndRequestPermissions(retry: true);
  //             },
  //           )));
  // }

  getSongs() async {
    // checkAndRequestPermissions();

    List<SongModel> audios = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> recentAudios = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> filteredAudios = [];
    List<SongModel> filteredRecentAudios = [];
    for (var audio in recentAudios) {
      if (audio.duration != null && audio.duration! > 60000) {
        filteredRecentAudios.add(audio);
      }
    }
    for (var audio in audios) {
      if (audio.duration != null && audio.duration! > 60000) {
        filteredAudios.add(audio);
      }
    }
    ref.read(songListProvider.notifier).update((state) => filteredAudios);
    ref
        .read(recentSongListProvider.notifier)
        .update((state) => filteredRecentAudios);
    ref
        .read(songsCountProvider.notifier)
        .update((state) => filteredAudios.length);
  }

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songListProvider);
    // SongModel song = songs![songIndex];

    if (songs == null || songs.isEmpty) {
      return const Center(child: Text('No songs available in your device'));
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Sorting(),
        ),
        const SizedBox(height: 10),
        Expanded(
          // height: 200,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: ((context, index) {
              if (songs[index].duration! < 60000) {
                return const SizedBox.shrink();
              }

              return SongTile(index: index);
            }),
          ),
        )
      ],
    );
  }
}
