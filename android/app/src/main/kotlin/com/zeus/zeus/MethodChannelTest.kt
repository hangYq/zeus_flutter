package com.zeus.zeus

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Timer
import kotlin.concurrent.timerTask

class MethodChannelTest(var activity: Activity, messenger: BinaryMessenger) :MethodChannel.MethodCallHandler{
    private val channelName = "flutter.billionbottle.com/method-channel"
    private val channel:MethodChannel
    private var count = 0

    init {
        channel = MethodChannel(messenger, channelName)
        channel.setMethodCallHandler(this)
        starTimer()
    }

    private fun starTimer() {
        var timer = Timer().schedule(timerTask {
            activity.runOnUiThread {
                var map = mapOf("count" to count++)
                channel.invokeMethod("timer", map)
            }
        }, 0, 1000)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method=="sendDataToNative") {
            val name = call.argument("name") as String?
            val age = call.argument("age") as String?
            val map = mapOf("name" to "$name", "age" to "$age")
            result.success(map)
        }
    }
}