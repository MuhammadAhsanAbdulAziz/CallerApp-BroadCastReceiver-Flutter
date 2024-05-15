package com.example.caller_app

import android.Manifest
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.BaseColumns
import android.provider.ContactsContract
import android.telecom.TelecomManager
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat

import io.flutter.plugin.common.EventChannel

class MyStreamHandler(private val context: Context) : EventChannel.StreamHandler {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events == null) return
        val intent = Intent(context, MyForegroundService::class.java)
        MyForegroundService.eventSink = events
        context.startForegroundService(intent)
    }

    override fun onCancel(arguments: Any?) {
    }
}