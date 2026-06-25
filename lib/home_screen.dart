import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeHomeScreen extends StatefulWidget {
  const YouTubeHomeScreen({super.key});

  @override
  State<YouTubeHomeScreen> createState() => _YouTubeHomeScreenState();
}

class _YouTubeHomeScreenState extends State<YouTubeHomeScreen> {
  final YoutubeExplode _yt = YoutubeExplode();
  List<Video> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrendingVideos();
  }

  // 🌟 ऐप खुलते ही सर्वर से डेटा लाने का काम यहाँ शुरू होगा 🌟
  Future<void> _fetchTrendingVideos() async {
    try {
      // अभी के लिए हम ट्रेंडिंग वीडियोज़ ला रहे हैं
      var playlist = await _yt.playlists.get('PLrEnWoR732-QH6-3i07h2hH6L28w92Z6X'); // अपनी मर्जी की प्लेलिस्ट
      var videos = await _yt.playlists.getVideos(playlist.id).take(20).toList();
      
      if (mounted) {
        setState(() {
          _videos = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProTube Zero"),
        backgroundColor: Colors.black,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return ListTile(
                  leading: Image.network(video.thumbnails.mediumResUrl),
                  title: Text(video.title, maxLines: 2),
                  subtitle: Text(video.author),
                  onTap: () {
                    // यहाँ हम वीडियो प्लेयर पर नेविगेट करेंगे
                  },
                );
              },
            ),
    );
  }
}
