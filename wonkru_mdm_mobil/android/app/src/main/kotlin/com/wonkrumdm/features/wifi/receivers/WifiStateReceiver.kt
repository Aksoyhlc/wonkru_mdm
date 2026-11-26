package com.wonkrumdm.features.wifi.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import android.os.Build
import android.util.Log
import com.wonkrumdm.api.wifi.NativeWifiEvent
import com.wonkrumdm.api.wifi.WifiEventAPI
import com.wonkrumdm.core.receivers.MultiEngineEventRegistry
import com.wonkrumdm.features.wifi.utils.WifiUtils
import io.flutter.plugin.common.BinaryMessenger

class WifiStateReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "WifiStateReceiver"

        private val registry = MultiEngineEventRegistry("WifiEventAPI") { WifiEventAPI(it) }

        fun initialize(messenger: BinaryMessenger) {
            registry.register(messenger)
        }

        fun dispose(messenger: BinaryMessenger? = null) {
            registry.dispose(messenger)
        }

        fun getIntentFilter(): IntentFilter {
            return IntentFilter().apply {
                addAction(WifiManager.WIFI_STATE_CHANGED_ACTION)
                addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION)
                addAction(WifiManager.SUPPLICANT_STATE_CHANGED_ACTION)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val apis = registry.all()
        if (apis.isEmpty()) return

        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        @Suppress("DEPRECATION")
        val legacyInfo = wifiManager.connectionInfo
        val connected = isWifiConnected(connectivityManager)
        val event = NativeWifiEvent(
            action = intent.action ?: "UNKNOWN_ACTION",
            wifiEnabled = wifiManager.isWifiEnabled,
            connected = connected,
            ssid = resolveSsid(legacyInfo?.ssid),
            bssid = resolveBssid(legacyInfo?.bssid),
            rssi = legacyInfo?.rssi?.toLong(),
            timestampMs = System.currentTimeMillis(),
        )

        for (api in apis) {
            api.onWifiChanged(event) { result ->
                result.exceptionOrNull()?.let { e ->
                    Log.w(TAG, "onWifiChanged callback failed", e)
                }
            }
        }
    }

    private fun isWifiConnected(connectivityManager: ConnectivityManager): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork ?: return false
            val caps = connectivityManager.getNetworkCapabilities(network) ?: return false
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
        } else {
            @Suppress("DEPRECATION")
            val info = connectivityManager.activeNetworkInfo
            @Suppress("DEPRECATION")
            info != null && info.isConnected && info.type == ConnectivityManager.TYPE_WIFI
        }
    }

    private fun resolveSsid(raw: String?): String =
        if (WifiUtils.isUnknownSsid(raw)) "" else WifiUtils.cleanQuotedSsid(raw)

    private fun resolveBssid(raw: String?): String =
        if (raw.isNullOrBlank() || WifiUtils.isPlaceholderBssid(raw)) "" else raw
}