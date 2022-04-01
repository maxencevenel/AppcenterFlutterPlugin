import 'package:flutter/material.dart';
import 'dart:async';

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
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await AppCenter.startAsync(
      appSecretAndroid: "**********",
      appSecretIOS: "**********",
      enableAnalytics: true, // Defaults to true
      enableCrashes: true, // Defaults to true
    );

    // await AppCenter.trackErrorAsync("test Error");
    // await AppCenter.trackErrorAsync("test Error With properties", {"KeyErrorTest":"ValueErrorTest"} );
    // AppCenter.trackEventAsync('my package event', <String, String> {
    //   'Key': 'Value',
    //   'Key1': 'Value1',
    // });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('AppCenter plugin'),
        ),
      ),
    );
  }
}
