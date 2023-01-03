package com.zeus.zeus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.billionbottle.com/method-channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
            call,result ->
            if(call.method=="sendDataToNative") {
                val name = call.argument("name") as String?
                val age = call.argument("age") as String?
                val map = mapOf("name" to "hello, $name", age to "$age")
                result.success(map)
            }
        }
    }
}
