package com.wonkrumdm.core.utils

import android.content.Context
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject

class FlutterStorageHelper private constructor(private val context: Context) {
    companion object {
        private const val TAG = "FlutterStorageHelper"
        private const val PREFS_NAME = "FlutterSharedPreferences"
        @Volatile private var INSTANCE: FlutterStorageHelper? = null
        fun getInstance(context: Context): FlutterStorageHelper {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: FlutterStorageHelper(context.applicationContext).also { INSTANCE = it }
            }
        }
    }

    private val sharedPrefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun getStringValue(key: String, defaultValue: String? = null): String? {
        return sharedPrefs.getString(fullKey(key), null) ?: defaultValue
    }

    fun hasNonEmptyValue(key: String): Boolean {
        val full = fullKey(key)
        val value = when {
            sharedPrefs.contains(full) -> sharedPrefs.all[full]
            sharedPrefs.contains(key) -> sharedPrefs.all[key]
            else -> null
        } ?: return false

        return value.toString().trim().isNotEmpty()
    }

    fun getIntValue(key: String, defaultValue: Int = 0): Int =
        sharedPrefs.getInt(fullKey(key), defaultValue)

    fun getLongValue(key: String, defaultValue: Long = 0L): Long =
        sharedPrefs.getLong(fullKey(key), defaultValue)

    fun getBooleanValue(key: String, defaultValue: Boolean = false): Boolean {
        val full = fullKey(key)
        return when {
            sharedPrefs.contains(full) -> sharedPrefs.getBoolean(full, defaultValue)
            sharedPrefs.contains(key) -> try {
                sharedPrefs.getBoolean(key, defaultValue)
            } catch (_: ClassCastException) {
                defaultValue
            }
            else -> defaultValue
        }
    }

    fun getJSONArrayValue(key: String): JSONArray? {
        return try {
            val value = sharedPrefs.getString(fullKey(key), null) ?: return null
            JSONArray(value)
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing JSONArray for key: $key", e)
            null
        }
    }

    fun getJSONValue(key: String): JSONObject? {
        return try {
            val value = sharedPrefs.getString(fullKey(key), null) ?: return null
            JSONObject(value)
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing JSON for key: $key", e)
            null
        }
    }

    fun getStringSet(key: String): Set<String>? {
        return try {
            val value = sharedPrefs.getString(fullKey(key), null) ?: return null
            val arr = JSONArray(value)
            val set = mutableSetOf<String>()
            for (i in 0 until arr.length()) {
                arr.optString(i)?.takeIf { it.isNotEmpty() }?.let { set.add(it) }
            }
            if (set.isEmpty() && arr.length() > 0) return null
            set
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing StringSet for key: $key", e)
            null
        }
    }

    private fun fullKey(key: String): String = if (key.startsWith("flutter.")) key else "flutter.$key"

    fun setString(key: String, value: String): Boolean {
        return try {
            sharedPrefs.edit().putString(fullKey(key), value).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing String for key: $key", e)
            false
        }
    }

    fun setInt(key: String, value: Int): Boolean {
        return try {
            sharedPrefs.edit().putInt(fullKey(key), value).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing Int for key: $key", e)
            false
        }
    }

    fun setLong(key: String, value: Long): Boolean {
        return try {
            sharedPrefs.edit().putLong(fullKey(key), value).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing Long for key: $key", e)
            false
        }
    }

    fun setBoolean(key: String, value: Boolean): Boolean {
        return try {
            sharedPrefs.edit().putBoolean(fullKey(key), value).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing Boolean for key: $key", e)
            false
        }
    }

    fun setStringSet(key: String, value: Set<String>): Boolean {
        return try {
            val arr = JSONArray(value.toList())
            sharedPrefs.edit().putString(fullKey(key), arr.toString()).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing StringSet for key: $key", e)
            false
        }
    }

    fun remove(key: String): Boolean {
        return try {
            sharedPrefs.edit().remove(fullKey(key)).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error removing key: $key", e)
            false
        }
    }

    fun setJSONValue(key: String, json: JSONObject): Boolean {
        return try {
            sharedPrefs.edit().putString(fullKey(key), json.toString()).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing JSON for key: $key", e)
            false
        }
    }

    fun setJSONArrayValue(key: String, jsonArray: JSONArray): Boolean {
        return try {
            sharedPrefs.edit().putString(fullKey(key), jsonArray.toString()).commit()
        } catch (e: Exception) {
            Log.e(TAG, "Error writing JSONArray for key: $key", e)
            false
        }
    }
}