package com.wonkrumdm.logging

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import com.wonkrumdm.BuildConfig
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.utils.FlutterStorageHelper
import org.json.JSONObject
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.UUID
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.atomic.AtomicInteger

object WLog {

    private const val SQLITE_BIND_BATCH = 500
    private const val MAX_QUERY_LIMIT = 2000
    private const val MILLIS_PER_DAY = 86_400_000L
    private const val MILLIS_PER_SECOND = 1000L

    private lateinit var config: WLogConfig
    private lateinit var dao: LogDao
    private lateinit var deviceId: String
    private var sessionId: String = UUID.randomUUID().toString()
    private var initialized = false

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    private val isoFormat = object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat =
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US)
    }

    private fun formatTimestamp(millis: Long): String = isoFormat.get()!!.format(Date(millis))

    private val memoryBuffer = CopyOnWriteArrayList<LogEntry>()

    @Volatile
    private var roomAvailable = true

    private val mainHandler = Handler(Looper.getMainLooper())
    private var idleRunnable: Runnable? = null

    var onFatalCallback: (() -> Unit)? = null
    var onIdleTimeoutCallback: (() -> Unit)? = null
    var onFlushThresholdCallback: (() -> Unit)? = null

    private val unsyncedCount = AtomicInteger(0)

    @Volatile
    private var flushRequested = false

    fun init(context: Context, config: WLogConfig = WLogConfig()) {
        if (initialized) return
        this.config = loadConfigFromLocal(context) ?: config
        try {
            dao = LogDatabase.getInstance(context).logDao()
            roomAvailable = true
        } catch (e: Exception) {
            android.util.Log.e("WLog", "Room failed to initialize, using in-memory fallback", e)
            roomAvailable = false
        }
        deviceId = FlutterStorageHelper.getInstance(context)
            .getStringValue(Constants.KEY_DEVICE_UUID, null)
            ?: try {
                Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID) ?: "unknown"
            } catch (_: Exception) {
                "unknown"
            }
        initialized = true
        android.util.Log.i("WLog", "Log system initialized (deviceId=$deviceId, session=$sessionId)")
    }

    fun updateConfig(newConfig: WLogConfig) {
        config = newConfig
    }

    private fun loadConfigFromLocal(context: Context): WLogConfig? {
        val jsonStr = FlutterStorageHelper.getInstance(context)
            .getStringValue(Constants.KEY_WLOG_CONFIG, null) ?: return null
        if (jsonStr.isBlank()) return null
        return try {
            val obj = JSONObject(jsonStr)
            val map = mutableMapOf<String, Any?>()
            for (key in obj.keys()) {
                map[key] = obj.get(key)
            }
            WLogConfig.fromJson(map)
        } catch (e: Exception) {
            android.util.Log.w("WLog", "wlog_config parse error, using defaults", e)
            null
        }
    }

    fun v(tag: String, message: String, throwable: Throwable? = null) {
        if (!BuildConfig.DEBUG) return
        log(LogLevel.VERBOSE, tag, message, throwable)
    }

    fun d(tag: String, message: String, throwable: Throwable? = null) {
        if (!BuildConfig.DEBUG) return
        log(LogLevel.DEBUG, tag, message, throwable)
    }

    fun i(tag: String, message: String, throwable: Throwable? = null) {
        log(LogLevel.INFO, tag, message, throwable)
    }

    fun w(tag: String, message: String, throwable: Throwable? = null) {
        log(LogLevel.WARNING, tag, message, throwable)
    }

    fun e(tag: String, message: String, throwable: Throwable? = null) {
        log(LogLevel.ERROR, tag, message, throwable)
    }

    fun fatal(tag: String, message: String, throwable: Throwable? = null) {
        log(LogLevel.FATAL, tag, message, throwable)
        mainHandler.post { onFatalCallback?.invoke() }
    }

    suspend fun getUnsynced(minLevel: LogLevel): List<LogEntry> {
        if (!initialized) return emptyList()
        return try {
            if (roomAvailable) {
                dao.getUnsynced(minLevel.value)
            } else {
                memoryBuffer.filter { it.level >= minLevel.value && it.synced == 0 }
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "getUnsynced error", e)
            emptyList()
        }
    }

    suspend fun markSynced(ids: List<String>) {
        if (!initialized || ids.isEmpty()) return
        try {
            if (roomAvailable) {
                ids.chunked(SQLITE_BIND_BATCH).forEach { chunk -> dao.markSynced(chunk) }
                unsyncedCount.updateAndGet { (it - ids.size).coerceAtLeast(0) }
            } else {
                val idSet = ids.toSet()
                memoryBuffer.replaceAll { entry ->
                    if (entry.id in idSet) entry.copy(synced = 1) else entry
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "markSynced error", e)
        } finally {
            flushRequested = false
        }
    }

    suspend fun getRecent(minLevel: LogLevel, limit: Int): List<LogEntry> {
        if (!initialized) return emptyList()
        val lim = limit.coerceIn(1, MAX_QUERY_LIMIT)
        return try {
            if (roomAvailable) {
                dao.getRecent(minLevel.value, lim)
            } else {
                memoryBuffer
                    .filter { it.level >= minLevel.value }
                    .sortedByDescending { it.timestamp }
                    .take(lim)
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "getRecent error", e)
            emptyList()
        }
    }

    suspend fun deleteAll() {
        if (!initialized) return
        try {
            if (roomAvailable) {
                dao.deleteAll()
            } else {
                memoryBuffer.clear()
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "deleteAll error", e)
        } finally {
            unsyncedCount.set(0)
            flushRequested = false
        }
    }

    suspend fun deleteOldSynced() {
        if (!initialized) return
        try {
            val cutoff = System.currentTimeMillis() - (config.retentionDays * MILLIS_PER_DAY)
            val cutoffStr = formatTimestamp(cutoff)
            if (roomAvailable) {
                dao.deleteOldSynced(cutoffStr)
            } else {
                memoryBuffer.removeAll { it.synced == 1 && it.timestamp < cutoffStr }
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "deleteOldSynced error", e)
        }
    }

    private fun log(level: LogLevel, tag: String, message: String, throwable: Throwable?) {
        if (!initialized) {
            android.util.Log.w("WLog", "WLog not yet initialized: [$level] $tag: $message")
            return
        }

        if (level.value >= config.consoleMinLevel.value) {
            writeToLogcat(level, tag, message, throwable)
        }

        if (level.value >= config.dbMinLevel.value) {
            val entry = LogEntry(
                id = UUID.randomUUID().toString(),
                timestamp = formatTimestamp(System.currentTimeMillis()),
                level = level.value,
                tag = tag,
                message = message,
                stacktrace = throwable?.stackTraceToString(),
                deviceId = deviceId,
                sessionId = sessionId
            )
            persistEntry(entry)
        }

        resetIdleTimer()
    }

    private fun persistEntry(entry: LogEntry) {
        scope.launch {
            try {
                if (roomAvailable) {
                    dao.insert(entry)
                    unsyncedCount.incrementAndGet()
                    enforceCircularBuffer()
                    checkFlushThreshold()
                } else {
                    memoryBuffer.add(entry)
                    if (memoryBuffer.size > config.maxLocalEntries) {
                        memoryBuffer.removeAt(0)
                    }
                }
            } catch (e: Exception) {
                android.util.Log.e("WLog", "Log persist error, falling back to in-memory", e)
                roomAvailable = false
                memoryBuffer.add(entry)
            }
        }
    }

    private suspend fun enforceCircularBuffer() {
        try {
            val total = dao.count()
            if (total <= config.maxLocalEntries) return

            val excess = total - config.maxLocalEntries
            val deletedSynced = dao.deleteOldestSynced(excess)
            if (deletedSynced < excess) {
                dao.deleteOldestUnsynced(excess - deletedSynced)
            }
        } catch (e: Exception) {
            android.util.Log.e("WLog", "Circular buffer enforcement error", e)
        }
    }

    private fun checkFlushThreshold() {
        if (!flushRequested && unsyncedCount.get() >= config.flushThreshold) {
            flushRequested = true
            mainHandler.post { onFlushThresholdCallback?.invoke() }
        }
    }

    private fun writeToLogcat(level: LogLevel, tag: String, message: String, throwable: Throwable?) {
        val logTag = "W/$tag"
        when (level) {
            LogLevel.VERBOSE -> android.util.Log.v(logTag, message, throwable)
            LogLevel.DEBUG -> android.util.Log.d(logTag, message, throwable)
            LogLevel.INFO -> android.util.Log.i(logTag, message, throwable)
            LogLevel.WARNING -> android.util.Log.w(logTag, message, throwable)
            LogLevel.ERROR -> android.util.Log.e(logTag, message, throwable)
            LogLevel.FATAL -> android.util.Log.wtf(logTag, message, throwable)
        }
    }

    private fun resetIdleTimer() {
        idleRunnable?.let { mainHandler.removeCallbacks(it) }
        val runnable = Runnable {
            onIdleTimeoutCallback?.invoke()
        }
        idleRunnable = runnable
        mainHandler.postDelayed(runnable, config.idleFlushSeconds * MILLIS_PER_SECOND)
    }
}
