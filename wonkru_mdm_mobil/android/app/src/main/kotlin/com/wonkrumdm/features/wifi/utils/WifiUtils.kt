package com.wonkrumdm.features.wifi.utils

object WifiUtils {

    const val UNKNOWN_SSID = "<unknown ssid>"

    const val UNKNOWN_BSSID = "02:00:00:00:00:00"

    fun cleanQuotedSsid(raw: String?): String = raw?.removeSurrounding("\"") ?: ""

    fun isUnknownSsid(raw: String?): Boolean {
        val s = cleanQuotedSsid(raw).lowercase()
        return s.isEmpty() || s == UNKNOWN_SSID
    }

    fun isPlaceholderBssid(mac: String?): Boolean =
        mac.isNullOrEmpty() || mac.equals(UNKNOWN_BSSID, ignoreCase = true)
}
