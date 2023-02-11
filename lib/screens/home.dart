import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musikapp/screens/cloud.dart';
import 'package:musikapp/screens/local.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      OnlineScreen(
        audioPlayer: widget.audioPlayer,
      ),
      LocalScreen(
        audioPlayer: widget.audioPlayer,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MusikApp'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () => exit(0), icon: const Icon(Icons.close))
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Online',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_android),
              label: 'Phone',
            ),
          ]),
    );
  }
}
