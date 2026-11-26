package com.wonkrumdm.logging

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

object WLogChannel {

    private const val METHOD_CHANNEL = "wonkru/log"
    private const val EVENT_CHANNEL = "wonkru/log/events"

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    @Volatile
    private var eventSink: EventChannel.EventSink? = null
    private val eventSinkLock = Any()

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    fun init(messenger: BinaryMessenger) {
        setupMethodChannel(messenger)
        setupEventChannel(messenger)
        registerWLogCallbacks()
    }

    fun dispose() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        synchronized(eventSinkLock) { eventSink = null }
        WLog.onFatalCallback = null
        WLog.onIdleTimeoutCallback = null
        WLog.onFlushThresholdCallback = null
    }

    private fun setupMethodChannel(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "log" -> handleLog(call.arguments, result)
                    "getUnsynced" -> handleGetUnsynced(call.arguments, result)
                    "getRecent" -> handleGetRecent(call.arguments, result)
                    "markSynced" -> handleMarkSynced(call.arguments, result)
                    "deleteOldSynced" -> handleDeleteOldSynced(result)
                    "deleteAll" -> handleDeleteAll(result)
                    "updateConfig" -> handleUpdateConfig(call.arguments, result)
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun setupEventChannel(messenger: BinaryMessenger) {
        eventChannel = EventChannel(messenger, EVENT_CHANNEL).apply {
            setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    synchronized(eventSinkLock) { eventSink = events }
                }

                override fun onCancel(arguments: Any?) {
                    synchronized(eventSinkLock) { eventSink = null }
                }
            })
        }
    }

    private fun sendEvent(eventType: String) {
        synchronized(eventSinkLock) {
            eventSink?.success(mapOf("event" to eventType))
        }
    }

    private fun registerWLogCallbacks() {
        WLog.onFatalCallback = { sendEvent("onFatal") }
        WLog.onIdleTimeoutCallback = { sendEvent("onIdleTimeout") }
        WLog.onFlushThresholdCallback = { sendEvent("onFlushThreshold") }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleLog(arguments: Any?, result: MethodChannel.Result) {
        try {
            val map = arguments as? Map<String, Any?> ?: run {
                result.error("INVALID_ARGS", "Log entry map expected", null)
                return
            }
            val entry = LogEntry.fromMap(map)
            val level = LogLevel.fromValue(entry.level)

            when {
                level == LogLevel.FATAL -> WLog.fatal(entry.tag, entry.message)
                level == LogLevel.ERROR -> WLog.e(entry.tag, entry.message)
                level == LogLevel.WARNING -> WLog.w(entry.tag, entry.message)
                level == LogLevel.INFO -> WLog.i(entry.tag, entry.message)
                level == LogLevel.DEBUG -> WLog.d(entry.tag, entry.message)
                else -> WLog.v(entry.tag, entry.message)
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("LOG_FAILED", e.message, null)
        }
    }

    private fun handleGetUnsynced(arguments: Any?, result: MethodChannel.Result) {
        val minLevel = (arguments as? Map<*, *>)?.get("minLevel") as? Int ?: LogLevel.WARNING.value
        scope.launch {
            try {
                val entries = WLog.getUnsynced(LogLevel.fromValue(minLevel))
                val list = entries.map { it.toMap() }
                launch(Dispatchers.Main) { result.success(list) }
            } catch (e: Exception) {
                launch(Dispatchers.Main) { result.error("GET_FAILED", e.message, null) }
            }
        }
    }

    private fun handleGetRecent(arguments: Any?, result: MethodChannel.Result) {
        val args = arguments as? Map<*, *>
        val minLevel = args?.get("minLevel") as? Int ?: LogLevel.VERBOSE.value
        val limit = (args?.get("limit") as? Number)?.toInt() ?: 300
        scope.launch {
            try {
                val entries = WLog.getRecent(LogLevel.fromValue(minLevel), limit)
                val list = entries.map { it.toMap() }
                launch(Dispatchers.Main) { result.success(list) }
            } catch (e: Exception) {
                launch(Dispatchers.Main) { result.error("GET_RECENT_FAILED", e.message, null) }
            }
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleMarkSynced(arguments: Any?, result: MethodChannel.Result) {
        val ids = (arguments as? Map<*, *>)?.get("ids") as? List<String> ?: run {
            result.error("INVALID_ARGS", "ids list expected", null)
            return
        }
        scope.launch {
            try {
                WLog.markSynced(ids)
                launch(Dispatchers.Main) { result.success(null) }
            } catch (e: Exception) {
                launch(Dispatchers.Main) { result.error("MARK_FAILED", e.message, null) }
            }
        }
    }

    private fun handleDeleteOldSynced(result: MethodChannel.Result) {
        scope.launch {
            try {
                WLog.deleteOldSynced()
                launch(Dispatchers.Main) { result.success(null) }
            } catch (e: Exception) {
                launch(Dispatchers.Main) { result.error("DELETE_FAILED", e.message, null) }
            }
        }
    }

    private fun handleDeleteAll(result: MethodChannel.Result) {
        scope.launch {
            try {
                WLog.deleteAll()
                launch(Dispatchers.Main) { result.success(null) }
            } catch (e: Exception) {
                launch(Dispatchers.Main) { result.error("DELETE_ALL_FAILED", e.message, null) }
            }
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleUpdateConfig(arguments: Any?, result: MethodChannel.Result) {
        try {
            val map = arguments as? Map<String, Any?> ?: run {
                result.error("INVALID_ARGS", "Config map expected", null)
                return
            }
            val config = WLogConfig.fromJson(map)
            WLog.updateConfig(config)
            result.success(null)
        } catch (e: Exception) {
            result.error("UPDATE_CONFIG_FAILED", e.message, null)
        }
    }
}