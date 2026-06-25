package com.example.protube_app

import android.content.Context
import android.net.Uri
import android.view.View
import androidx.annotation.NonNull
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.StyledPlayerView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.protube.zero/player"
    private var player: ExoPlayer? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. प्लेयर की फैक्ट्री रजिस्टर की (UI के लिए)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("native-player-view", NativePlayerFactory())

        // 2. वीडियो कंट्रोल करने का चैनल
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
        player = ExoPlayer.Builder(this).build()
        val mediaItem = MediaItem.fromUri(Uri.parse(url))
        player?.setMediaItem(mediaItem)
        player?.prepare()
        player?.play()
    }

    override fun onDestroy() {
        super.onDestroy()
        player?.release()
    }
}

// प्लेयर का डिज़ाइन (UI) बनाने वाली फैक्ट्री
class NativePlayerView(context: Context) : PlatformView {
    private val playerView: StyledPlayerView = StyledPlayerView(context)
    override fun getView(): View = playerView
    override fun dispose() {}
}

class NativePlayerFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativePlayerView(context)
    }
}
