package com.wonkrumdm.logging

enum class LogLevel(val value: Int, val label: String) {
    VERBOSE(0, "VERBOSE"),
    DEBUG(1, "DEBUG"),
    INFO(2, "INFO"),
    WARNING(3, "WARNING"),
    ERROR(4, "ERROR"),
    FATAL(5, "FATAL");

    companion object {
        fun fromValue(value: Int): LogLevel =
            entries.firstOrNull { it.value == value } ?: INFO
    }
}