package com.wonkrumdm.features.launcher_mode.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.util.Log
import com.wonkrumdm.MainActivity
import com.wonkrumdm.core.BaseMdmManager

class DefaultLauncherHandler(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : BaseMdmManager(context, dpm, adminComponent) {

    override val logTag = "DefaultLauncherHandler"

    private val launcherPrefs =
        context.getSharedPreferences("wonkru_launcher_prefs", Context.MODE_PRIVATE)

    fun setPreferredHomeActivityOnly(packageName: String): Map<String, Any?> {
        return try {
            if (!isDeviceOwner()) {
                return errorResultMap("Device Owner permission required for launcher assignment.")
            }

            val activityName = ComponentName(packageName, MainActivity::class.java.name)
            dpm.addPersistentPreferredActivity(adminComponent, homeFilter(), activityName)

            if (isOurAppDefaultLauncher()) {
                Log.d(logTag, "Launcher assigned via DPM: $packageName")
                return successResultMap("Launcher set successfully.")
            }

            // Some OEM builds/Android versions ignore the persistent preferred
            // activity for the HOME intent. Fall back to hiding the other home
            // candidates for the user so ours is the only one left. Restored by
            // clearHomeIntentHandler() (the "Close Launcher Mode" action).
            val hidden = hideOtherHomeCandidates(packageName)
            if (!isOurAppDefaultLauncher()) {
                return errorResultMap(
                    "Launcher assignment could not be verified. HOME intent still resolves to another launcher."
                )
            }
            Log.d(logTag, "Launcher assigned by hiding other launchers: $hidden")
            successResultMap("Launcher set successfully.")
        } catch (e: Exception) {
            Log.e(logTag, "Failed to set launcher", e)
            errorResultMap("Failed to set launcher: ${e.message}")
        }
    }

    fun isOurAppDefaultLauncher(): Boolean {
        val resolveInfo = context.packageManager.resolveActivity(
            homeIntent(),
            PackageManager.MATCH_DEFAULT_ONLY
        )
        return resolveInfo?.activityInfo?.packageName == context.packageName
    }

    fun clearHomeIntentHandler(packageName: String): Map<String, Any?> {
        return try {
            showHiddenHomeCandidates()

            dpm.clearPackagePersistentPreferredActivities(adminComponent, context.packageName)

            context.packageManager.clearPackagePreferredActivities(context.packageName)

            resetDefaultLauncherToSystem(context.packageName)

            Log.d(logTag, "Launcher cleared and default reset: ${context.packageName}")
            successResultMap("Launcher cleared, default launcher reset.")
        } catch (e: Exception) {
            Log.e(logTag, "Failed to clear launcher", e)
            errorResultMap("Failed to clear launcher: ${e.message}")
        }
    }

    private fun homeIntent(): Intent = Intent(Intent.ACTION_MAIN).apply {
        addCategory(Intent.CATEGORY_HOME)
        addCategory(Intent.CATEGORY_DEFAULT)
    }

    private fun homeFilter(): IntentFilter = IntentFilter(Intent.ACTION_MAIN).apply {
        addCategory(Intent.CATEGORY_HOME)
        addCategory(Intent.CATEGORY_DEFAULT)
    }

    private fun hideOtherHomeCandidates(keepPackage: String): List<String> {
        val hidden = mutableListOf<String>()
        for (pkg in homeCandidatePackages()) {
            if (pkg == keepPackage || pkg == FALLBACK_HOME_PACKAGE) continue
            if (dpm.setApplicationHidden(adminComponent, pkg, true)) hidden.add(pkg)
        }
        if (hidden.isNotEmpty()) {
            launcherPrefs.edit().putStringSet(KEY_HIDDEN, hidden.toSet()).apply()
        }
        return hidden
    }

    private fun showHiddenHomeCandidates() {
        // Enumerate home candidates including packages already hidden for the
        // user, so a lost prefs file (e.g. after a reinstall) cannot leave the
        // system launcher hidden forever.
        for (pkg in homeCandidatePackages()) {
            if (pkg == context.packageName || pkg == FALLBACK_HOME_PACKAGE) continue
            dpm.setApplicationHidden(adminComponent, pkg, false)
        }
        launcherPrefs.edit().remove(KEY_HIDDEN).apply()
    }

    private fun homeCandidatePackages(): List<String> {
        val infos = context.packageManager.queryIntentActivities(
            homeIntent(),
            PackageManager.MATCH_DISABLED_COMPONENTS or
                PackageManager.MATCH_UNINSTALLED_PACKAGES or
                PackageManager.MATCH_ALL
        )
        return infos.mapNotNull { it.activityInfo?.packageName }.distinct()
    }

    private fun resetDefaultLauncherToSystem(excludePackageName: String) {
        if (!isDeviceOwner()) return
        val resolveList = context.packageManager.queryIntentActivities(
            homeIntent(),
            PackageManager.MATCH_ALL
        )
        val otherLauncher = resolveList.firstOrNull { info ->
            info.activityInfo?.packageName != null &&
                info.activityInfo.packageName != excludePackageName
        } ?: return
        val component = ComponentName(
            otherLauncher.activityInfo.packageName,
            otherLauncher.activityInfo.name
        )
        dpm.addPersistentPreferredActivity(adminComponent, homeFilter(), component)
        Log.d(logTag, "Default launcher reset: ${component.packageName}")
    }

    private fun successResultMap(message: String): Map<String, Any?> = mapOf(
        "success" to true,
        "message" to message
    )

    private fun errorResultMap(message: String): Map<String, Any?> = mapOf(
        "success" to false,
        "message" to message
    )

    companion object {
        private const val KEY_HIDDEN = "hidden_home_packages"
        private const val FALLBACK_HOME_PACKAGE = "com.android.settings"
    }
}
