package com.wonkrumdm.features.app.handlers

import android.app.PendingIntent
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInstaller
import android.os.Build
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.MdmResult
import java.io.File
import java.io.FileInputStream

class AppInstallerHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "AppInstallerHandler"

    fun installApk(apkPath: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val file = File(apkPath)
            if (!file.exists()) return errorResult("APK file not found: $apkPath")

            val packageInfo = context.packageManager.getPackageArchiveInfo(apkPath, 0)
            val packageName = packageInfo?.packageName

            val installer = context.packageManager.packageInstaller
            val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)

            if (packageName != null) {
                params.setAppPackageName(packageName)
            }

            val sessionId = installer.createSession(params)
            val session = installer.openSession(sessionId)

            FileInputStream(file).use { input ->
                session.openWrite("mdm_install", 0, -1).use { output ->
                    input.copyTo(output)
                    session.fsync(output)
                }
            }

            val intent = Intent(Constants.ACTION_INSTALL_COMPLETE)
            intent.setClass(context, com.wonkrumdm.features.app.receivers.InstallResultReceiver::class.java)
            intent.setPackage(context.packageName)

            val restrictionLifted =
                com.wonkrumdm.features.restriction.handlers.RestrictionHandler.liftInstallRestrictionSafely(context, dpm, adminComponent)

            if (restrictionLifted) {
                intent.putExtra("restore_install_restriction", true)
            }

            if (packageName != null) {
                intent.putExtra("target_package_name", packageName)
            }

            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                sessionId,
                intent,
                flags
            )

            session.commit(pendingIntent.intentSender)
            session.close()

            successResult("Install session started. Package: ${packageName ?: "unknown"}")
        } catch (e: Exception) {
            errorResult("Install error (apkPath=$apkPath): ${e.message}")
        }
    }

    fun uninstallApp(packageName: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val intent = Intent(Constants.ACTION_UNINSTALL_COMPLETE)
            // Use an explicit target for the non-exported receiver.
            intent.setClass(context, com.wonkrumdm.features.app.receivers.InstallResultReceiver::class.java)
            intent.setPackage(context.packageName)

            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                intent,
                flags
            )

            context.packageManager.packageInstaller.uninstall(packageName, pendingIntent.intentSender)

            successResult("Uninstall initiated: $packageName")
        } catch (e: Exception) {
            errorResult("Uninstall error (packageName=$packageName): ${e.message}")
        }
    }
}