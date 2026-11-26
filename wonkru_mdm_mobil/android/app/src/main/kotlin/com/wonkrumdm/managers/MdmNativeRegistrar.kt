package com.wonkrumdm.managers

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.MainActivity
import com.wonkrumdm.api.app.AppApi
import com.wonkrumdm.api.audio.AudioPig
import com.wonkrumdm.api.certificate.CertificateAPI
import com.wonkrumdm.api.display.DisplayAPI
import com.wonkrumdm.api.keyguard.KeyguardAPI
import com.wonkrumdm.api.launcher_mode.LauncherModeApi
import com.wonkrumdm.api.password.PasswordPolicyAPI
import com.wonkrumdm.api.restriction.RestrictionAPI
import com.wonkrumdm.api.settings.SystemSettingsAPI
import com.wonkrumdm.api.system_notification.SystemNotificationAPI
import com.wonkrumdm.api.wifi.WifiAPI
import com.wonkrumdm.core.AccessibilityAllowlistWatcher
import com.wonkrumdm.features.app.AppImpl
import com.wonkrumdm.features.app.receivers.AppChangeReceiver
import com.wonkrumdm.features.app.receivers.InstallResultReceiver
import com.wonkrumdm.features.audio.AudioImpl
import com.wonkrumdm.features.audio.receivers.VolumeReceiver
import com.wonkrumdm.features.certificate.CertificateImpl
import com.wonkrumdm.features.display.DisplayImpl
import com.wonkrumdm.features.keyguard.KeyguardImpl
import com.wonkrumdm.features.launcher_mode.LauncherModeImpl
import com.wonkrumdm.features.notification.NotificationHelper
import com.wonkrumdm.features.password.PasswordImpl
import com.wonkrumdm.features.restriction.RestrictionImpl
import com.wonkrumdm.features.settings.SystemSettingsImpl
import com.wonkrumdm.features.wifi.WifiImpl
import com.wonkrumdm.features.wifi.receivers.WifiStateReceiver
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.logging.WLogChannel
import io.flutter.plugin.common.BinaryMessenger

object MdmNativeRegistrar {
    private var broadcastManagerRef: MdmBroadcastManager? = null

    fun getBroadcastManager(): MdmBroadcastManager? = broadcastManagerRef

    fun clearBroadcastManager() {
        broadcastManagerRef = null
    }

    fun registerWithoutActivity(context: Context, messenger: BinaryMessenger) {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = adminComponent(context)
        registerPigeonApis(context, dpm, adminComponent, messenger, activity = null)
        registerAppEventApis(messenger)
        WLogChannel.init(messenger)
        AccessibilityAllowlistWatcher.start(context, messenger)
        broadcastManagerRef = createAndRegisterBroadcastManager(context, messenger)
    }

    fun registerWithActivity(context: Context, messenger: BinaryMessenger, activity: Activity) {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = adminComponent(context)
        registerActivityBoundApis(context, dpm, adminComponent, messenger, activity)
    }

    fun registerAll(context: Context, messenger: BinaryMessenger, activity: Activity?): MdmBroadcastManager {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = adminComponent(context)
        registerPigeonApis(context, dpm, adminComponent, messenger, activity)
        registerAppEventApis(messenger)
        AccessibilityAllowlistWatcher.start(context, messenger)
        val manager = createAndRegisterBroadcastManager(context, messenger)
        if (activity == null) broadcastManagerRef = manager
        return manager
    }

    fun disposeAppEventApis() {
        disposeAppEventApis(null)
    }

    fun disposeAppEventApis(messenger: BinaryMessenger?) {
        AppChangeReceiver.dispose(messenger)
        InstallResultReceiver.dispose(messenger)
        VolumeReceiver.dispose(messenger)
        WifiStateReceiver.dispose(messenger)
    }

    private fun adminComponent(context: Context) =
        ComponentName(context, MdmDeviceAdminReceiver::class.java)

    private fun registerAppEventApis(messenger: BinaryMessenger) {
        AppChangeReceiver.initialize(messenger)
        InstallResultReceiver.initialize(messenger)
        VolumeReceiver.initialize(messenger)
        WifiStateReceiver.initialize(messenger)
    }

    private fun createAndRegisterBroadcastManager(
        context: Context,
        messenger: BinaryMessenger
    ): MdmBroadcastManager =
        MdmBroadcastManager(context, messenger).apply {
            initialize()
            registerAll()
        }

    private fun registerPigeonApis(
        context: Context,
        dpm: DevicePolicyManager,
        adminComponent: ComponentName,
        messenger: BinaryMessenger,
        activity: Activity?
    ) {
        RestrictionAPI.setUp(messenger, RestrictionImpl(context, dpm, adminComponent))
        AppApi.setUp(messenger, AppImpl(context, dpm, adminComponent))
        WifiAPI.setUp(messenger, WifiImpl(context, dpm, adminComponent))
        CertificateAPI.setUp(messenger, CertificateImpl(context, dpm, adminComponent))
        PasswordPolicyAPI.setUp(messenger, PasswordImpl(context, dpm, adminComponent))
        AudioPig.setUp(messenger, AudioImpl(context, dpm, adminComponent, messenger))
        SystemSettingsAPI.setUp(messenger, SystemSettingsImpl(context, dpm, adminComponent))
        KeyguardAPI.setUp(messenger, KeyguardImpl(context, dpm, adminComponent))
        SystemNotificationAPI.setUp(messenger, NotificationHelper(context))

        if (activity != null) {
            registerActivityBoundApis(context, dpm, adminComponent, messenger, activity)
        }
    }

    private fun registerActivityBoundApis(
        context: Context,
        dpm: DevicePolicyManager,
        adminComponent: ComponentName,
        messenger: BinaryMessenger,
        activity: Activity
    ) {
        val displayImpl = DisplayImpl(context, dpm, adminComponent, messenger, activity)
        DisplayAPI.setUp(messenger, displayImpl)
        (activity as? MainActivity)?.setDisplayImplForCleanup(displayImpl)
        LauncherModeApi.setUp(messenger, LauncherModeImpl(activity, dpm, adminComponent))
    }
}
