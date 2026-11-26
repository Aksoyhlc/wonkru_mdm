package com.wonkrumdm.features.app.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInstaller
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.os.UserManager
import android.util.Log
import com.wonkrumdm.api.app.AppEventApi
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.core.receivers.MultiEngineEventRegistry
import com.wonkrumdm.core.utils.FlutterStorageHelper
import io.flutter.plugin.common.BinaryMessenger
import java.io.File

class InstallResultReceiver : BroadcastReceiver {

    private var dynamicApi: AppEventApi? = null

    constructor() : super()

    constructor(api: AppEventApi) : super() {
        this.dynamicApi = api
    }

    companion object {
        private const val TAG = "InstallResultReceiver"

        private val registry = MultiEngineEventRegistry("InstallResultApi") { AppEventApi(it) }

        /** Validate package names before using them in file paths. */
        private val PACKAGE_NAME_PATTERN =
            Regex("^[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z][A-Za-z0-9_]*)+$")

        private const val MAX_PACKAGE_NAME_LENGTH = 255

        fun isValidPackageName(name: String?): Boolean =
            name != null &&
                name.length <= MAX_PACKAGE_NAME_LENGTH &&
                PACKAGE_NAME_PATTERN.matches(name)

        fun initialize(messenger: BinaryMessenger) {
            registry.register(messenger)
        }

        fun dispose(messenger: BinaryMessenger? = null) {
            registry.dispose(messenger)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action == Constants.ACTION_INSTALL_COMPLETE || action == Constants.ACTION_UNINSTALL_COMPLETE) {
            val status = intent.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE)
            val message = intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: ""

            val packageName = intent.getStringExtra(PackageInstaller.EXTRA_PACKAGE_NAME)
                ?: intent.getStringExtra(Constants.EXTRA_TARGET_PACKAGE_NAME)
                ?: "unknown"

            val apis = if (dynamicApi != null) listOf(dynamicApi!!) else registry.all()

            if (apis.isEmpty()) {
                Log.w(TAG, "No API available to report result ($action): $packageName")
                if (action == Constants.ACTION_INSTALL_COMPLETE) deleteApkFile(context, packageName)
                return
            }

            if (action == Constants.ACTION_INSTALL_COMPLETE) {
                 handleInstallResult(context, packageName, status, message, intent, apis)
            } else {
                 handleUninstallResult(packageName, status, message, apis)
            }
        }
    }

    private fun handleInstallResult(context: Context, packageName: String, status: Int, message: String, intent: Intent, apis: List<AppEventApi>) {
        when (status) {
            PackageInstaller.STATUS_SUCCESS -> {
                for (api in apis) {
                    api.onInstallResult(packageName, true, "Install successful") {}
                }
            }
            else -> {
                for (api in apis) {
                    api.onInstallResult(packageName, false, "Error: $status - $message") {}
                }
            }
        }
        deleteApkFile(context, packageName)

        val restoreRestriction = intent.getBooleanExtra(Constants.EXTRA_RESTORE_INSTALL_RESTRICTION, false)
        if (restoreRestriction) {
            try {
                 val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                 val admin = ComponentName(context, MdmDeviceAdminReceiver::class.java)

                 dpm.addUserRestriction(admin, UserManager.DISALLOW_INSTALL_APPS)
                 Log.i(TAG, "Install restriction restored.")

                 FlutterStorageHelper.getInstance(context).setBoolean(Constants.KEY_RESTRICTION_LIFTED, false)
            } catch (e: Exception) {
                 Log.e(TAG, "Error restoring restriction: ${e.message}")
            }
        }
    }

    private fun handleUninstallResult(packageName: String, status: Int, message: String, apis: List<AppEventApi>) {
        when (status) {
            PackageInstaller.STATUS_SUCCESS -> {
                Log.i(TAG, "Uninstall successful: $packageName")
            }
            else -> {
                Log.e(TAG, "Uninstall failed: $packageName, Error: $status - $message")
            }
        }
    }

    private fun deleteApkFile(context: Context, packageName: String) {
        if (!isValidPackageName(packageName)) {
            Log.w(TAG, "Invalid package name, APK cleanup skipped")
            return
        }
        try {
            val cacheDir = context.cacheDir
            val apkFile = File(cacheDir, "$packageName.apk")

            if (apkFile.exists()) {
                val deleted = apkFile.delete()
                if (deleted) {
                    Log.i(TAG, "APK file deleted: ${apkFile.absolutePath}")
                } else {
                    Log.w(TAG, "APK file could not be deleted: ${apkFile.absolutePath}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error deleting APK file: ${e.message}")
        }
    }
}
