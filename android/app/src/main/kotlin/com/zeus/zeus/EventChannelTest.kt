package com.zeus.zeus

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import kotlin.concurrent.timerTask

class EventChannelTest(var activity: Activity,messenger: BinaryMessenger):EventChannel.StreamHandler {

    private val channelName = "flutter.billionbottle.com/event-channel"
    private val channel: EventChannel
    private var events: EventChannel.EventSink? = null
    private var eventChannelCount = 20

    init {
        channel = EventChannel(messenger, channelName)
        channel.setStreamHandler(this)
        starTimer()
    }

    private fun starTimer() {
        var timer = Timer().schedule(timerTask {
            activity.runOnUiThread {
                var map = mapOf("eventChannelCount" to eventChannelCount++,"eventChannel" to "eventChannel")
                events?.success(map)
            }
        }, 0, 1000)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.events = events
    }

    override fun onCancel(arguments: Any?) {
        this.events = null
    }

}