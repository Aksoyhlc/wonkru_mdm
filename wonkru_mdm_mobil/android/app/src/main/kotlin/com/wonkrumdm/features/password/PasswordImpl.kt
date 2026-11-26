package com.wonkrumdm.features.password

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.password.NativePasswordConfig
import com.wonkrumdm.api.password.PasswordPolicyAPI
import com.wonkrumdm.features.password.handlers.PasswordActionHandler
import com.wonkrumdm.features.password.handlers.PasswordConfigHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class PasswordImpl(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : PasswordPolicyAPI {

    private val configHandler = PasswordConfigHandler(context, dpm, adminComponent)
    private val actionHandler = PasswordActionHandler(context, dpm, adminComponent)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun setPasswordPolicy(
        config: NativePasswordConfig,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = configHandler.setPasswordPolicy(config)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun clearPasswordPolicy(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = configHandler.clearPasswordPolicy()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getPasswordPolicy(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = configHandler.getPasswordPolicy()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun isActivePasswordSufficient(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = actionHandler.isActivePasswordSufficient()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun lockNow(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = actionHandler.lockNow()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun openSetPasswordScreen() {
        actionHandler.openSetPasswordScreen()
    }
}
