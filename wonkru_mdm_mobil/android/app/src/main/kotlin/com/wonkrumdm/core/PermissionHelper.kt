package com.wonkrumdm.core

import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.provider.Settings

object PermissionHelper {

    fun isBatteryOptimizationIgnored(context: Context): Boolean {
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(context.packageName)
    }

    fun openPowerSaveSettings(context: Context) {
        try {
            val intent = Intent(Settings.ACTION_BATTERY_SAVER_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        } catch (e: Exception) {
            android.util.Log.e("PermissionHelper", "Power save settings could not be opened", e)
        }
    }
}
