package com.wonkrumdm.core.provisioning

import android.content.Context
import android.content.Intent
import android.util.Log
import com.wonkrumdm.core.utils.FlutterStorageHelper

/**
 * Persists setup values passed as plain intent string extras, so an operator can
 * enroll a device over ADB without typing the key:
 *
 *   adb shell am start -n com.wonkrumdm/.MainActivity \
 *     --es server_url "https://api.example.com" \
 *     --es enrollment_key "WNKR-XXXX-XXXX-XXXX"
 *
 * The keys match the provisioning QR extras, so the Dart side reads them the
 * same way (`EnrollmentKeyStore`, `const.serverUrl`, `Sk.device_code`).
 */
object SetupExtras {

    private const val TAG = "MDM"

    private val keys = listOf("server_url", "enrollment_key", "device_code")

    fun persistFrom(context: Context, intent: Intent?) {
        if (intent == null) return

        val storage = FlutterStorageHelper.getInstance(context)
        var written = 0

        for (key in keys) {
            val value = intent.getStringExtra(key)?.trim()
            if (value.isNullOrEmpty()) continue
            if (storage.setString(key, value)) written++
        }

        if (written > 0) {
            Log.i(TAG, "Persisted $written setup extra(s).")
        }
    }
}
