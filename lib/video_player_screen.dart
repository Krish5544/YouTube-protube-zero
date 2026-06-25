import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const platform = MethodChannel('com.protube.zero/player');

  @override
  void initState() {
    super.initState();
    // जैसे ही स्क्रीन खुलेगी, हम Android (Native) को बोलेंगे कि वीडियो प्ले करो
    _startNativePlayer();
  }

  Future<void> _startNativePlayer() async {
    try {
      await platform.invokeMethod('playVideo', {"url": widget.videoUrl});
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        // यहाँ हम अपना वो Native View बुला रहे हैं जो हमने MainActivity में रजिस्टर किया था
        child: AndroidView(
          viewType: 'native-player-view',
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ),
    );
  }
}
