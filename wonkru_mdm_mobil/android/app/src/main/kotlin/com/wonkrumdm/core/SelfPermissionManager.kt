package com.wonkrumdm.core

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.PermissionInfo
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.logging.WLog

object SelfPermissionManager {

    private const val TAG = "SelfPermissionManager"

    fun grantSelfRuntimePermissions(context: Context) {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as? DevicePolicyManager ?: return
        if (!dpm.isDeviceOwnerApp(context.packageName)) return

        val admin = ComponentName(context, MdmDeviceAdminReceiver::class.java)
        val pm = context.packageManager

        val requested = try {
            @Suppress("DEPRECATION")
            pm.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
                .requestedPermissions
        } catch (e: Exception) {
            WLog.w(TAG, "Could not read requested permissions", e)
            null
        } ?: return

        var granted = 0
        for (permission in requested) {
            if (!isDangerous(pm, permission)) continue
            try {
                dpm.setPermissionGrantState(
                    admin,
                    context.packageName,
                    permission,
                    DevicePolicyManager.PERMISSION_GRANT_STATE_GRANTED
                )
                granted++
            } catch (e: Exception) {
                WLog.w(TAG, "Failed to auto-grant $permission", e)
            }
        }
        WLog.i(TAG, "Auto-granted $granted dangerous runtime permission(s) as Device Owner")
    }

    private fun isDangerous(pm: PackageManager, permission: String): Boolean {
        return try {
            val info = pm.getPermissionInfo(permission, 0)
            @Suppress("DEPRECATION")
            (info.protectionLevel and PermissionInfo.PROTECTION_MASK_BASE) == PermissionInfo.PROTECTION_DANGEROUS
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
}
