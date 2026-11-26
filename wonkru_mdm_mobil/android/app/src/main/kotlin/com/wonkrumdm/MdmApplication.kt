package com.wonkrumdm

import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import com.wonkrumdm.core.AppLifecycleObserver
import com.wonkrumdm.core.AnrWatchdog
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.SelfPermissionManager
import com.wonkrumdm.logging.WLog
import com.wonkrumdm.logging.WLogChannel
import com.wonkrumdm.core.utils.FlutterStorageHelper
import com.wonkrumdm.core.watchdog.WatchdogScheduler
import com.wonkrumdm.managers.EngineOwnershipManager
import com.wonkrumdm.managers.MdmNativeRegistrar
import androidx.core.content.edit
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MdmApplication : Application() {

    companion object {
        private const val ENGINE_CACHE_ID = "wonkrumdm_main_engine"
        @Volatile
        private var currentEngineIsMain: Boolean = false

        fun getEngine(): FlutterEngine? = FlutterEngineCache.getInstance().get(ENGINE_CACHE_ID)

        fun getEngineForActivity(context: Context): FlutterEngine {
            val cached = FlutterEngineCache.getInstance().get(ENGINE_CACHE_ID)
            if (cached != null && !currentEngineIsMain) {
                FlutterEngineCache.getInstance().remove(ENGINE_CACHE_ID)
                cached.destroy()
            }
            return getEngine() ?: getOrCreateEngineWithMain(context)
        }

        fun getOrCreateEngineWithMain(context: Context): FlutterEngine {
            FlutterEngineCache.getInstance().get(ENGINE_CACHE_ID)?.let { return it }
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(context)
            loader.ensureInitializationComplete(context, null)
            val engine = FlutterEngine(context)
            engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            FlutterEngineCache.getInstance().put(ENGINE_CACHE_ID, engine)
            currentEngineIsMain = true
            MdmNativeRegistrar.registerWithoutActivity(context, engine.dartExecutor.binaryMessenger)
            return engine
        }

        private fun isInstallCompleted(context: Context): Boolean {
            return FlutterStorageHelper.getInstance(context).hasNonEmptyValue(Constants.KEY_INSTALL_TIME)
        }

        private const val PREFS_NAME = "wonkrumdm_process"
        private const val KEY_PID = "pid"
        private const val KEY_LAST_ALIVE = "last_alive"
        private const val HEARTBEAT_INTERVAL = 5_000L

        private val heartbeatThread = HandlerThread("mdm-heartbeat").apply { start() }
        private val heartbeatHandler = Handler(heartbeatThread.looper)
        private var heartbeatRunnable: Runnable? = null

        fun startHeartbeat(context: Context) {
            if (heartbeatRunnable != null) return

            heartbeatRunnable = object : Runnable {
                override fun run() {
                    updateHeartbeat(context)
                    heartbeatHandler.postDelayed(this, HEARTBEAT_INTERVAL)
                }
            }
            heartbeatHandler.post(heartbeatRunnable!!)
        }

        fun stopHeartbeat() {
            heartbeatRunnable?.let { heartbeatHandler.removeCallbacks(it) }
            heartbeatRunnable = null
        }

        private fun updateHeartbeat(context: Context) {
            try {
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                    .edit {
                        putLong(KEY_LAST_ALIVE, System.currentTimeMillis())
                    }
            } catch (e: Exception) {
                WLog.w("MdmApplication", "heartbeat write failed", e)
            }
        }

        fun startContinuousServices(context: Context) {
            startHeartbeat(context)
            WatchdogScheduler.start(context)
            AnrWatchdog.start()
        }
    }

    override fun onCreate() {
        super.onCreate()
        WLog.init(this)

        SelfPermissionManager.grantSelfRuntimePermissions(this)

        startContinuousServices(this)

        val launcherMode = EngineOwnershipManager(this).isLauncherModeEnabled()

        val installCompleted = isInstallCompleted(this)
        val shouldCreateEngineAtStartup = FlutterEngineCache.getInstance().get(ENGINE_CACHE_ID) == null &&
                (launcherMode || installCompleted)
        if (shouldCreateEngineAtStartup) {
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(this)
            loader.ensureInitializationComplete(this, null)
            val path = loader.findAppBundlePath()
            val engine = FlutterEngine(this)

            if (launcherMode) {
                engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
                FlutterEngineCache.getInstance().put(ENGINE_CACHE_ID, engine)
                currentEngineIsMain = true
            } else {
                val headlessEntry = DartExecutor.DartEntrypoint(path, "headlessMain")
                engine.dartExecutor.executeDartEntrypoint(headlessEntry)
                FlutterEngineCache.getInstance().put(ENGINE_CACHE_ID, engine)
                currentEngineIsMain = false
            }

            MdmNativeRegistrar.registerWithoutActivity(this, engine.dartExecutor.binaryMessenger)
        }

        AppLifecycleObserver.init()

        val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        prefs.edit {
            putInt(KEY_PID, android.os.Process.myPid())
                .putLong(KEY_LAST_ALIVE, System.currentTimeMillis())
        }
    }
}