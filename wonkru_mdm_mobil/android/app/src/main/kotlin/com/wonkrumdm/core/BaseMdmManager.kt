package com.wonkrumdm.core

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.util.Log

abstract class BaseMdmManager(
    protected val context: Context,
    protected val dpm: DevicePolicyManager,
    protected val adminComponent: ComponentName
) {
    abstract val logTag: String

    protected fun isDeviceOwner(): Boolean {
        return dpm.isDeviceOwnerApp(context.packageName)
    }

    protected fun successResult(msg: String, data: Any? = null): MdmResult {
        Log.i(logTag, "Success: $msg")
        return MdmResult(true, msg, data)
    }

    protected fun errorResult(msg: String): MdmResult {
        Log.e(logTag, "Error: $msg")
        return MdmResult(false, msg, null)
    }

    /** Report an expected missing value as a failure without an error-level log. */
    protected fun missingResult(msg: String): MdmResult {
        Log.d(logTag, "Missing: $msg")
        return MdmResult(false, msg, null)
    }

    protected fun permissionError(): MdmResult {
        return errorResult("Operation failed: Device Owner permission required.")
    }
}