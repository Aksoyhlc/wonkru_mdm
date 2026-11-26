package com.wonkrumdm.logging

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "wonkru_logs",
    indices = [
        Index(value = ["level"]),
        Index(value = ["synced"])
    ]
)
data class LogEntry(
    @PrimaryKey
    val id: String,

    val timestamp: String,

    val level: Int,

    val tag: String,

    val message: String,

    val stacktrace: String? = null,

    @ColumnInfo(name = "device_id")
    val deviceId: String? = null,

    @ColumnInfo(name = "session_id")
    val sessionId: String? = null,

    val synced: Int = 0
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "id" to id,
        "timestamp" to timestamp,
        "level" to level,
        "tag" to tag,
        "message" to message,
        "stacktrace" to stacktrace,
        "device_id" to deviceId,
        "session_id" to sessionId,
        "synced" to synced
    )

    companion object {
        fun fromMap(map: Map<String, Any?>): LogEntry = LogEntry(
            id = map["id"] as? String ?: "",
            timestamp = map["timestamp"] as? String ?: "",
            level = (map["level"] as? Number)?.toInt() ?: LogLevel.INFO.value,
            tag = map["tag"] as? String ?: "",
            message = map["message"] as? String ?: "",
            stacktrace = map["stacktrace"] as? String,
            deviceId = map["device_id"] as? String,
            sessionId = map["session_id"] as? String,
            synced = (map["synced"] as? Number)?.toInt() ?: 0
        )
    }
}