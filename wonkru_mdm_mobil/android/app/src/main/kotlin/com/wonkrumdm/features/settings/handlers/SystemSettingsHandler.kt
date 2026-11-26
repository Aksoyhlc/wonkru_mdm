package com.wonkrumdm.features.settings.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.view.accessibility.AccessibilityManager
import android.accessibilityservice.AccessibilityServiceInfo
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.logging.WLog

class SystemSettingsHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "SystemSettingsHandler"

    fun canWriteSettings(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.System.canWrite(context)
        } else {
            true
        }
    }

    fun canUseDpmForSetting(key: String): Boolean {
        return key in listOf(
            Settings.System.SCREEN_BRIGHTNESS,
            Settings.System.SCREEN_BRIGHTNESS_MODE,
            Settings.System.SCREEN_OFF_TIMEOUT
        )
    }

    private fun writeSetting(key: String, value: String, type: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        if (type == "system" && canUseDpmForSetting(key)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                return try {
                    dpm.setSystemSetting(adminComponent, key, value)
                    successResult("Set via DPM: $key = $value")
                } catch (e: Exception) {
                    errorResult("DPM error: ${e.message}")
                }
            }
        }

        return try {
            val success = when (type.lowercase()) {
                "global" -> {
                    if (isDeviceOwner()) {
                        dpm.setGlobalSetting(adminComponent, key, value)
                        true
                    } else {
                        Settings.Global.putString(context.contentResolver, key, value)
                    }
                }
                "secure" -> {
                    if (isDeviceOwner()) {
                        dpm.setSecureSetting(adminComponent, key, value)
                        true
                    } else {
                        Settings.Secure.putString(context.contentResolver, key, value)
                    }
                }
                "system" -> {
                    if (!canWriteSettings()) {
                        return errorResult("WRITE_SETTINGS permission required. Run: 'adb shell pm grant ${context.packageName} android.permission.WRITE_SETTINGS'")
                    }
                    Settings.System.putString(context.contentResolver, key, value)
                }
                else -> return errorResult("Invalid table type: $type")
            }

            if (success) successResult("Setting applied ($type): $key = $value")
            else errorResult("System setting rejected ($type): $key")
        } catch (e: SecurityException) {
            errorResult("Permission error ($type): ${e.message}")
        } catch (e: Exception) {
            errorResult("Write error ($type): ${e.message}")
        }
    }

    fun getIntSetting(key: String, type: String): MdmResult {
        return try {
            val value = when (type.lowercase()) {
                "global" -> Settings.Global.getInt(context.contentResolver, key, -1)
                "secure" -> Settings.Secure.getInt(context.contentResolver, key, -1)
                "system" -> Settings.System.getInt(context.contentResolver, key, -1)
                else -> return errorResult("Invalid table type: $type")
            }

            if (value == -1) missingResult("Setting not found ($type): $key")
            else successResult("Setting read", mapOf("value" to value))
        } catch (e: Exception) {
            errorResult("Read error ($type): ${e.message}")
        }
    }

    fun getStringSetting(key: String, type: String): MdmResult {
        return try {
            val value = when (type.lowercase()) {
                "global" -> Settings.Global.getString(context.contentResolver, key)
                "secure" -> Settings.Secure.getString(context.contentResolver, key)
                "system" -> Settings.System.getString(context.contentResolver, key)
                else -> return errorResult("Invalid table type: $type")
            }

            if (value == null) missingResult("Setting not found ($type): $key")
            else successResult("Setting read", mapOf("value" to value))
        } catch (e: Exception) {
            errorResult("Read error ($type): ${e.message}")
        }
    }

    fun setIntSetting(key: String, value: Int, type: String): MdmResult {
        return writeSetting(key, value.toString(), type)
    }

    fun setStringSetting(key: String, value: String, type: String): MdmResult {
        return writeSetting(key, value, type)
    }

    fun getStorageInfo(): MdmResult {
        return try {
            val path = android.os.Environment.getDataDirectory()
            val statFs = android.os.StatFs(path.path)
            val totalBytes = statFs.blockSizeLong * statFs.blockCountLong
            val freeBytes = statFs.blockSizeLong * statFs.availableBlocksLong
            val usedBytes = totalBytes - freeBytes
            successResult("Storage info retrieved", mapOf(
                "totalBytes" to totalBytes,
                "freeBytes" to freeBytes,
                "usedBytes" to usedBytes
            ))
        } catch (e: Exception) {
            errorResult("Storage info unavailable: ${e.message}")
        }
    }

    fun setTimeZone(timeZone: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val success = dpm.setTimeZone(adminComponent, timeZone)
                if (success) successResult("Timezone set: $timeZone")
                else errorResult("DPM rejected")
            } else errorResult("Lollipop+ required")
        } catch (e: Exception) {
            errorResult("Timezone error: ${e.message}")
        }
    }

    fun setAutoTimeRequired(required: Boolean): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                dpm.setAutoTimeRequired(adminComponent, required)
                successResult("Auto time required: $required")
            } else errorResult("Lollipop+ required")
        } catch (e: Exception) {
            errorResult("Auto time error: ${e.message}")
        }
    }

    /** Requires Device Owner privileges and Android 11 or later. */
    fun setLocationEnabled(enabled: Boolean): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                dpm.setLocationEnabled(adminComponent, enabled)
                successResult("Location enabled: $enabled")
            } else errorResult("Android 11 (R) or later required")
        } catch (e: Exception) {
            errorResult("Location toggle error: ${e.message}")
        }
    }

    fun reboot(): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                dpm.reboot(adminComponent)
                successResult("Rebooting...")
            } else {
                errorResult("Android 7.0 (Nougat) or later required")
            }
        } catch (e: Exception) {
            errorResult("Reboot error: ${e.message}")
        }
    }

    fun getAdvancedSecurityInfo(): Map<String, Any?> {
        val resolver = context.contentResolver
        val result = mutableMapOf<String, Any?>()
        try {
            val adbRawGlobal = Settings.Global.getInt(resolver, Settings.Global.ADB_ENABLED, -999)
            val devRawGlobal = Settings.Global.getInt(resolver, "development_settings_enabled", -999)
            val adbRaw = if (adbRawGlobal != -999) adbRawGlobal else try {
                Settings.Secure.getInt(resolver, "adb_enabled", -999)
            } catch (_: Exception) { -999 }
            val devRaw = if (devRawGlobal != -999) devRawGlobal else try {
                @Suppress("DEPRECATION")
                Settings.Secure.getInt(resolver, Settings.Secure.DEVELOPMENT_SETTINGS_ENABLED, -999)
            } catch (_: Exception) { -999 }

            result["adbEnabled"] = adbRaw == 1
            result["developerOptionsEnabled"] = devRaw == 1
            val userManager = context.getSystemService(Context.USER_SERVICE) as android.os.UserManager
            val unknownSourcesBlocked = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                 userManager.hasUserRestriction(android.os.UserManager.DISALLOW_INSTALL_UNKNOWN_SOURCES)
            } else {
                 Settings.Secure.getInt(resolver, Settings.Secure.INSTALL_NON_MARKET_APPS, 0) == 0
            }
            result["unknownSourcesAllowed"] = !unknownSourcesBlocked
            result["encryptionStatus"] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
                when (dpm.storageEncryptionStatus) {
                    DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE,
                    DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_PER_USER -> "encrypted"
                    DevicePolicyManager.ENCRYPTION_STATUS_INACTIVE -> "unencrypted"
                    DevicePolicyManager.ENCRYPTION_STATUS_ACTIVATING -> "activating"
                    else -> "unknown"
                }
            } else "unknown"
            result["playProtectStatus"] = Settings.Global.getInt(resolver, "package_verifier_enable", 1) == 1
            val accessibilityManager = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
            val enabledServices = accessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
            result["enabledAccessibilityApps"] = enabledServices.map { it.resolveInfo.serviceInfo.packageName }
        } catch (e: Exception) {
            WLog.e(logTag, "getAdvancedSecurityInfo failed", e)
        }
        return result
    }
}
