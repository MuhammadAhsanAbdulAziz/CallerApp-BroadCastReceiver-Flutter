package com.example.caller_app

import android.Manifest
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.BaseColumns
import android.provider.ContactsContract
import android.telecom.TelecomManager
import android.telephony.SmsManager
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import java.util.Calendar


class MyBroadcastReceiver(private val events: EventChannel.EventSink?) : BroadcastReceiver() {

    private lateinit var context: Context
    private lateinit var utilManager: UtilManager
    private lateinit var myDatabaseHelper: MyDatabaseHelper

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context != null && intent != null && events != null) {
            myDatabaseHelper = MyDatabaseHelper(context)
            utilManager = UtilManager(context)
            this.context = context
            val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
            if (state == TelephonyManager.EXTRA_STATE_RINGING) {
                val callingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
                if (callingNumber != null) {
                    val telecomManager =
                        context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
                    if (utilManager.getData("saved") != null) {
                        if (utilManager.getData("saved") == "accept") {
                            val intent1 = Intent(context, MainActivity::class.java)
                            intent1.putExtra("number", callingNumber)
                            intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            context.startActivity(intent1)
                            events.success(callingNumber)
                            myDatabaseHelper.addData(callingNumber,"1")
                            Handler(Looper.getMainLooper()).postDelayed({
                                acceptCall(telecomManager)

                            }, 3000)
                        } else {
                            if (getContactDisplayNameByNumber(callingNumber) == "?" || getContactDisplayNameByNumber(
                                    callingNumber
                                ) == "Unknown"
                            ) {
                                declineCall(telecomManager)
                                myDatabaseHelper.addData(callingNumber,"2")
                                if (utilManager.getDataBool("SMS")) {
                                    if (!utilManager.getData("message").isNullOrEmpty()) {
                                        sendSMS(
                                             callingNumber, utilManager.getData("message")!!
                                        )
                                    }
                                    else{
                                        sendSMS(
                                            callingNumber, ""
                                        )
                                    }
                                    events.success("popupSms")
                                }else {
                                    events.success("popup")
                                }
                            } else {
                                val intent1 = Intent(context, MainActivity::class.java)
                                intent1.putExtra("number", callingNumber)
                                intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                context.startActivity(intent1)
                                events.success("$callingNumber")
                                myDatabaseHelper.addData(callingNumber,"1")
                                Handler(Looper.getMainLooper()).postDelayed({
                                    acceptCall(telecomManager)

                                }, 3000)
                            }
                        }
                    }
                }
            }
        }
    }

    private fun getCurrentDateAndTime(): Pair<String, String> {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd")
        val timeFormat = SimpleDateFormat("HH:mm:ss")
        val cal = Calendar.getInstance()
        val date = dateFormat.format(cal.time)
        val time = timeFormat.format(cal.time)
        return Pair(date, time)
    }

    private fun sendSMS(number:String, msg:String) {
        val smsManager = SmsManager.getDefault()
        val parts = smsManager.divideMessage(msg)
        smsManager.sendMultipartTextMessage(number, null, parts, null, null)
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
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                telecomManager.acceptRingingCall()

            }
        }
    }


}