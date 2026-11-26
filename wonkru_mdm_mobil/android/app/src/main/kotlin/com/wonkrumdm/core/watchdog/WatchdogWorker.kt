package com.wonkrumdm.core.watchdog

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

class WatchdogWorker(
    context: Context,
    params: WorkerParameters
) : Worker(context, params) {

    override fun doWork(): Result {
        if (!WatchdogService.shouldSchedule(applicationContext)) {
            return Result.success()
        }
        WatchdogService.requestStart(applicationContext)
        return Result.success()
    }
}