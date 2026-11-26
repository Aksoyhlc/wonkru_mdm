package com.wonkrumdm.features.password.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.util.Log
import com.wonkrumdm.api.password.NativePasswordConfig
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.features.password.utils.PasswordUtils

@Suppress("DEPRECATION")
class PasswordConfigHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "PasswordConfigHandler"

    fun setPasswordPolicy(config: NativePasswordConfig): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val complexity = config.complexityLevel?.toInt() ?: 0

            if (complexity > 0 && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                clearLegacyRules()

                val bucket = when (complexity) {
                    1 -> DevicePolicyManager.PASSWORD_COMPLEXITY_LOW
                    2 -> DevicePolicyManager.PASSWORD_COMPLEXITY_MEDIUM
                    3 -> DevicePolicyManager.PASSWORD_COMPLEXITY_HIGH
                    else -> DevicePolicyManager.PASSWORD_COMPLEXITY_NONE
                }
                dpm.requiredPasswordComplexity = bucket

                successResult("Modern password policy applied (Level: $complexity).")
            } else {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    dpm.requiredPasswordComplexity = DevicePolicyManager.PASSWORD_COMPLEXITY_NONE
                }

                applyLegacyRules(config)

                successResult("Custom password policy applied.")
            }
        } catch (e: Exception) {
            errorResult("Policy application error: ${e.message}")
        }
    }

    fun clearPasswordPolicy(): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                dpm.requiredPasswordComplexity = DevicePolicyManager.PASSWORD_COMPLEXITY_NONE
            }
            clearLegacyRules()

            successResult("All password policies cleared.")
        } catch (e: Exception) {
            errorResult("Clear error: ${e.message}")
        }
    }

    fun getPasswordPolicy(): MdmResult {
        return try {
            val complexity = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                when (dpm.requiredPasswordComplexity) {
                    DevicePolicyManager.PASSWORD_COMPLEXITY_LOW -> 1L
                    DevicePolicyManager.PASSWORD_COMPLEXITY_MEDIUM -> 2L
                    DevicePolicyManager.PASSWORD_COMPLEXITY_HIGH -> 3L
                    else -> 0L
                }
            } else 0L

            val config = NativePasswordConfig(
                complexityLevel = complexity,
                quality = dpm.getPasswordQuality(adminComponent).toLong(),
                minLength = dpm.getPasswordMinimumLength(adminComponent).toLong(),
                minUpperCase = dpm.getPasswordMinimumUpperCase(adminComponent).toLong(),
                minLowerCase = dpm.getPasswordMinimumLowerCase(adminComponent).toLong(),
                minLetters = dpm.getPasswordMinimumLetters(adminComponent).toLong(),
                minNumeric = dpm.getPasswordMinimumNumeric(adminComponent).toLong(),
                minSymbols = dpm.getPasswordMinimumSymbols(adminComponent).toLong(),
                minNonLetter = dpm.getPasswordMinimumNonLetter(adminComponent).toLong(),
                historyLength = dpm.getPasswordHistoryLength(adminComponent).toLong(),
                expirationTimeoutMs = dpm.getPasswordExpirationTimeout(adminComponent),
                maxFailedAttempts = dpm.getMaximumFailedPasswordsForWipe(adminComponent).toLong()
            )

            successResult("Current policy retrieved.", PasswordUtils.toMap(config))
        } catch (e: Exception) {
            errorResult("Read error: ${e.message}")
        }
    }

    private fun clearLegacyRules() {
        dpm.setMaximumFailedPasswordsForWipe(adminComponent, 0)

        dpm.setPasswordQuality(adminComponent, DevicePolicyManager.PASSWORD_QUALITY_COMPLEX)

        dpm.setPasswordMinimumLength(adminComponent, 0)
        dpm.setPasswordMinimumUpperCase(adminComponent, 0)
        dpm.setPasswordMinimumLowerCase(adminComponent, 0)
        dpm.setPasswordMinimumLetters(adminComponent, 0)
        dpm.setPasswordMinimumNumeric(adminComponent, 0)
        dpm.setPasswordMinimumSymbols(adminComponent, 0)
        dpm.setPasswordMinimumNonLetter(adminComponent, 0)
        dpm.setPasswordHistoryLength(adminComponent, 0)
        dpm.setPasswordExpirationTimeout(adminComponent, 0L)

        dpm.setPasswordQuality(adminComponent, DevicePolicyManager.PASSWORD_QUALITY_UNSPECIFIED)
    }

    private fun applyLegacyRules(config: NativePasswordConfig) {
        val quality = config.quality?.toInt() ?: DevicePolicyManager.PASSWORD_QUALITY_UNSPECIFIED
        dpm.setPasswordQuality(adminComponent, quality)

        if (quality != DevicePolicyManager.PASSWORD_QUALITY_UNSPECIFIED) {
            safeSet { dpm.setPasswordMinimumLength(adminComponent, config.minLength?.toInt() ?: 0) }

            safeSet { dpm.setPasswordMinimumUpperCase(adminComponent, config.minUpperCase?.toInt() ?: 0) }
            safeSet { dpm.setPasswordMinimumLowerCase(adminComponent, config.minLowerCase?.toInt() ?: 0) }
            safeSet { dpm.setPasswordMinimumLetters(adminComponent, config.minLetters?.toInt() ?: 0) }
            safeSet { dpm.setPasswordMinimumNumeric(adminComponent, config.minNumeric?.toInt() ?: 0) }
            safeSet { dpm.setPasswordMinimumSymbols(adminComponent, config.minSymbols?.toInt() ?: 0) }
            safeSet { dpm.setPasswordMinimumNonLetter(adminComponent, config.minNonLetter?.toInt() ?: 0) }
        }

        safeSet { dpm.setPasswordHistoryLength(adminComponent, config.historyLength?.toInt() ?: 0) }
        safeSet { dpm.setPasswordExpirationTimeout(adminComponent, config.expirationTimeoutMs ?: 0L) }
    }

    private fun safeSet(action: () -> Unit) {
        try {
            action()
        } catch (e: Exception) {
            Log.w(logTag, "Rule could not be applied (quality level may be insufficient): ${e.message}")
        }
    }
}