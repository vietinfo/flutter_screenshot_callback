import 'dart:async';
import 'package:flutter/services.dart';

class ScreenshotCallback {
  static const MethodChannel _channel =
      const MethodChannel('screenshot_callback');

  static const String FLUTTER_START_SCREENSHOT = "startListenScreenshot";
  static const String FLUTTER_STOP_SCREENSHOT = "stopListenScreenshot";

  static const String NATIVE_SCREENSHOT_CALLBACK = "screenshotCallback";
  static const String NATIVE_DENIED_PERMISSION = "deniedPermission";

  late StreamController<List<ScreenshotCallbackData>> screenshotCallbackStream;

  final List<ScreenshotCallbackData> _listTempData = <ScreenshotCallbackData>[];

  static ScreenshotCallback instance = ScreenshotCallback._();

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
          screenshotCallbackStream.sink.add(_listTempData);
        }
        break;
      case NATIVE_DENIED_PERMISSION:
        {
          print("Screenshot callback, no permission");
          screenshotCallbackStream.sink.add(<ScreenshotCallbackData>[
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
    screenshotCallbackStream =
        StreamController<List<ScreenshotCallbackData>>.broadcast();
    await _channel.invokeMethod(FLUTTER_START_SCREENSHOT);
  }

  void stopScreenshot() async {
    screenshotCallbackStream.close();
    await _channel.invokeMethod(FLUTTER_STOP_SCREENSHOT);
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
