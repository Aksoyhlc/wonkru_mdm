package com.wonkrumdm.core

import android.content.Context
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import com.wonkrumdm.api.settings.AccessibilityServicesChangeEvent
import com.wonkrumdm.api.settings.SystemSettingsEventAPI
import com.wonkrumdm.logging.WLog
import io.flutter.plugin.common.BinaryMessenger

object AccessibilityAllowlistWatcher {

    private const val TAG = "AccessibilityAllowlist"
    private const val DEBOUNCE_MS = 400L

    @Volatile
    private var appContext: Context? = null
    private var flutterEvents: SystemSettingsEventAPI? = null

    private val mainHandler = Handler(Looper.getMainLooper())
    private val notifyRunnable = Runnable { notifyFlutter() }

    private val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
        override fun onChange(selfChange: Boolean) {
            scheduleNotify()
        }
    }

    @Volatile
    private var started = false

    fun start(context: Context, messenger: BinaryMessenger) {
        if (started) return
        started = true
        val ctx = context.applicationContext
        appContext = ctx
        flutterEvents = SystemSettingsEventAPI(messenger)

        val uri = Settings.Secure.getUriFor(Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
        ctx.contentResolver.registerContentObserver(uri, false, observer)
        scheduleNotify()
        WLog.i(TAG, "Accessibility → SystemSettingsEventAPI notification active")
    }

    private fun scheduleNotify() {
        mainHandler.removeCallbacks(notifyRunnable)
        mainHandler.postDelayed(notifyRunnable, DEBOUNCE_MS)
    }

    private fun notifyFlutter() {
        val api = flutterEvents ?: return
        val ctx = appContext ?: return
        val raw = Settings.Secure.getString(
            ctx.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ).orEmpty()
        val pkgs = parseEnabledPackages(raw).toList()
        val event = AccessibilityServicesChangeEvent(pkgs)
        api.onAccessibilityServicesChanged(event) { result ->
            result.onFailure { e ->
                WLog.w(TAG, "onAccessibilityServicesChanged: ${e.message}")
            }
        }
    }

    private fun parseEnabledPackages(raw: String?): Set<String> {
        if (raw.isNullOrBlank()) return emptySet()
        val out = mutableSetOf<String>()
        for (segment in raw.split(':')) {
            val s = segment.trim()
            if (s.isEmpty()) continue
            val slash = s.indexOf('/')
            val pkg = if (slash > 0) s.substring(0, slash) else s
            if (pkg.isNotEmpty()) out.add(pkg)
        }
        return out
    }
}