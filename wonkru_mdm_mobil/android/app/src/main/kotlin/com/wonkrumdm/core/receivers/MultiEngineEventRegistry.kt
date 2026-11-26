package com.wonkrumdm.core.receivers

import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import java.util.concurrent.ConcurrentHashMap

class MultiEngineEventRegistry<T>(
    private val label: String,
    private val factory: (BinaryMessenger) -> T
) {
    private val apis = ConcurrentHashMap<BinaryMessenger, T>()

    fun register(messenger: BinaryMessenger): T {
        val api = apis.getOrPut(messenger) { factory(messenger) }
        Log.d(TAG, "$label registered (${apis.size} engine(s))")
        return api
    }

    fun dispose(messenger: BinaryMessenger? = null) {
        if (messenger != null) apis.remove(messenger) else apis.clear()
        Log.d(TAG, "$label disposed (${apis.size} remaining)")
    }

    fun all(): List<T> = apis.values.toList()

    companion object {
        private const val TAG = "EventRegistry"
    }
}
