package com.wonkrumdm.features.wifi.handlers

import android.annotation.SuppressLint
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import com.wonkrumdm.api.wifi.NativeWifiInfo
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.features.wifi.utils.WifiUtils
import java.net.Inet4Address
import java.net.InetAddress
import java.nio.ByteBuffer
import java.nio.ByteOrder

class WifiInfoHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "WifiInfoHandler"
    private val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    private val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    fun getConnectionInfo(): MdmResult {
        return try {
            val nativeInfo: NativeWifiInfo

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val wifiNetwork = findWifiNetwork()
                    ?: return errorResult("Device is not currently connected to a Wi-Fi network.")

                val capabilities = connectivityManager.getNetworkCapabilities(wifiNetwork)
                    ?: return errorResult("Network capabilities unavailable.")

                if (!capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                    return errorResult("Device is not currently connected to a Wi-Fi network.")
                }

                @Suppress("DEPRECATION")
                val legacyConnectionInfo = wifiManager.connectionInfo

                var wifiInfo: WifiInfo? = capabilities.transportInfo as? WifiInfo
                if (wifiInfo == null) {
                    wifiInfo = legacyConnectionInfo
                }
                if (wifiInfo == null) {
                    return errorResult("Wi-Fi details unavailable (Redacted or null).")
                }

                val linkProperties = connectivityManager.getLinkProperties(wifiNetwork)
                val ipFromLink = linkProperties?.linkAddresses
                    ?.firstOrNull { it.address is Inet4Address }
                    ?.address?.hostAddress

                val ssidResolved = effectiveSsid(wifiInfo, legacyConnectionInfo)
                val bssidResolved = effectiveBssid(wifiInfo, legacyConnectionInfo)
                nativeInfo = mapToNativeWifiInfo(
                    wifiInfo,
                    ipAddressOverride = ipFromLink,
                    ssidOverride = ssidResolved,
                    bssidOverride = bssidResolved,
                )

            } else {
                @Suppress("DEPRECATION")
                val wifiInfo = wifiManager.connectionInfo
                if (wifiInfo == null || wifiInfo.networkId == -1) {
                    return errorResult("Device is not currently connected to a Wi-Fi network.")
                }
                nativeInfo = mapToNativeWifiInfo(wifiInfo)
            }

            successResult("Connection info retrieved.", nativeInfo)
        } catch (e: Exception) {
            errorResult("Info retrieval error: ${e.message}")
        }
    }

    private fun findWifiNetwork(): Network? {
        val active = connectivityManager.activeNetwork
        if (active != null) {
            val caps = connectivityManager.getNetworkCapabilities(active)
            if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                return active
            }
        }
        for (network in connectivityManager.allNetworks) {
            val caps = connectivityManager.getNetworkCapabilities(network) ?: continue
            if (caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                return network
            }
        }
        return null
    }

    private fun effectiveSsid(primary: WifiInfo, legacy: WifiInfo?): String {
        return when {
            !WifiUtils.isUnknownSsid(primary.ssid) -> WifiUtils.cleanQuotedSsid(primary.ssid)
            legacy != null && !WifiUtils.isUnknownSsid(legacy.ssid) -> WifiUtils.cleanQuotedSsid(legacy.ssid)
            else -> WifiUtils.cleanQuotedSsid(primary.ssid)
        }
    }

    private fun effectiveBssid(primary: WifiInfo, legacy: WifiInfo?): String {
        val p = primary.bssid
        val l = legacy?.bssid
        return when {
            !WifiUtils.isPlaceholderBssid(p) -> p!!
            legacy != null && !WifiUtils.isPlaceholderBssid(l) -> l!!
            else -> p ?: l ?: WifiUtils.UNKNOWN_BSSID
        }
    }

    @SuppressLint("DefaultLocale")
    private fun mapToNativeWifiInfo(
        info: WifiInfo,
        ipAddressOverride: String? = null,
        ssidOverride: String? = null,
        bssidOverride: String? = null,
    ): NativeWifiInfo {
        val ipString = ipAddressOverride ?: run {
            @Suppress("DEPRECATION")
            val ip = info.ipAddress
            try {
                InetAddress.getByAddress(
                    ByteBuffer.allocate(4).order(ByteOrder.BIG_ENDIAN).putInt(ip).array()
                ).hostAddress ?: "0.0.0.0"
            } catch (e: Exception) {
                "0.0.0.0"
            }
        }

        val cleanSsid = ssidOverride ?: WifiUtils.cleanQuotedSsid(info.ssid)

        val bssidStr = bssidOverride ?: (info.bssid ?: WifiUtils.UNKNOWN_BSSID)

        return NativeWifiInfo(
            ssid = cleanSsid,
            bssid = bssidStr,
            macAddress = info.macAddress ?: WifiUtils.UNKNOWN_BSSID,
            ipAddress = ipString,
            rssi = info.rssi.toLong(),
            linkSpeed = info.linkSpeed.toLong(),
            frequency = info.frequency.toLong(),
            networkState = "CONNECTED"
        )
    }
}