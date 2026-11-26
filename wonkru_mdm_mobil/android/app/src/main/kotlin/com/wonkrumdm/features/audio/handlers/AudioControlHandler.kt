package com.wonkrumdm.features.audio.handlers

import android.app.NotificationManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.media.AudioManager
import android.provider.Settings
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import kotlin.math.roundToInt

class AudioControlHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "AudioControlHandler"
    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    fun hasNotificationPolicyAccess(): Boolean {
        return notificationManager.isNotificationPolicyAccessGranted
    }

    fun requestNotificationPolicyAccessIntent() {
        try {
            val intent = android.content.Intent(
                Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS
            )
            intent.flags = android.content.Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
            android.util.Log.i(logTag, "Notification Policy Access settings opened")
        } catch (e: Exception) {
            android.util.Log.e(logTag, "Cannot open settings: ${e.message}")
        }
    }

    fun setMusicVolume(volumePercent: Int): MdmResult {
        return try {
            val stream = AudioManager.STREAM_MUSIC
            val maxVolume = audioManager.getStreamMaxVolume(stream)
            val targetIndex = (maxVolume * (volumePercent.coerceIn(0, 100) / 100.0)).roundToInt()

            audioManager.setStreamVolume(stream, targetIndex, 0)

            successResult("Media volume set (%$volumePercent -> Idx: $targetIndex)")
        } catch (e: Exception) {
            errorResult("Media volume set error (volumePercent=$volumePercent): ${e.message}")
        }
    }

    fun getMusicVolume(): MdmResult {
        return try {
            val stream = AudioManager.STREAM_MUSIC
            val currentVol = audioManager.getStreamVolume(stream)
            val maxVol = audioManager.getStreamMaxVolume(stream)

            val percent = if (maxVol > 0) {
                ((currentVol.toDouble() / maxVol.toDouble()) * 100).toInt()
            } else 0

            successResult("Media volume read", percent.toLong())
        } catch (e: Exception) {
            errorResult("Media volume read error: ${e.message}")
        }
    }

}