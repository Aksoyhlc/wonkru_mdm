package com.wonkrumdm.features.keyguard

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.keyguard.KeyguardAPI
import com.wonkrumdm.api.keyguard.KeyguardFeatures
import com.wonkrumdm.features.keyguard.handlers.KeyguardHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class KeyguardImpl(
    private val context: Context,
    private val dpm: DevicePolicyManager,
    admin: ComponentName
) : KeyguardAPI {

    private val handler = KeyguardHandler(context, dpm, admin)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun setKeyguardDisabledFeatures(
        features: KeyguardFeatures,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = handler.setKeyguardDisabledFeatures(features)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getKeyguardDisabledFeatures(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = handler.getKeyguardDisabledFeatures()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getMaximumTimeToLock(callback: (Result<Long>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val timeout = handler.getMaximumTimeToLock()
                callback(Result.success(timeout))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun isDeviceOwner(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(dpm.isDeviceOwnerApp(context.packageName)))
    }

    override fun isKeyguardLocked(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(handler.isKeyguardLocked()))
    }

    override fun isKeyguardSecure(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(handler.isKeyguardSecure()))
    }
}
