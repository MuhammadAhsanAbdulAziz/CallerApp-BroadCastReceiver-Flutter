package com.example.caller_app

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import java.text.SimpleDateFormat
import java.util.*

class MyDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "my_database"
        private const val TABLE_NAME = "my_table"
        private const val COLUMN_ID = "id"
        private const val COLUMN_NAME = "name"
        private const val COLUMN_DATE = "date"
        private const val COLUMN_TIME = "time"
        private const val COLUMN_STATE = "state"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTableQuery = ("CREATE TABLE $TABLE_NAME ($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "$COLUMN_NAME TEXT, $COLUMN_DATE TEXT, $COLUMN_TIME TEXT, $COLUMN_STATE TEXT)")
        db.execSQL(createTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    fun addData(name: String, state: String) {
        val db = this.writableDatabase
        val contentValues = ContentValues()
        contentValues.put(COLUMN_NAME, name)
        contentValues.put(COLUMN_DATE, getCurrentDate())
        contentValues.put(COLUMN_TIME, getCurrentTime())
        contentValues.put(COLUMN_STATE, state)
        db.insert(TABLE_NAME, null, contentValues)
        db.close()
    }

    fun getLastRecord(): String {
        val db = this.readableDatabase
        var lastRecord: String? = null
        val cursor: Cursor = db.rawQuery("SELECT * FROM $TABLE_NAME ORDER BY $COLUMN_ID DESC LIMIT 1", null)
        if (cursor != null && cursor.moveToFirst()) {
            val nameIndex = cursor.getColumnIndex(COLUMN_NAME)
            val dateIndex = cursor.getColumnIndex(COLUMN_DATE)
            val timeIndex = cursor.getColumnIndex(COLUMN_TIME)
            val stateIndex = cursor.getColumnIndex(COLUMN_STATE)
            if (nameIndex >= 0 && dateIndex >= 0 && timeIndex >= 0 && stateIndex >= 0) {
                val name = cursor.getString(nameIndex)
                val date = cursor.getString(dateIndex)
                val time = cursor.getString(timeIndex)
                val state = cursor.getString(stateIndex)
                lastRecord = "Name: $name\n Date: $date, Time: $time, State: $state"
            } else {
                return ""
            }
        } else {
            return ""
        }
        cursor.close()
        db.close()
        return lastRecord
    }



    private fun getCurrentDate(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val currentDate = Date()
        return dateFormat.format(currentDate)
    }

    private fun getCurrentTime(): String {
        val timeFormat = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
        val currentTime = Date()
        return timeFormat.format(currentTime)
    }
}
