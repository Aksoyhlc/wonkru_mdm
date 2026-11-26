package com.wonkrumdm.features.restriction.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.util.Log
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult

import android.os.UserManager
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver
import com.wonkrumdm.core.utils.FlutterStorageHelper

class RestrictionHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    companion object {
        const val TAG = "RestrictionHandler"

        fun checkAndRestoreInstallRestriction(context: Context) {
            try {
                val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                if (!dpm.isDeviceOwnerApp(context.packageName)) {
                    Log.w(TAG, "Device Owner permission missing, restriction check skipped.")
                    return
                }
                val storage = FlutterStorageHelper.getInstance(context)
                val wasLifted = storage.getBooleanValue(Constants.KEY_RESTRICTION_LIFTED, false)
                if (wasLifted) {
                    Log.w(TAG, "Security Warning: App install restriction was left open! Restoring...")
                    val adminComponent = ComponentName(context, MdmDeviceAdminReceiver::class.java)
                    dpm.addUserRestriction(adminComponent, UserManager.DISALLOW_INSTALL_APPS)
                    storage.setBoolean(Constants.KEY_RESTRICTION_LIFTED, false)
                    Log.i(TAG, "Restriction successfully restored.")
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error during restriction check: ${e.message}")
            }
        }

        fun liftInstallRestrictionSafely(context: Context, dpm: DevicePolicyManager, admin: ComponentName): Boolean {
            try {
                if (!dpm.isDeviceOwnerApp(context.packageName)) {
                    Log.e(TAG, "Safe Install failed: Device Owner permission missing.")
                    return false
                }
                val wasRestricted = dpm.getUserRestrictions(admin).getBoolean(UserManager.DISALLOW_INSTALL_APPS)
                if (wasRestricted) {
                    FlutterStorageHelper.getInstance(context).setBoolean(Constants.KEY_RESTRICTION_LIFTED, true)
                    dpm.clearUserRestriction(admin, UserManager.DISALLOW_INSTALL_APPS)
                    Log.i(TAG, "Restriction temporarily lifted for safe install.")
                    return true
                }
            } catch (e: Exception) {
                Log.e(TAG, "Restriction lift error: ${e.message}")
            }
            return false
        }
    }

    override val logTag = "RestrictionHandler"

    fun setRestriction(key: String, enabled: Boolean): MdmResult {
        if (!isDeviceOwner()) return permissionError()
        if (isCustomRestrictionKey(key)) {
            return successResult(if (enabled) "Restriction added: $key" else "Restriction removed: $key")
        }

        return try {
            if (enabled) {
                dpm.addUserRestriction(adminComponent, key)
                successResult("Restriction added: $key")
            } else {
                dpm.clearUserRestriction(adminComponent, key)
                successResult("Restriction removed: $key")
            }
        } catch (e: SecurityException) {
            errorResult("Security Error: ${e.message}")
        } catch (e: Exception) {
            errorResult("Unexpected Error: ${e.message}")
        }
    }

    fun setBulkRestrictions(restrictions: Map<String?, Boolean?>): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            var successCount = 0
            restrictions.forEach { (key, enabled) ->
                if (key != null && enabled != null && !isCustomRestrictionKey(key)) {
                    try {
                        if (enabled) dpm.addUserRestriction(adminComponent, key)
                        else dpm.clearUserRestriction(adminComponent, key)
                        successCount++
                    } catch (e: Exception) {
                        Log.e(logTag, "Error ($key): ${e.message}")
                    }
                }
            }
            successResult("$successCount restrictions updated.")
        } catch (e: Exception) {
            errorResult("Bulk operation error: ${e.message}")
        }
    }

    private fun isCustomRestrictionKey(key: String): Boolean {
        return key == "restrictions_pending"
    }

    fun isRestrictionActive(key: String): MdmResult {
        if (isCustomRestrictionKey(key)) {
            return successResult("Status retrieved", false)
        }
        return try {
            val bundle = dpm.getUserRestrictions(adminComponent)
            val isActive = bundle.getBoolean(key, false)
            successResult("Status retrieved", isActive)
        } catch (e: Exception) {
            errorResult("Query error: ${e.message}")
        }
    }

}