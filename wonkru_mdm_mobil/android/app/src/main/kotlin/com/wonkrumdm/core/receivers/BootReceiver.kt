package com.wonkrumdm.core.receivers

import android.app.admin.DevicePolicyManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.wonkrumdm.MdmApplication
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.utils.FlutterStorageHelper
import com.wonkrumdm.features.app.utils.AppUtils.startApp
import com.wonkrumdm.features.launcher_mode.handlers.LauncherPolicyGuard
import com.wonkrumdm.features.launcher_mode.handlers.DefaultLauncherHandler
import com.wonkrumdm.features.restriction.handlers.RestrictionHandler
import com.wonkrumdm.managers.EngineOwnershipManager

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action

        if (action == Intent.ACTION_BOOT_COMPLETED || action == "android.intent.action.QUICKBOOT_POWERON") {
            checkAndRestoreInstallRestriction(context)

            val ownershipManager = EngineOwnershipManager(context)
            ownershipManager.clearOwner()
            val launcherModeEnabled = ownershipManager.isLauncherModeEnabled()
            MdmApplication.startContinuousServices(context)
            if (launcherModeEnabled) {
                ensureLauncherPolicy(context)
                startApp(context, context.packageName)
            }

            val pendingResult = goAsync()
            try {
                val helper = FlutterStorageHelper.getInstance(context)
                val arr = helper.getJSONArrayValue(Constants.KEY_BOOT_STARTUP_APPS)
                val list = mutableListOf<String>()
                if (arr != null) {
                    for (i in 0 until arr.length()) {
                        val pkg = arr.optString(i)
                        if (pkg.isNotEmpty()) list.add(pkg)
                    }
                }

                if (list.isNotEmpty()) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        try {
                            for (packageName in list) {
                                if (packageName != context.packageName) {
                                    try {
                                        startApp(context, packageName)
                                    } catch (e: Exception) {
                                        Log.e(TAG, "Failed to start ($packageName): ${e.message}")
                                    }
                                }
                            }
                        } finally {
                            pendingResult.finish()
                        }
                    }, BOOT_APP_LAUNCH_DELAY_MS)
                } else {
                    pendingResult.finish()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error starting boot applications: ${e.message}")
                pendingResult.finish()
            }
        }
    }

    private fun checkAndRestoreInstallRestriction(context: Context) {
        RestrictionHandler.checkAndRestoreInstallRestriction(context)
    }

    private fun ensureLauncherPolicy(context: Context) {
        val dpm = context.getSystemService(DevicePolicyManager::class.java)
        val admin = ComponentName(context, MdmDeviceAdminReceiver::class.java)
        val launcherHandler = DefaultLauncherHandler(context, dpm, admin)
        val guard = LauncherPolicyGuard(context, launcherHandler, EngineOwnershipManager(context))
        guard.ensureDefaultLauncher()
    }

    companion object {
        private const val TAG = "BootReceiver"

        private const val BOOT_APP_LAUNCH_DELAY_MS = 3000L
    }
}
