import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenshot_callback/flutter_screenshot_callback.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _imagePath = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initCallback();
  }

  // void initCallback() {
  //   ScreenshotCallback.instance.startScreenshot();
  //   ScreenshotCallback.instance.screenshotCallbackStream.stream.listen((event) {
  //     print(event);
  //     setState(() {
  //       _imagePath = event.first.path;
  //     });
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // ScreenshotCallback.instance.stopScreenshot();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Image.file(File(_imagePath)),
        ),
      ),
    );
  }
}
