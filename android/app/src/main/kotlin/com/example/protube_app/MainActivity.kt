package com.example.protube_app // अपनी फाइल का सही पैकेज नाम चेक कर लेना

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.protube.zero/player"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playVideo") {
                val url = call.argument<String>("url")
                // यहाँ हम 'url' को Native ExoPlayer में भेजेंगे
                playVideoNative(url)
                result.success("Playing started")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playVideoNative(url: String?) {
        // यहाँ Android का ExoPlayer सेटअप होगा 
        // यह काम हम अगले स्टेप में करेंगे
        println("Native player received URL: $url")
    }
}
