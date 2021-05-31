import 'dart:async';
import 'package:flutter/services.dart';

class ScreenshotCallback {
  static const MethodChannel _channel =
      const MethodChannel('screenshot_callback');

  static const String FLUTTER_START_SCREENSHOT = "startListenScreenshot";
  static const String FLUTTER_STOP_SCREENSHOT = "stopListenScreenshot";

  static const String NATIVE_SCREENSHOT_CALLBACK = "screenshotCallback";
  static const String NATIVE_DENIED_PERMISSION = "deniedPermission";

  final List<ScreenshotCallbackData> _listTempData = <ScreenshotCallbackData>[];

  static final ScreenshotCallback instance = ScreenshotCallback._();

  final StreamController<List<ScreenshotCallbackData>>
      streamCtrlDataScreenshot =
      StreamController<List<ScreenshotCallbackData>>.broadcast();

  ScreenshotCallback._() {
    _channel.setMethodCallHandler(methodCallHandler);
  }

  Future<dynamic> methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case NATIVE_SCREENSHOT_CALLBACK:
        {
          String path = call.arguments;
          print("Screenshot callback Path: $path");
          _listTempData.add(ScreenshotCallbackData(
              id: _listTempData.length + 1,
              isPermission: true,
              path: path,
              error: ''));
          streamCtrlDataScreenshot.sink.add(_listTempData);
        }
        break;
      case NATIVE_DENIED_PERMISSION:
        {
          print("Screenshot callback, no permission");
          streamCtrlDataScreenshot.sink.add(<ScreenshotCallbackData>[
            ScreenshotCallbackData(
                id: 0,
                isPermission: false,
                path: '',
                error: 'Screenshot callback, no permission')
          ]);
        }
        break;
    }
    // return returnResult();
  }

  void startScreenshot() async {
    await _channel.invokeMethod(FLUTTER_START_SCREENSHOT);
  }

  void stopScreenshot() async {
    streamCtrlDataScreenshot.close();
    await _channel.invokeMethod(FLUTTER_STOP_SCREENSHOT);
  }

  List<ScreenshotCallbackData> getData() {
    return _listTempData;
  }

  void clearData() {
    _listTempData.clear();
  }
}

class ScreenshotCallbackData {
  final int id;
  final String path;
  final bool isPermission;
  final String error;

  ScreenshotCallbackData(
      {this.id = 1,
      this.path = '',
      this.isPermission = false,
      this.error = 'error'});
}
