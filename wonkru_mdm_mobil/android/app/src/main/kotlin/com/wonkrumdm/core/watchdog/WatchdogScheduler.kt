package com.wonkrumdm.core.watchdog

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.util.Log
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

object WatchdogScheduler {

    private const val TAG = "WatchdogScheduler"
    private const val ALARM_INTERVAL_SCREEN_ON_MS = 3 * 60 * 1000L
    private const val ALARM_INTERVAL_SCREEN_OFF_MS = 10 * 60 * 1000L
    private const val ALARM_REQUEST_CODE = 9102
    private const val PERIODIC_WORK_INTERVAL_MIN = 15L
    const val ACTION_WATCHDOG_ALARM = "com.wonkrumdm.action.WATCHDOG_ALARM"
    const val WORK_NAME = "wonkrumdm_watchdog_periodic"

    fun pendingIntentFlags(): Int =
        PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0

    fun start(context: Context) {
        if (!WatchdogService.shouldSchedule(context)) {
            stop(context)
            return
        }
        WatchdogService.requestStart(context)
        scheduleNextAlarm(context)
        enqueuePeriodicWork(context)
    }

    fun stop(context: Context) {
        cancelAlarm(context)
        WorkManager.getInstance(context).cancelUniqueWork(WORK_NAME)
        WatchdogService.requestStop(context)
    }

    internal fun isScreenOn(context: Context): Boolean {
        val pm = context.getSystemService(Context.POWER_SERVICE) as? PowerManager ?: return true
        return pm.isInteractive
    }

    private fun getAlarmIntervalMs(context: Context): Long {
        return if (isScreenOn(context)) ALARM_INTERVAL_SCREEN_ON_MS else ALARM_INTERVAL_SCREEN_OFF_MS
    }

    private fun alarmPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, WatchdogAlarmReceiver::class.java).apply {
            action = ACTION_WATCHDOG_ALARM
        }
        return PendingIntent.getBroadcast(context, ALARM_REQUEST_CODE, intent, pendingIntentFlags())
    }

    fun scheduleNextAlarm(context: Context) {
        if (!WatchdogService.shouldSchedule(context)) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            ?: return
        val pending = alarmPendingIntent(context)

        val triggerAt = System.currentTimeMillis() + getAlarmIntervalMs(context)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pending)
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerAt, pending)
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "Exact alarm denied; scheduling inexact alarm instead", e)
            alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAt, pending)
        }
    }

    private fun cancelAlarm(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            ?: return
        alarmManager.cancel(alarmPendingIntent(context))
    }

    private fun enqueuePeriodicWork(context: Context) {
        val request = PeriodicWorkRequestBuilder<WatchdogWorker>(
            PERIODIC_WORK_INTERVAL_MIN, TimeUnit.MINUTES
        ).build()
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            WORK_NAME,
            ExistingPeriodicWorkPolicy.KEEP,
            request
        )
    }
}
