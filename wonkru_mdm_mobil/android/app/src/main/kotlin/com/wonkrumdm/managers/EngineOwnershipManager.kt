package com.wonkrumdm.managers

import android.content.Context
import android.util.Log
import com.wonkrumdm.core.Constants
import com.wonkrumdm.core.utils.FlutterStorageHelper

class EngineOwnershipManager(private val context: Context) {

    private val storage = FlutterStorageHelper.getInstance(context)

    companion object {
        private const val TAG = "EngineOwnership"
        const val OWNER_UI = "UI"
        const val OWNER_HEADLESS = "HEADLESS"
    }

    fun getOwner(): String {
        return storage.getStringValue(Constants.KEY_ENGINE_OWNER, "") ?: ""
    }

    fun setOwner(value: String) {
        storage.setString(Constants.KEY_ENGINE_OWNER, value)
        Log.d(TAG, "Owner: $value")
    }

    fun clearOwner() {
        storage.setString(Constants.KEY_ENGINE_OWNER, "")
        Log.d(TAG, "Owner cleared")
    }

    fun isLauncherModeEnabled(): Boolean {
        return storage.getBooleanValue(Constants.KEY_LAUNCHER_MODE_ENABLED, false)
    }
}