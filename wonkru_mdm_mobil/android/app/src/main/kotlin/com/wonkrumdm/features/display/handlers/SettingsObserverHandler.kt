package com.wonkrumdm.features.display.handlers

import android.app.Activity
import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import com.wonkrumdm.api.display.DisplayEventAPI
import com.wonkrumdm.api.display.NativeSettingsEvent
import io.flutter.plugin.common.BinaryMessenger

class SettingsObserverHandler(
    private val context: Context,
    messenger: BinaryMessenger,
    private val activityProvider: () -> Activity?
) {
    private val flutterApi = DisplayEventAPI(messenger)

    private var contentObserver: ContentObserver? = null
    private var isListening = false

    fun startListening() {
        try {
            if (isListening) return

            val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
                override fun onChange(selfChange: Boolean, uri: Uri?) {
                    super.onChange(selfChange, uri)
                    handleSettingsChange(uri)
                }
            }
            contentObserver = observer

            val resolver = context.contentResolver
            for (setting in WATCHED) {
                resolver.registerContentObserver(Settings.System.getUriFor(setting.key), false, observer)
            }

            isListening = true
        } catch (e: Exception) {
            Log.e(TAG, "Cannot start listener: ${e.message}")
        }
    }

    fun stopListening() {
        try {
            contentObserver?.let {
                context.contentResolver.unregisterContentObserver(it)
            }
            contentObserver = null
            isListening = false
        } catch (e: Exception) {
            Log.e(TAG, "Cannot stop listener: ${e.message}")
        }
    }

    private fun handleSettingsChange(uri: Uri?) {
        val act = activityProvider()
        if (act != null && act.isDestroyed) return

        val changed = if (uri == null) {
            WATCHED
        } else {
            WATCHED.filter { Settings.System.getUriFor(it.key) == uri }
        }

        for (setting in changed) {
            val value = Settings.System.getInt(context.contentResolver, setting.key, 0)
            flutterApi.onSettingsChanged(
                NativeSettingsEvent(type = setting.type, value = value.toLong())
            ) {}
        }
    }

    private data class WatchedSetting(val key: String, val type: String)

    companion object {
        private const val TAG = "SettingsObserverHandler"

        private val WATCHED = listOf(
            WatchedSetting(Settings.System.SCREEN_BRIGHTNESS, "brightness"),
            WatchedSetting(Settings.System.SCREEN_OFF_TIMEOUT, "timeout"),
            WatchedSetting(Settings.System.ACCELEROMETER_ROTATION, "auto_rotation"),
            WatchedSetting(Settings.System.USER_ROTATION, "user_rotation")
        )
    }
}