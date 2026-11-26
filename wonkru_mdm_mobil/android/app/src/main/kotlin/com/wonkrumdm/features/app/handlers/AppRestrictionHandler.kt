package com.wonkrumdm.features.app.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.util.Log
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult

class AppRestrictionHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "AppRestrictionHandler"

    fun clearAppData(packageName: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return errorResult("Android 9+ required")

        return try {
            dpm.clearApplicationUserData(adminComponent, packageName, context.mainExecutor) { pkg, succeeded ->
                if (succeeded) Log.i(logTag, "Data cleared: $pkg")
                else Log.e(logTag, "Failed to clear data: $pkg")
            }
            successResult("Data clear request sent.")
        } catch (e: Exception) {
            errorResult("Data clear error (pkg=$packageName): ${e.message}")
        }
    }

    fun setUninstallBlocked(packageName: String, blocked: Boolean): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            dpm.setUninstallBlocked(adminComponent, packageName, blocked)
            successResult("Uninstall block ${if (blocked) "set" else "removed"} for $packageName")
        } catch (e: Exception) {
            errorResult("Uninstall block error (pkg=$packageName, blocked=$blocked): ${e.message}")
        }
    }

}