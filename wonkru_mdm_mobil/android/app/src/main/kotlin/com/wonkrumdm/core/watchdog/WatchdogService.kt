package com.wonkrumdm.core.watchdog

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.wonkrumdm.MainActivity
import com.wonkrumdm.R
import com.wonkrumdm.core.AppLifecycleObserver
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.core.utils.FlutterStorageHelper
import com.wonkrumdm.features.app.utils.AppUtils
import com.wonkrumdm.features.launcher_mode.handlers.LauncherPolicyGuard
import com.wonkrumdm.features.launcher_mode.handlers.DefaultLauncherHandler
import com.wonkrumdm.managers.EngineOwnershipManager

class WatchdogService : Service() {

    private val tag = "WatchdogService"
    private val ownershipManager by lazy { EngineOwnershipManager(applicationContext) }

    private val handler = Handler(Looper.getMainLooper())
    private var loopRunnable: Runnable? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        setRunning(true)
        startForegroundSafely()

        when (intent?.action) {
            ACTION_RUN_CHECK_NOW -> runCheckOnce()
            else -> startLoopIfNeeded()
        }

        return START_STICKY
    }

    override fun onDestroy() {
        loopRunnable?.let { handler.removeCallbacks(it) }
        loopRunnable = null
        setRunning(false)
        super.onDestroy()
    }

    private fun startLoopIfNeeded() {
        if (loopRunnable != null) return

        loopRunnable = object : Runnable {
            override fun run() {
                try {
                    runCheckOnce()
                } catch (e: Exception) {
                    Log.e(tag, "Watchdog check error: ${e.message}")
                }
                val delayMs = getLoopIntervalMs(applicationContext)
                handler.postDelayed(this, delayMs)
            }
        }
        handler.post(loopRunnable!!)
    }

    private fun runCheckOnce() {
        if (!shouldSchedule(applicationContext)) return

        val storage = FlutterStorageHelper.getInstance(applicationContext)
        if (storage.getLongValue(Constants.KEY_PERMISSIONS_COMPLETED_AT, 0L) == 0L) return

        if (!ownershipManager.isLauncherModeEnabled()) return

        val lastAlive = storage.getLongValue(Constants.KEY_FLUTTER_ALIVE_TIMESTAMP, 0L)
        val elapsed = System.currentTimeMillis() - lastAlive
        val activityAlive = MainActivity.isAlive
        val uiForeground = AppLifecycleObserver.isInForeground

        if (!activityAlive) {
            if (!uiForeground) {
                AppUtils.startApp(applicationContext, applicationContext.packageName)
            }
            return
        }

        if (elapsed > HEARTBEAT_THRESHOLD_LAUNCHER_MODE_MS) {
            if (!uiForeground) {
                AppUtils.startApp(applicationContext, applicationContext.packageName)
            }
            return
        }

        if (!uiForeground) {
            enforceLauncherMode()
        }
    }

    private fun enforceLauncherMode() {
        try {
            val dpm = applicationContext.getSystemService(DevicePolicyManager::class.java)
            val admin = ComponentName(applicationContext, MdmDeviceAdminReceiver::class.java)
            val launcherHandler = DefaultLauncherHandler(applicationContext, dpm, admin)
            val guard = LauncherPolicyGuard(applicationContext, launcherHandler, ownershipManager)
            guard.ensureDefaultLauncher()
        } catch (e: Exception) {
            Log.e(tag, "LauncherMode launcher enforcement error: ${e.message}", e)
        }
    }

    private fun startForegroundSafely() {
        val notification = buildNotification(applicationContext)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SYSTEM_EXEMPTED
            } else {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            }
            ServiceCompat.startForeground(this, NOTIFICATION_ID, notification, type)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun getLoopIntervalMs(context: Context): Long {
        return if (WatchdogScheduler.isScreenOn(context)) LOOP_INTERVAL_SCREEN_ON_MS else LOOP_INTERVAL_SCREEN_OFF_MS
    }

    companion object {
        private const val LOOP_INTERVAL_SCREEN_ON_MS = 5_000L
        private const val LOOP_INTERVAL_SCREEN_OFF_MS = 45_000L
        private const val HEARTBEAT_THRESHOLD_LAUNCHER_MODE_MS = 10_000L
        private const val NOTIFICATION_CHANNEL_ID = "wonkrumdm_watchdog_channel"
        const val NOTIFICATION_ID = 9101

        const val ACTION_RUN_CHECK_NOW = "com.wonkrumdm.action.WATCHDOG_RUN_CHECK_NOW"

        @Volatile
        var isRunning: Boolean = false
            private set

        internal fun setRunning(value: Boolean) {
            isRunning = value
        }

        fun shouldSchedule(context: Context): Boolean {
            val ownershipManager = EngineOwnershipManager(context)
            if (ownershipManager.isLauncherModeEnabled()) return true
            return FlutterStorageHelper.getInstance(context)
                .getBooleanValue(Constants.KEY_WATCHDOG_SERVICE_ENABLED, true)
        }

        fun requestStart(context: Context) {
            val intent = Intent(context, WatchdogService::class.java)
            ContextCompat.startForegroundService(context, intent)
        }

        fun requestStop(context: Context) {
            val intent = Intent(context, WatchdogService::class.java)
            context.stopService(intent)
        }

        fun buildNotification(context: Context): Notification {
            val notificationManager = context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    NOTIFICATION_CHANNEL_ID,
                    context.getString(R.string.watchdog_channel_name),
                    NotificationManager.IMPORTANCE_HIGH
                )
                channel.description = context.getString(R.string.watchdog_channel_description)
                channel.enableVibration(false)
                channel.setSound(null, null)
                channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                notificationManager.createNotificationChannel(channel)
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                Intent(context, MainActivity::class.java),
                WatchdogScheduler.pendingIntentFlags()
            )

            return NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
                .setContentTitle(context.getString(R.string.app_name))
                .setContentText(context.getString(R.string.watchdog_notification_text))
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pendingIntent)
                .setCategory(NotificationCompat.CATEGORY_SERVICE)
                .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setOnlyAlertOnce(true)
                .setOngoing(true)
                .build()
        }
    }
}
