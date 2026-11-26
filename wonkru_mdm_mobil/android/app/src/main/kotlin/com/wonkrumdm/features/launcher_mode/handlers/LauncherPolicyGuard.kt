package com.wonkrumdm.features.launcher_mode.handlers

import android.content.Context
import android.util.Log
import com.wonkrumdm.managers.EngineOwnershipManager

class LauncherPolicyGuard(
    private val context: Context,
    private val launcherHandler: DefaultLauncherHandler,
    private val ownershipManager: EngineOwnershipManager
) {
    private val tag = "LauncherPolicyGuard"

    fun ensureDefaultLauncher(): Boolean {
        if (!ownershipManager.isLauncherModeEnabled()) {
            Log.d(tag, "LauncherMode inactive, launcher check skipped.")
            return false
        }

        if (launcherHandler.isOurAppDefaultLauncher()) return true

        val result = launcherHandler.setPreferredHomeActivityOnly(context.packageName)
        if ((result["success"] as? Boolean) == true) {
            Log.i(tag, "Launcher assigned via DPM: ${context.packageName}")
        } else {
            Log.e(tag, "Failed to assign launcher: ${result["message"]}")
        }
        return false
    }
}
