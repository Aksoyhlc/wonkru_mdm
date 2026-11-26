package com.wonkrumdm.features.notification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.RingtoneManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.wonkrumdm.R
import com.wonkrumdm.api.system_notification.SystemNotificationAPI
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class NotificationHelper(private val context: Context) : SystemNotificationAPI {

    override fun showNotification(
        title: String,
        message: String,
        priority: String?,
        playSound: Boolean,
        vibrate: Boolean,
        callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                ensureChannel()
                val builder = NotificationCompat.Builder(context, CHANNEL_ID)
                    .setContentTitle(title)
                    .setContentText(message)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setPriority(
                        when (priority?.lowercase()) {
                            "error", "warning" -> NotificationCompat.PRIORITY_HIGH
                            else -> NotificationCompat.PRIORITY_DEFAULT
                        }
                    )
                    .setAutoCancel(true)
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                    if (playSound) {
                        builder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                    }
                    if (vibrate) {
                        builder.setVibrate(longArrayOf(0, VIBRATION_MS))
                    }
                } else if (vibrate) {
                    vibrateOnce()
                }
                NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, builder.build())
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    private var channelCreated = false

    private fun ensureChannel() {
        if (channelCreated) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT).apply {
                enableVibration(false)
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION), null)
            }
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .createNotificationChannel(channel)
            channelCreated = true
        }
    }

    private fun vibrateOnce() {
        val effect = VibrationEffect.createOneShot(VIBRATION_MS, VibrationEffect.DEFAULT_AMPLITUDE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            (context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)
                ?.defaultVibrator?.vibrate(effect)
        } else {
            @Suppress("DEPRECATION")
            (context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator)?.vibrate(effect)
        }
    }

    companion object {
        private const val CHANNEL_ID = "wonkrumdm_mdm_notifications"
        private const val CHANNEL_NAME = "MDM Notifications"
        private const val NOTIFICATION_ID = 9000
        private const val VIBRATION_MS = 200L
    }
}