// ignore_for_file: unused_local_variable, unrelated_type_equality_checks

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musikapp/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _getStoragePermission();
  }

  Future<void> _getStoragePermission() async {
    final storageGranted = await Permission.storage.isGranted;

    bool checkPermission = storageGranted == ServiceStatus.enabled;

    final status = await Permission.storage.request();

    if (status == PermissionStatus.denied) {
      Permission.storage.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(audioPlayer: audioPlayer),
    );
  }
}
