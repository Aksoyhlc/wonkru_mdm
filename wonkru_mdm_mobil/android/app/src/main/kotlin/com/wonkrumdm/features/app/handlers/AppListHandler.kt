package com.wonkrumdm.features.app.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import androidx.core.graphics.createBitmap
import com.wonkrumdm.api.app.NativeAppInfo
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import java.io.ByteArrayOutputStream

class AppListHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "AppListHandler"
    private val pm: PackageManager = context.packageManager

    fun getInstalledApps(
        includeSystemApps: Boolean,
        filterPackages: List<String>?
    ): MdmResult {
        val apps = mutableListOf<NativeAppInfo?>()
        var flags = PackageManager.GET_META_DATA

        val packages = pm.getInstalledPackages(flags)
        val filterSet = filterPackages?.toHashSet()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            val packageName = pkg.packageName

            if (!includeSystemApps && isSystem) continue

            if (filterSet != null && filterSet.isNotEmpty()) {
                if (!filterSet.contains(packageName)) continue
            }

            @Suppress("DEPRECATION")
            val vCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                pkg.longVersionCode
            } else {
                pkg.versionCode.toLong()
            }

            val info = NativeAppInfo(
                packageName = packageName,
                appName = appInfo.loadLabel(pm).toString(),
                versionName = pkg.versionName,
                versionCode = vCode,
                isSystemApp = isSystem,
                isUninstallBlocked = dpm.isUninstallBlocked(adminComponent, packageName)
            )

            apps.add(info)
        }
        return successResult("Listed ${apps.size} apps.", apps)
    }

    fun getAppIcon(packageName: String): ByteArray? {
        return try {
            val drawable = pm.getApplicationIcon(packageName)
            drawableToByteArray(drawable)
        } catch (_: Exception) {
            null
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = if (drawable is BitmapDrawable) {
            drawable.bitmap
        } else {
            val bmp = createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight)
            val canvas = Canvas(bmp)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bmp
        }
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    fun launchApp(packageName: String): MdmResult {
        return try {
            val launchIntent = pm.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                com.wonkrumdm.features.app.utils.AppUtils.startApp(context, packageName)
                successResult("App launched: $packageName")
            } else {
                errorResult("Cannot launch app (not installed or not launchable): $packageName")
            }
        } catch (e: Exception) {
            errorResult("Launch error: ${e.message}")
        }
    }

    fun openAppSettings(packageName: String): MdmResult {
        return try {
            com.wonkrumdm.features.app.utils.AppUtils.openAppSettings(context, packageName)
            successResult("App settings opened: $packageName")
        } catch (e: Exception) {
            errorResult("Cannot open settings: ${e.message}")
        }
    }
}