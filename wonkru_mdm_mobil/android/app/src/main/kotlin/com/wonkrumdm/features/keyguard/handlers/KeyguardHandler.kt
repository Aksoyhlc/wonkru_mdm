package com.wonkrumdm.features.keyguard.handlers

import android.app.KeyguardManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import com.wonkrumdm.api.keyguard.KeyguardFeatures
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult

class KeyguardHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "KeyguardHandler"

    private val keyguardManager: KeyguardManager by lazy {
        context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
    }

    fun setKeyguardDisabledFeatures(features: KeyguardFeatures): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            var flags = DevicePolicyManager.KEYGUARD_DISABLE_FEATURES_NONE

            if (features.disableSecureCamera == true) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_SECURE_CAMERA
            }
            if (features.disableUnredactedNotifications == true) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_UNREDACTED_NOTIFICATIONS
            }
            if (features.disableFingerprint == true) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_FINGERPRINT
            }
            if (features.disableFace == true && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_FACE
            }
            if (features.disableIris == true && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_IRIS
            }
            if (features.disableBiometrics == true && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_BIOMETRICS
            }
            if (features.disableTrustAgents == true) {
                flags = flags or DevicePolicyManager.KEYGUARD_DISABLE_TRUST_AGENTS
            }
            if (features.disableAll == true) {
                flags = DevicePolicyManager.KEYGUARD_DISABLE_FEATURES_ALL
            }

            dpm.setKeyguardDisabledFeatures(adminComponent, flags)
            successResult("Keyguard features updated", mapOf("flags" to flags))
        } catch (e: Exception) {
            errorResult("Keyguard features update error: ${e.message}")
        }
    }

    fun getKeyguardDisabledFeatures(): MdmResult {
        return try {
            val flags = dpm.getKeyguardDisabledFeatures(adminComponent)

            val features = mutableMapOf<String, Boolean>()
            features["secure_camera"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_SECURE_CAMERA) != 0
            features["unredacted_notifications"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_UNREDACTED_NOTIFICATIONS) != 0
            features["fingerprint"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_FINGERPRINT) != 0
            features["trust_agents"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_TRUST_AGENTS) != 0

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                features["face"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_FACE) != 0
                features["iris"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_IRIS) != 0
                features["biometrics"] = (flags and DevicePolicyManager.KEYGUARD_DISABLE_BIOMETRICS) != 0
            }

            features["all"] = flags == DevicePolicyManager.KEYGUARD_DISABLE_FEATURES_ALL

            successResult("Keyguard features retrieved", mapOf("flags" to flags, "features" to features))
        } catch (e: Exception) {
            errorResult("Keyguard features read error: ${e.message}")
        }
    }

    fun getMaximumTimeToLock(): Long {
        return try {
            dpm.getMaximumTimeToLock(adminComponent)
        } catch (e: Exception) {
            0L
        }
    }

    fun isKeyguardLocked(): Boolean {
        return keyguardManager.isKeyguardLocked
    }

    fun isKeyguardSecure(): Boolean {
        return keyguardManager.isKeyguardSecure
    }
}