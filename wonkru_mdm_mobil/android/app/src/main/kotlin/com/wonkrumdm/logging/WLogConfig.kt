package com.wonkrumdm.logging

import com.wonkrumdm.BuildConfig

data class WLogConfig(
    val consoleMinLevel: LogLevel = if (BuildConfig.DEBUG) LogLevel.VERBOSE else LogLevel.INFO,
    val dbMinLevel: LogLevel = LogLevel.INFO,
    val maxLocalEntries: Int = 1000,
    val flushThreshold: Int = 50,
    val idleFlushSeconds: Int = 60,
    val retentionDays: Int = 7
) {
    companion object {
        fun fromJson(json: Map<String, Any?>): WLogConfig {
            fun level(key: String): LogLevel =
                LogLevel.fromValue((json[key] as? Number)?.toInt() ?: LogLevel.INFO.value)
            return WLogConfig(
                consoleMinLevel = level("consoleMinLevel"),
                dbMinLevel = level("dbMinLevel"),
                maxLocalEntries = (json["maxLocalEntries"] as? Number)?.toInt() ?: 1000,
                flushThreshold = (json["flushThreshold"] as? Number)?.toInt() ?: 50,
                idleFlushSeconds = (json["idleFlushSeconds"] as? Number)?.toInt() ?: 60,
                retentionDays = (json["retentionDays"] as? Number)?.toInt() ?: 7
            )
        }
    }
}
