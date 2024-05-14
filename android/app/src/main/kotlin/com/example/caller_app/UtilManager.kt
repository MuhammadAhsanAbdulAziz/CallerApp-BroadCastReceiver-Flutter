package com.example.caller_app

import android.content.Context

class UtilManager(context: Context) {
    private var prefs =
        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    fun getData(key: String): String? {
        return prefs.getString("flutter.$key", null)
    }
    fun getDataBool(key: String): Boolean {
        return prefs.getBoolean("flutter.$key", false)
    }

}