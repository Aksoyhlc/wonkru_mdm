package com.wonkrumdm.core.watchdog

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class WatchdogAlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != WatchdogScheduler.ACTION_WATCHDOG_ALARM) return

        if (!WatchdogService.shouldSchedule(context)) {
            WatchdogScheduler.stop(context)
            return
        }

        WatchdogService.requestStart(context)
        WatchdogScheduler.scheduleNextAlarm(context)
    }
}