import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mic_volume/mic_volume.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _micVolume = 0.0;
  final _micVolumePlugin = MicVolume();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _micVolumePlugin.startCheckVolume().then((_) {
      Timer.periodic(const Duration(seconds: 1), (_) async {
        try {
          print("get");
          _micVolume = await _micVolumePlugin.getMicVolume() ?? 0.0;
        } on PlatformException {
          _micVolume = 0.0;
          print("fail");
        }
        setState(() {});
      });
    });

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _micVolume = micVolume;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_micVolume\n'),
        ),
      ),
    );
  }
}
