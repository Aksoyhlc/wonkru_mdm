package com.wonkrumdm.features.audio

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.audio.AudioPig
import com.wonkrumdm.features.audio.handlers.AudioControlHandler
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class AudioImpl(
    private val context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName,
    messenger: BinaryMessenger
) : AudioPig {

    private val controlHandler = AudioControlHandler(context, dpm, adminComponent)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun setMusicVolume(volumePercent: Long, callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = controlHandler.setMusicVolume(volumePercent.toInt())
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getMusicVolume(callback: (Result<Long>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = controlHandler.getMusicVolume()
                val volume = result.data as? Long ?: 0L
                callback(Result.success(volume))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun hasNotificationPolicyAccess(callback: (Result<Boolean>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val hasAccess = controlHandler.hasNotificationPolicyAccess()
                callback(Result.success(hasAccess))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun requestNotificationPolicyAccess(callback: (Result<Unit>) -> Unit) {
        scope.launch {
            try {
                controlHandler.requestNotificationPolicyAccessIntent()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}
