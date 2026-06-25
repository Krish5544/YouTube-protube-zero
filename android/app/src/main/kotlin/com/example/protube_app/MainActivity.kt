package com.example.protube_app // अपना सही पैकेज नाम रखना

import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.StyledPlayerView

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.protube.zero/player"
    private var player: ExoPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playVideo") {
                val url = call.argument<String>("url")
                if (url != null) {
                    playVideoNative(url)
                    result.success("Playing started")
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playVideoNative(url: String) {
        // यहाँ प्लेयर इनिशियलाइज़ हो रहा है
        player = ExoPlayer.Builder(this).build()
        val mediaItem = MediaItem.fromUri(Uri.parse(url))
        player?.setMediaItem(mediaItem)
        player?.prepare()
        player?.play()
        
        // इसके बाद हमें Android की स्क्रीन पर एक 'View' जोड़ना होगा
        // जहाँ ये वीडियो दिखेगी
    }

    override fun onDestroy() {
        super.onDestroy()
        player?.release() // ऐप बंद होने पर प्लेयर को रिलीज़ करना ज़रूरी है
    }
}
