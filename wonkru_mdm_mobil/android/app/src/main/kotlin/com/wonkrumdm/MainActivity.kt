package com.wonkrumdm

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat
import com.wonkrumdm.core.provisioning.SetupExtras
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.core.watchdog.WatchdogScheduler
import com.wonkrumdm.core.watchdog.WatchdogService
import com.wonkrumdm.features.display.DisplayImpl
import com.wonkrumdm.features.launcher_mode.handlers.LauncherPolicyGuard
import com.wonkrumdm.features.launcher_mode.handlers.DefaultLauncherHandler
import com.wonkrumdm.features.restriction.handlers.RestrictionHandler
import com.wonkrumdm.logging.WLog
import com.wonkrumdm.logging.WLogChannel
import com.wonkrumdm.managers.EngineOwnershipManager
import com.wonkrumdm.managers.MdmBroadcastManager
import com.wonkrumdm.managers.MdmNativeRegistrar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        @Volatile
        var isAlive: Boolean = false
            private set

        private const val WATCHDOG_RECHECK_DELAY_MS = 2000L
    }

    private lateinit var broadcastManager: MdmBroadcastManager
    private val ownershipManager by lazy { EngineOwnershipManager(this) }
    private var displayImplRef: DisplayImpl? = null
    private var appEventMessenger: BinaryMessenger? = null

    fun setDisplayImplForCleanup(impl: DisplayImpl?) {
        displayImplRef = impl
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SetupExtras.persistFrom(this, intent)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return MdmApplication.getEngineForActivity(context)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        isAlive = true

        super.configureFlutterEngine(flutterEngine)

        WLog.init(this)
        WLogChannel.init(flutterEngine.dartExecutor.binaryMessenger)

        ownershipManager.setOwner(EngineOwnershipManager.OWNER_UI)
        checkAndRestoreInstallRestriction()
        appEventMessenger = flutterEngine.dartExecutor.binaryMessenger
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val existingManager = MdmNativeRegistrar.getBroadcastManager()
        if (existingManager != null) {
            broadcastManager = existingManager
            MdmNativeRegistrar.registerWithActivity(this, messenger, this)
        } else {
            broadcastManager = MdmNativeRegistrar.registerAll(this, messenger, this)
        }
        setupWatchdogTestChannel(messenger)
    }

    override fun onStart() {
        super.onStart()
        isAlive = true
    }

    private fun setupWatchdogTestChannel(messenger: BinaryMessenger) {
        MethodChannel(messenger, "com.wonkrumdm/watchdog").setMethodCallHandler { call, result ->
            when (call.method) {
                "startWatchdog" -> {
                    WatchdogScheduler.start(this)
                    result.success(null)
                }
                "stopWatchdog" -> {
                    WatchdogScheduler.stop(this)
                    result.success(null)
                }
                "runWatchdogCheckNow" -> {
                    val intent = Intent(this, WatchdogService::class.java).apply {
                        action = WatchdogService.ACTION_RUN_CHECK_NOW
                    }
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onBackPressed() {
        if (ownershipManager.isLauncherModeEnabled()) {
            return
        }
        super.onBackPressed()
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (ownershipManager.isLauncherModeEnabled()) {
            launcherPolicyGuard().ensureDefaultLauncher()
        }
    }

    override fun onResume() {
        super.onResume()
        isAlive = true
        if (ownershipManager.isLauncherModeEnabled()) {
            launcherPolicyGuard().ensureDefaultLauncher()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        SetupExtras.persistFrom(this, intent)
    }

    override fun onDestroy() {
        isAlive = false

        super.onDestroy()

        displayImplRef?.onActivityDestroy()
        displayImplRef = null
        if (::broadcastManager.isInitialized) {
            broadcastManager.unregisterAll()
        }
        MdmNativeRegistrar.clearBroadcastManager()
        MdmNativeRegistrar.disposeAppEventApis(appEventMessenger)
        appEventMessenger = null

        val appContext = applicationContext
        val launcherModeActive = EngineOwnershipManager(appContext).isLauncherModeEnabled()
        if (!launcherModeActive) {
            Handler(Looper.getMainLooper()).postDelayed({
                val intent = Intent(appContext, WatchdogService::class.java).apply {
                    action = WatchdogService.ACTION_RUN_CHECK_NOW
                }
                ContextCompat.startForegroundService(appContext, intent)
            }, WATCHDOG_RECHECK_DELAY_MS)
        }
    }

    private fun launcherPolicyGuard(): LauncherPolicyGuard {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = ComponentName(this, MdmDeviceAdminReceiver::class.java)
        return LauncherPolicyGuard(this, DefaultLauncherHandler(this, dpm, admin), ownershipManager)
    }

    private fun checkAndRestoreInstallRestriction() {
        RestrictionHandler.checkAndRestoreInstallRestriction(this)
    }
}
