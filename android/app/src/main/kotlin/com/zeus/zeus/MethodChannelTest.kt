package com.zeus.zeus

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodChannelTest(messenger: BinaryMessenger) :MethodChannel.MethodCallHandler{
    private val channelName = "flutter.billionbottle.com/method-channel"
    private val channel:MethodChannel

    init {
        channel = MethodChannel(messenger, channelName)
        channel.setMethodCallHandler(this)
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