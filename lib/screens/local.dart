// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../players/player.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;
  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final _audioQuery = OnAudioQuery();
  List<SongModel> allSong = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, song) {
            if (song.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (song.data!.isEmpty) {
              return const Center(
                child: Text("No Songs Found"),
              );
            }
            return Stack(
              children: [
                ListView.builder(
                  itemCount: song.data!.length,
                  itemBuilder: (context, index) {
                    allSong.addAll(song.data!);
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.data![index].id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.zero,
                        nullArtworkWidget: const Icon(Icons.music_note),
                      ),
                      title: Text(song.data![index].title),
                      subtitle: Text(
                        song.data![index].artist.toString() == "<unknown>"
                            ? "Unknown Artist"
                            : song.data![index].artist.toString(),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayer(
                                songModelList: [song.data![index]],
                                audioPlayer: widget.audioPlayer,
                                songIndex: index,
                              ),
                            ));
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPlayer(
                              songModelList: allSong,
                              audioPlayer: widget.audioPlayer,
                              songIndex: 0,
                            ),
                          ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 15, bottom: 10),
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
