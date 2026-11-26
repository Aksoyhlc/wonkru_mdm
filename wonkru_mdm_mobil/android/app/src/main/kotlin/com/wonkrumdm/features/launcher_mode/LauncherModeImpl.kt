package com.wonkrumdm.features.launcher_mode

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import com.wonkrumdm.api.launcher_mode.LauncherModeApi
import com.wonkrumdm.features.launcher_mode.handlers.DefaultLauncherHandler

class LauncherModeImpl(
    private val activity: Activity,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : LauncherModeApi {

    private val launcherHandler = DefaultLauncherHandler(activity, dpm, adminComponent)

    override fun addHomeIntentHandler(packageName: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        val result = launcherHandler.setPreferredHomeActivityOnly(packageName)
        callback(Result.success(result))
    }

    override fun clearHomeIntentHandler(packageName: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        callback(Result.success(launcherHandler.clearHomeIntentHandler(packageName)))
    }
}
