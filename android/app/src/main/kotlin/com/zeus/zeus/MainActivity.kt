package com.zeus.zeus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannelTest(this,flutterEngine.dartExecutor.binaryMessenger)
        BasicMessageChannelTest(flutterEngine.dartExecutor.binaryMessenger)
    }
}
