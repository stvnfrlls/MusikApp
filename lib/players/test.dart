// ignore_for_file: avoid_print, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musikapp/widgets/player_buttons.dart';

class TestPlayer extends StatefulWidget {
  const TestPlayer({
    super.key,
    required this.data,
    required this.audioPlayer,
  });
  final List<Map<dynamic, dynamic>> data;
  final AudioPlayer audioPlayer;
  @override
  State<TestPlayer> createState() => _TestPlayerState();
}

class _TestPlayerState extends State<TestPlayer> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = true;
  List<AudioSource> songList = [];
  List<String> songname = [];
  List<String> artistname = [];
  List<String> imgurl = [];
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
      for (var element in widget.data) {
        songList.add(AudioSource.uri(Uri.parse(element['song_url'])));
        songname.add(element['songname']);
        artistname.add(element['artistname']);
        imgurl.add(element['img_url']);
      }
      widget.audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: songList));
      widget.audioPlayer.play();
      _isPlaying = true;
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
        title: const Text('Stream'),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CachedNetworkImage(
                imageUrl: imgurl[currentIndex],
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.40,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(
                  Icons.music_note_rounded,
                  size: 200,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              songname[currentIndex].toString(),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              artistname[currentIndex].toString(),
              maxLines: 1,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
            PlayerButtons(audioPlayer: widget.audioPlayer)
          ],
        ),
      ),
    );
  }
}
