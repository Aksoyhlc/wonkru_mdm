package com.wonkrumdm.features.display.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.view.WindowManager
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.core.lockDevice

class DisplayHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "DisplayHandler"

    fun lockNow(): MdmResult = lockDevice(dpm, context, adminComponent)

    fun setLockScreenMessage(message: String?): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            dpm.setDeviceOwnerLockScreenInfo(adminComponent, message)
            successResult("Lock screen message ${if (message == null) "removed" else "set"}.")
        } catch (e: Exception) {
            errorResult("Lock screen message error (message=${message?.take(50) ?: "null"}): ${e.message}")
        }
    }

    fun setScreenCaptureDisabled(disabled: Boolean): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            dpm.setScreenCaptureDisabled(adminComponent, disabled)
            successResult("Screen capture ${if (disabled) "disabled" else "enabled"}.")
        } catch (e: Exception) {
            errorResult("Screen capture setting error (disabled=$disabled): ${e.message}")
        }
    }

    fun getDisplayInfo(): Map<String, Any?> {
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val metrics = android.util.DisplayMetrics()
        val refreshRate: Float

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val windowMetrics = windowManager.currentWindowMetrics
            val bounds = windowMetrics.bounds
            metrics.widthPixels = bounds.width()
            metrics.heightPixels = bounds.height()
            val resMetrics = context.resources.displayMetrics
            metrics.densityDpi = resMetrics.densityDpi
            metrics.density = resMetrics.density
            metrics.scaledDensity = resMetrics.scaledDensity
            refreshRate = context.display?.refreshRate ?: 60.0f
        } else {
            @Suppress("DEPRECATION")
            val display = windowManager.defaultDisplay
            display.getRealMetrics(metrics)
            refreshRate = display.refreshRate
        }

        return mapOf(
            "widthPixels" to metrics.widthPixels,
            "heightPixels" to metrics.heightPixels,
            "densityDpi" to metrics.densityDpi,
            "density" to metrics.density,
            "scaledDensity" to metrics.scaledDensity,
            "refreshRate" to refreshRate
        )
    }
}