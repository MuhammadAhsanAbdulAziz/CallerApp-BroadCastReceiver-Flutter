package com.example.caller_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {

    private val EVENT_CHANNEL = "CALL_CHANNEL"
    private lateinit var channel: EventChannel
    private lateinit var myStreamHandler: MyStreamHandler
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        myStreamHandler = MyStreamHandler(context)
        channel.setStreamHandler(myStreamHandler)
    }
}