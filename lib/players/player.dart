// ignore_for_file: avoid_print, unused_field, no_leading_underscores_for_local_identifiers, unused_element, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musikapp/widgets/player_buttons.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({
    super.key,
    required this.songModelList,
    required this.audioPlayer,
    required this.songIndex,
  });

  final List<SongModel> songModelList;
  final AudioPlayer audioPlayer;
  final int songIndex;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  final _audioQuery = OnAudioQuery();
  List<AudioSource> songList = [];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    if (mounted) {}
    playSong();
    listentoSongIndex();
  }

  void playSong() {
    try {
      for (var element in widget.songModelList) {
        songList.add(AudioSource.uri(
          Uri.parse(element.uri!),
          tag: MediaItem(
            id: '${element.id}',
            album: "${element.album}",
            title: element.displayNameWOExt,
            artUri: Uri.parse('https://example.com/albumart.jpg'),
          ),
        ));
      }
      widget.audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: songList));
      widget.audioPlayer.play();
    } on Exception {
      print("Cannot Parse Song");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
    listentoSongIndex();
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  void listentoSongIndex() {
    widget.audioPlayer.currentIndexStream.listen((event) {
      setState(() {
        if (event != null) {
          currentIndex = event;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("MusikApp"),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: Icon(
                Icons.music_note_rounded,
                size: 200,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Text(
                  widget.songModelList[currentIndex].title == "<unknown>"
                      ? widget.songModelList[currentIndex].displayNameWOExt
                      : widget.songModelList[currentIndex].title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.songModelList[currentIndex].artist.toString() ==
                      "<unknown>"
                  ? "Unknown Artist"
                  : widget.songModelList[currentIndex].artist.toString(),
              maxLines: 1,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Text(_position.toString().split(".")[0]),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey[700],
                      min: const Duration(microseconds: 0).inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          changeToSeconds(value.toInt());
                          value = value;
                        });
                      },
                    ),
                  ),
                  Text(_duration.toString().split(".")[0]),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PlayerButtons(audioPlayer: widget.audioPlayer)),
            ),
            const SizedBox(
              height: 90.0,
            ),
          ],
        ),
      ),
    );
  }
}
