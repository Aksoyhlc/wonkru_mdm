package com.wonkrumdm.features.app

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.app.AppApi
import com.wonkrumdm.features.app.handlers.AppInstallerHandler
import com.wonkrumdm.features.app.handlers.AppListHandler
import com.wonkrumdm.features.app.handlers.AppRestrictionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class AppImpl(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : AppApi {

    private val listHandler = AppListHandler(context, dpm, adminComponent)
    private val installerHandler = AppInstallerHandler(context, dpm, adminComponent)
    private val restrictionHandler = AppRestrictionHandler(context, dpm, adminComponent)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun getInstalledApps(
        includeSystemApps: Boolean,
        filterPackages: List<String>?,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = listHandler.getInstalledApps(includeSystemApps, filterPackages)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getAppIcon(
        packageName: String,
        callback: (Result<ByteArray?>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val iconBytes = listHandler.getAppIcon(packageName)
                callback(Result.success(iconBytes))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun installApk(
        apkPath: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = installerHandler.installApk(apkPath)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun uninstallApp(
        packageName: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = installerHandler.uninstallApp(packageName)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun launchApp(
        packageName: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch {
            try {
                val result = listHandler.launchApp(packageName)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun clearAppData(
        packageName: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = restrictionHandler.clearAppData(packageName)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun setUninstallBlocked(
        packageName: String,
        blocked: Boolean,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = restrictionHandler.setUninstallBlocked(packageName, blocked)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun openAppSettings(
        packageName: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = listHandler.openAppSettings(packageName)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}
