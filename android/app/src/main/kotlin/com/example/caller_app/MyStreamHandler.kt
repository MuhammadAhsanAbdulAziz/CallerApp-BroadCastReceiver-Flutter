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
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events == null) return
        receiver = initReceiver(events)
        val intentFilter = IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
        context.registerReceiver(receiver, intentFilter)
    }

    private fun initReceiver(events: EventChannel.EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
            override fun onReceive(context: Context?, intent: Intent?) {
                if (context != null && intent != null) {
                    if (intent.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
                        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
                        if (state == TelephonyManager.EXTRA_STATE_RINGING) {
                            val callingNumber =
                                intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
                            if (callingNumber != null) {
                                val telecomManager =
                                    context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
                                if (getContactDisplayNameByNumber(callingNumber) == "?" || getContactDisplayNameByNumber(
                                        callingNumber
                                    ) == "Unknown"
                                ) {
                                    declineCall(telecomManager)
                                } else {
                                    val intent1 = Intent(context, MainActivity::class.java)
                                    intent1.putExtra("number", callingNumber)
                                    intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    context.startActivity(intent1)
                                    events.success(callingNumber)
                                    Handler(Looper.getMainLooper()).postDelayed({
                                        acceptCall(telecomManager)
                                    }, 3000)
                                }
                            }
                        }
                    }
                }
            }

            private fun getContactDisplayNameByNumber(number: String?): String {
                val uri = Uri.withAppendedPath(
                    ContactsContract.PhoneLookup.CONTENT_FILTER_URI, Uri.encode(number)
                )
                var name = "?"
                val contentResolver: ContentResolver = context.contentResolver
                val contactLookup = contentResolver.query(
                    uri, arrayOf(
                        BaseColumns._ID, ContactsContract.PhoneLookup.DISPLAY_NAME
                    ), null, null, null
                )
                try {
                    if (contactLookup != null && contactLookup.count > 0) {
                        contactLookup.moveToNext()
                        val nameColumnIndex =
                            contactLookup.getColumnIndex(ContactsContract.Data.DISPLAY_NAME)
                        name = if (nameColumnIndex != -1) {
                            contactLookup.getString(nameColumnIndex)
                        } else {
                            // Handle the case when the DISPLAY_NAME column doesn't exist in the cursor
                            "Unknown"
                        }
                    }
                } finally {
                    contactLookup?.close()
                }
                return name
            }

            private fun declineCall(telecomManager: TelecomManager) {
                if (ContextCompat.checkSelfPermission(
                        context, Manifest.permission.READ_PHONE_STATE
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        telecomManager.endCall()

                    }
                }
            }

            private fun acceptCall(telecomManager: TelecomManager) {
                if (ContextCompat.checkSelfPermission(
                        context, Manifest.permission.READ_PHONE_STATE
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        telecomManager.acceptRingingCall()

                    }
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {

    }
}