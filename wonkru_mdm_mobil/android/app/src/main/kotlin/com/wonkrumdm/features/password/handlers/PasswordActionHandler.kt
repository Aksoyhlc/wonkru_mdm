package com.wonkrumdm.features.password.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.core.lockDevice
import com.wonkrumdm.logging.WLog

class PasswordActionHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "PasswordActionHandler"

    fun lockNow(): MdmResult = lockDevice(dpm, context, adminComponent)

    fun isActivePasswordSufficient(): MdmResult {
        return try {
            val isSufficient = dpm.isActivePasswordSufficient
            successResult("Password status checked.", isSufficient)
        } catch (e: Exception) {
            errorResult("Check error: ${e.message}")
        }
    }

    fun openSetPasswordScreen() {
        try {
            val intent = Intent(DevicePolicyManager.ACTION_SET_NEW_PASSWORD)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        } catch (e: Exception) {
            try {
                val intent = Intent(Settings.ACTION_SECURITY_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            } catch (e: Exception) {
                WLog.w(logTag, "fallback password intent failed", e)
            }
        }
    }
}