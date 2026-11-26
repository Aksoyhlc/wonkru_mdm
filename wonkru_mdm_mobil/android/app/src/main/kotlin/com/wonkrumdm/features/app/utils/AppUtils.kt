package com.wonkrumdm.features.app.utils

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.net.toUri

object AppUtils {

    private const val TAG = "AppUtils"

    private const val APP_LAUNCH_DELAY_MS = 500L

    fun startApp(context: Context, packageName: String) {
        try {
            Handler(Looper.getMainLooper()).postDelayed({
                val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
                if (launchIntent != null) {
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
                    context.startActivity(launchIntent)
                    Log.i(TAG, "App launched: $packageName")
                } else {
                    Log.w(TAG, "App not found (may not be installed): $packageName")
                }
            }, APP_LAUNCH_DELAY_MS)
        } catch (e: Exception) {
            Log.e(TAG, "Cannot launch app ($packageName): ${e.message}", e)
        }
    }

    fun openAppSettings(context: Context, packageName: String) {
        try {
            val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = "package:$packageName".toUri()
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            Log.i(TAG, "App settings opened: $packageName")
        } catch (e: Exception) {
            Log.e(TAG, "Cannot open app settings ($packageName): ${e.message}")
        }
    }
}
