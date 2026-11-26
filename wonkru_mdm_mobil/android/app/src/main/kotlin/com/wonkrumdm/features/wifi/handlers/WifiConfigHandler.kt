package com.wonkrumdm.features.wifi.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.net.wifi.WifiManager
import android.util.Log
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult

@Suppress("DEPRECATION")
class WifiConfigHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "WifiConfigHandler"

    private val wifiManager =
        context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

    fun setWifiEnabled(enabled: Boolean): MdmResult {
        return try {
            val success = wifiManager.setWifiEnabled(enabled)
            if (success) {
                successResult("Wi-Fi status changed: $enabled")
            } else {
                Log.w(logTag, "setWifiEnabled($enabled) returned false — API 29+ restriction may apply")
                errorResult("Wi-Fi status could not be changed (API 29+ restriction may apply).")
            }
        } catch (e: Exception) {
            errorResult("Wi-Fi operation error: ${e.message}")
        }
    }

    fun isWifiEnabled(): MdmResult {
        return successResult("Status retrieved", wifiManager.isWifiEnabled)
    }
}