import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'video_player_screen.dart';

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

  Future<void> _fetchTrendingVideos() async {
    try {
      // ट्रेंडिंग प्लेलिस्ट का ID
      var playlist = await _yt.playlists.get('PLrEnWoR732-QH6-3i07h2hH6L28w92Z6X');
      var videos = await _yt.playlists.getVideos(playlist.id).take(20).toList();
      
      if (mounted) {
        setState(() {
          _videos = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching videos: $e");
    }
  }

  // 🌟 यह फंक्शन सबसे ज़रूरी है: ये YouTube से वीडियो का असली स्ट्रीम लिंक निकालता है 🌟
  Future<String?> _getVideoUrl(String videoId) async {
    var manifest = await _yt.videos.streamsClient.getManifest(videoId);
    var streamInfo = manifest.muxedStreams.withHighestBitrate();
    return streamInfo.url.toString();
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("ProTube Zero", style: TextStyle(color: Colors.white)),
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
                  title: Text(video.title, style: const TextStyle(color: Colors.white), maxLines: 2),
                  subtitle: Text(video.author, style: const TextStyle(color: Colors.grey)),
                  onTap: () async {
                    // लिंक निकालना (Extracting)
                    String? url = await _getVideoUrl(video.id.value);
                    if (url != null && mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoUrl: url,
                            title: video.title,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
