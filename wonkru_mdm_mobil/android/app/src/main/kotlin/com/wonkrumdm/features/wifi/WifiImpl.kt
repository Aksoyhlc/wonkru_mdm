package com.wonkrumdm.features.wifi

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.wifi.WifiAPI
import com.wonkrumdm.features.wifi.handlers.WifiConfigHandler
import com.wonkrumdm.features.wifi.handlers.WifiInfoHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class WifiImpl(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : WifiAPI {

    private val configHandler = WifiConfigHandler(context, dpm, adminComponent)
    private val infoHandler = WifiInfoHandler(context, dpm, adminComponent)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun setWifiEnabled(enabled: Boolean, callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = configHandler.setWifiEnabled(enabled)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun isWifiEnabled(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = configHandler.isWifiEnabled()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getConnectionInfo(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = infoHandler.getConnectionInfo()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}
