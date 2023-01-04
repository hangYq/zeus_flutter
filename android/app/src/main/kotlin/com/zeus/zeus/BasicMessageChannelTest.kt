package com.zeus.zeus

import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

class BasicMessageChannelTest(messenger: BinaryMessenger):BasicMessageChannel.MessageHandler<Any> {
    private val channelName = "flutter.billionbottle.com/basic-message-channel"
    private val channel: BasicMessageChannel<Any>

    init {
        channel = BasicMessageChannel(messenger, channelName, StandardMessageCodec())
        channel.setMessageHandler(this)
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {
        val name = (message as Map<String, Any>)["name"]
        val age = (message as Map<String, Any>)["age"]
        var result = mapOf("name" to name,"age" to age)
        reply.reply(result)
    }
}