import 'package:flutter/services.dart';

class NativePlayerBridge {
  // यह नाम 'com.protube.zero/player' Android की Java फाइल में सेम होना चाहिए
  static const platform = MethodChannel('com.protube.zero/player');

  // वीडियो प्ले करने का फंक्शन
  static Future<void> playVideo(String videoUrl) async {
    try {
      await platform.invokeMethod('playVideo', {"url": videoUrl});
    } on PlatformException catch (e) {
      print("Failed to call Native Player: '${e.message}'.");
    }
  }
}
