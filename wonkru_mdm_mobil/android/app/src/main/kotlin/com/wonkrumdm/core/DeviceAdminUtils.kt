package com.wonkrumdm.core

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context

fun lockDevice(
    dpm: DevicePolicyManager,
    context: Context,
    adminComponent: ComponentName
): MdmResult {
    if (!dpm.isDeviceOwnerApp(context.packageName)) {
        return MdmResult(false, "Operation failed: Device Owner permission required.", null)
    }
    return try {
        dpm.lockNow()
        MdmResult(true, "Device locked.", null)
    } catch (e: Exception) {
        MdmResult(false, "Lock error: ${e.message}", null)
    }
}