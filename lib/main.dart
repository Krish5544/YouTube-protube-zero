import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const ProTubeApp());
}

class ProTubeApp extends StatelessWidget {
  const ProTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const YouTubeHomeScreen(),
    );
  }
}
