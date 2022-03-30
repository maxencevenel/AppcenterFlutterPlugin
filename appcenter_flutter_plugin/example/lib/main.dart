import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:appcenter_flutter_plugin/appcenter_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "Unknown";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await AppCenter.startAsync(
        appSecretAndroid: "e46523bf-3fb3-43ef-b8f6-93125b1cbfc8",
        appSecretIOS: "1c7e6ff1-8b96-4b3f-ace3-967869ec996e",
        enableAnalytics: true, // Defaults to true
        enableCrashes: true, // Defaults to true
      );

      // await AppCenter.trackErrorAsync("test Error");
      // await AppCenter.trackErrorAsync("test Error With properties", {"KeyErrorTest":"ValueErrorTest"} );
      // AppCenter.trackEventAsync('my package event', <String, String> {
      //   'Key': 'Value',
      //   'Key1': 'Value1',
      // });

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    var a = [12];
    var test = a[3];
    throw Exception("coucou");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
