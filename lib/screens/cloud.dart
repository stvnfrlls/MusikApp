import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musikapp/players/test.dart';

import '../players/cloud_player.dart';

class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;
  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  final CollectionReference _referenceSong =
      FirebaseFirestore.instance.collection('songs');
  late Future<QuerySnapshot> _futureData;
  List<Map> _songDetails = [];
  List<Map> listItems = [];

  List<Map> allSong = [];

  @override
  void initState() {
    super.initState();

    _futureData = _referenceSong.get();
    _futureData.then((value) {
      setState(() {
        _songDetails = parseData(value);
      });
    });
  }

  void navigateToCloudPlayer(
      BuildContext context, List<Map<dynamic, dynamic>> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestPlayer(
          data: data,
          audioPlayer: widget.audioPlayer,
        ),
      ),
    );
  }

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listdocs = querySnapshot.docs;
    listItems = listdocs
        .map((e) => {
              'songname': e['songname'],
              'artistname': e['artistname'],
              'song_url': e['song_url'],
              'img_url': e['img_url'],
            })
        .toList();
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _songDetails.isEmpty
          ? const Center(
              child: Text('No Songs Available'),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 5, left: 10),
              child: Column(
                children: [
                  headerTitle(),
                  buildListViewHorizontal(_songDetails),
                  buildListView(_songDetails),
                ],
              ),
            ),
    );
  }

  Align headerTitle() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          const Text(
            'Trending Music',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 45),
              child: TextButton.icon(
                onPressed: () {
                  navigateToCloudPlayer(context, _songDetails);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                label: const Text(
                  'Play All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ))
        ],
      ),
    );
  }

  SizedBox buildListViewHorizontal(List<Map<dynamic, dynamic>> songDetails) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: songDetails.length,
          itemBuilder: (context, index) {
            Map thisItem = songDetails[index];
            allSong.addAll(songDetails);
            return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(thisItem['img_url']),
                      ),
                    ),
                  ),
                ]));
          }),
    );
  }

  Padding buildListView(List<Map<dynamic, dynamic>> songDetails) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        child: ListView.builder(
            itemCount: songDetails.length,
            itemBuilder: (context, index) {
              Map thisItem = songDetails[index];
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: thisItem['img_url'],
                  height: 100,
                  width: 50,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.music_note_rounded),
                ),
                title: Text(thisItem['songname']),
                subtitle: Text(thisItem['artistname']),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CloudPlayer(
                          artistname: thisItem['artistname'],
                          imgURL: thisItem['img_url'],
                          songURL: thisItem['song_url'],
                          songname: thisItem['songname'],
                          audioPlayer: widget.audioPlayer,
                        ),
                      ));
                },
              );
            }),
      ),
    );
  }
}
