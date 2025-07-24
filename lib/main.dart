import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_mp3_2/main_view.dart';
import 'package:youtube_mp3_2/permission_request.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget{
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    bool granted = await requestStoragePermission();
    if (granted) {
      // Already granted
      return;
    }
    else {
      await requestStoragePermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainView()
    );
  }
}
