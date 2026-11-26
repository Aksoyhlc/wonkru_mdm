package com.wonkrumdm.features.settings

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import com.wonkrumdm.api.settings.SystemSettingsAPI
import com.wonkrumdm.core.PermissionHelper
import com.wonkrumdm.features.settings.handlers.RootDetectorHelper
import com.wonkrumdm.features.settings.handlers.SystemSettingsHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SystemSettingsImpl(
    private val context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName,
) : SystemSettingsAPI {

    private val handler = SystemSettingsHandler(context, dpm, adminComponent)
    private val rootDetector = RootDetectorHelper(context)

    override fun getIntSetting(key: String, type: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.getIntSetting(key, type)
            callback(Result.success(result.toMap()))
        }
    }

    override fun getStringSetting(key: String, type: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.getStringSetting(key, type)
            callback(Result.success(result.toMap()))
        }
    }

    override fun setIntSetting(key: String, value: Long, type: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.setIntSetting(key, value.toInt(), type)
            callback(Result.success(result.toMap()))
        }
    }

    override fun setStringSetting(key: String, value: String, type: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.setStringSetting(key, value, type)
            callback(Result.success(result.toMap()))
        }
    }

    override fun canWriteSettings(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val canWrite = handler.canWriteSettings()
            callback(Result.success(canWrite))
        }
    }

    override fun setTimeZone(timeZone: String, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.setTimeZone(timeZone)
            callback(Result.success(result.toMap()))
        }
    }

    override fun setAutoTimeRequired(required: Boolean, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.setAutoTimeRequired(required)
            callback(Result.success(result.toMap()))
        }
    }

    override fun setLocationEnabled(enabled: Boolean, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.setLocationEnabled(enabled)
            callback(Result.success(result.toMap()))
        }
    }

    override fun reboot(callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.reboot()
            if (result.success) {
                callback(Result.success(Unit))
            } else {
                callback(Result.failure(Exception(result.message ?: "Reboot failed")))
            }
        }
    }

    override fun getStorageInfo(callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.getStorageInfo()
            callback(Result.success(result.toMap()))
        }
    }

    override fun isRooted(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val isRooted = rootDetector.isRooted()
            callback(Result.success(isRooted))
        }
    }

    override fun getRootInfo(callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val rootInfo = rootDetector.getRootInfo()
            callback(Result.success(rootInfo))
        }
    }

    override fun hasManageExternalStoragePermission(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val hasPermission = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                android.os.Environment.isExternalStorageManager()
            } else {
                true
            }
            callback(Result.success(hasPermission))
        }
    }

    override fun isBatteryOptimizationIgnored(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            callback(Result.success(PermissionHelper.isBatteryOptimizationIgnored(context)))
        }
    }

    override fun openPowerSaveSettings(callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            PermissionHelper.openPowerSaveSettings(context)
            callback(Result.success(mapOf("success" to true)))
        }
    }

    override fun getAdvancedSecurityInfo(callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val result = handler.getAdvancedSecurityInfo()
            callback(Result.success(result))
        }
    }

    override fun launchIntent(params: Map<String?, String?>, callback: (Result<Map<String, Any?>>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                fun str(key: String): String? = params[key]?.takeIf { it.isNotBlank() }
                val action = str("intent_action")
                val pkg = str("intent_package")
                val component = str("intent_component")
                if (action.isNullOrBlank() && pkg.isNullOrBlank() && component.isNullOrBlank()) {
                    callback(Result.success(mapOf("success" to false, "error" to "At least one of intent_action, intent_package or intent_component required")))
                    return@launch
                }
                val intent = Intent()
                action?.let { intent.action = it }
                pkg?.let { intent.`package` = it }
                component?.let {
                    ComponentName.unflattenFromString(it)?.let { c -> intent.component = c }
                }
                str("intent_data")?.let { intent.data = Uri.parse(it) }
                str("intent_type")?.let { intent.type = it }
                str("intent_categories")?.split(',')?.map { it.trim() }?.filter { it.isNotEmpty() }?.forEach { intent.addCategory(it) }
                str("intent_flags")?.split(',')?.mapNotNull { it.trim().toIntOrNull() }?.forEach { intent.addFlags(it) }
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
                callback(Result.success(mapOf("success" to true)))
            } catch (e: Exception) {
                callback(Result.success(mapOf("success" to false, "error" to (e.message ?: e.toString()))))
            }
        }
    }
}
