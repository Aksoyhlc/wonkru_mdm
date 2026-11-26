package com.wonkrumdm.features.app.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.util.Log
import com.wonkrumdm.api.app.AppEventApi
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.core.utils.FlutterStorageHelper
import com.wonkrumdm.features.launcher_mode.handlers.DefaultLauncherHandler
import com.wonkrumdm.features.launcher_mode.handlers.LauncherPolicyGuard
import com.wonkrumdm.core.receivers.MultiEngineEventRegistry
import com.wonkrumdm.managers.EngineOwnershipManager
import io.flutter.plugin.common.BinaryMessenger
import java.util.concurrent.ConcurrentHashMap

class AppChangeReceiver : BroadcastReceiver {

    private var dynamicApi: AppEventApi? = null

    constructor() : super()

    constructor(api: AppEventApi) : super() {
        this.dynamicApi = api
    }

    companion object {
        private const val TAG = "AppChangeReceiver"

        private val registry = MultiEngineEventRegistry("AppEventApi") { AppEventApi(it) }

        fun initialize(messenger: BinaryMessenger) {
            registry.register(messenger)
        }

        fun dispose(messenger: BinaryMessenger? = null) {
            registry.dispose(messenger)
        }

        private val lastProcessedEvents = ConcurrentHashMap<String, Long>()
        private const val THROTTLE_MS = 1000L

        fun shouldProcessEvent(key: String): Boolean {
            val now = System.currentTimeMillis()
            val lastTime = lastProcessedEvents[key] ?: 0L
            if (now - lastTime < THROTTLE_MS) {
                return false
            }
            lastProcessedEvents[key] = now
            return true
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent == null) return

        val packageName = intent.data?.schemeSpecificPart ?: return

        ensureLauncherPolicy(context)

        val apis = if (dynamicApi != null) listOf(dynamicApi!!) else registry.all()

        if (apis.isEmpty()) {
            Log.w(TAG, "No API available, event will be logged only: $packageName")
            logEvent(context, packageName, intent.action)
            return
        }

        val actionType = when (intent.action) {
            Intent.ACTION_PACKAGE_ADDED, Intent.ACTION_PACKAGE_REPLACED -> "INSTALL"
            Intent.ACTION_PACKAGE_REMOVED, Intent.ACTION_PACKAGE_FULLY_REMOVED -> "UNINSTALL"
            else -> intent.action
        }
        val actionKey = "$actionType|$packageName"

        if (!shouldProcessEvent(actionKey)) {
            Log.d(TAG, "Duplicate event ignored: $actionKey ($packageName)")
            return
        }

        when (intent.action) {
            Intent.ACTION_PACKAGE_ADDED,
            Intent.ACTION_PACKAGE_REPLACED,
            Intent.ACTION_PACKAGE_CHANGED -> {
                val isReplacing = intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)
                val type = if (isReplacing) "UPDATED" else "INSTALLED"

                Log.d(TAG, "App $type: $packageName")
                for (api in apis) {
                    api.onAppStatusChanged(packageName, type) { result ->
                        result.exceptionOrNull()?.let { e ->
                            Log.w(TAG, "onAppStatusChanged callback failed", e)
                        }
                    }
                }
            }

            Intent.ACTION_PACKAGE_FULLY_REMOVED, Intent.ACTION_PACKAGE_REMOVED -> {
                if (!intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)) {
                     Log.d(TAG, "App UNINSTALLED: $packageName")
                     for (api in apis) {
                         api.onAppStatusChanged(packageName, "UNINSTALLED") { result ->
                             result.exceptionOrNull()?.let { e ->
                                 Log.w(TAG, "onAppStatusChanged callback failed", e)
                             }
                         }
                     }
                }
            }
        }
    }

    private fun logEvent(context: Context?, packageName: String, action: String?) {
        if (context == null) return
        try {
            val storage = FlutterStorageHelper.getInstance(context)
            val events = storage.getStringSet(Constants.KEY_APP_EVENTS)?.toMutableSet() ?: mutableSetOf()
            val eventType = when (action) {
                Intent.ACTION_PACKAGE_ADDED -> "INSTALLED"
                Intent.ACTION_PACKAGE_REPLACED -> "UPDATED"
                Intent.ACTION_PACKAGE_REMOVED, Intent.ACTION_PACKAGE_FULLY_REMOVED -> "UNINSTALLED"
                else -> "UNKNOWN"
            }
            events.add("$packageName|$eventType|${System.currentTimeMillis()}")
            storage.setStringSet(Constants.KEY_APP_EVENTS, events)
            Log.d(TAG, "Event queued for later: $packageName -> $eventType")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to queue event: ${e.message}")
        }
    }

    private fun ensureLauncherPolicy(context: Context?) {
        if (context == null) return
        val dpm = context.getSystemService(DevicePolicyManager::class.java)
        val admin = ComponentName(context, MdmDeviceAdminReceiver::class.java)
        val launcherHandler = DefaultLauncherHandler(context, dpm, admin)
        val guard = LauncherPolicyGuard(context, launcherHandler, EngineOwnershipManager(context))
        guard.ensureDefaultLauncher()
    }
}