package com.wonkrumdm.features.display

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import com.wonkrumdm.api.display.DisplayAPI
import com.wonkrumdm.features.display.handlers.DisplayHandler
import com.wonkrumdm.features.display.handlers.SettingsObserverHandler
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import androidx.core.net.toUri

class DisplayImpl(
    private val context: Context,
    private val dpm: DevicePolicyManager,
    private val adminComponent: ComponentName,
    private val messenger: BinaryMessenger,
    private var activity: Activity? = null
) : DisplayAPI {

    private val handler = DisplayHandler(context, dpm, adminComponent)
    private val observer = SettingsObserverHandler(context, messenger) { activity }

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun updateActivity(newActivity: Activity) {
        this.activity = newActivity
    }

    override fun lockNow(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            val result = handler.lockNow()
            callback(Result.success(result.toMap()))
        }
    }

    override fun setLockScreenMessage(message: String?, callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            val result = handler.setLockScreenMessage(message)
            callback(Result.success(result.toMap()))
        }
    }

    override fun setScreenCaptureDisabled(disabled: Boolean, callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            val result = handler.setScreenCaptureDisabled(disabled)
            callback(Result.success(result.toMap()))
        }
    }

    override fun startSettingsListener(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            observer.startListening()
            callback(Result.success(Unit))
        }
    }

    override fun stopSettingsListener(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            observer.stopListening()
            callback(Result.success(Unit))
        }
    }

    fun onActivityDestroy() {
        observer.stopListening()
        dispose()
    }

    fun dispose() {
        scope.cancel()
    }

    override fun hasWriteSettingsPermission(callback: (Result<Boolean>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            val hasPermission = Settings.System.canWrite(context)
            callback(Result.success(hasPermission))
        }
    }

    override fun requestWriteSettingsPermission(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS).apply {
                    data = "package:${context.packageName}".toUri()
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getDisplayInfo(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val info = handler.getDisplayInfo()
                callback(Result.success(info))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}