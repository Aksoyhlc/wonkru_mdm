package com.wonkrumdm.core.provisioning

import android.app.admin.DevicePolicyManager
import android.content.Context
import android.content.Intent
import android.os.PersistableBundle
import android.util.Log
import com.wonkrumdm.core.utils.FlutterStorageHelper

object ProvisioningExtras {

    private const val TAG = "MDM"

    fun persistFrom(context: Context, intent: Intent?) {
        val bundle = intent?.getParcelableExtra<PersistableBundle>(
            DevicePolicyManager.EXTRA_PROVISIONING_ADMIN_EXTRAS_BUNDLE
        )

        if (bundle == null || bundle.isEmpty) {
            Log.i(TAG, "No provisioning extras to persist.")
            return
        }

        val storage = FlutterStorageHelper.getInstance(context)
        var written = 0

        for (key in bundle.keySet()) {
            if (key.isNullOrEmpty()) continue

            when (val value = bundle.get(key)) {
                is String -> if (value.isNotEmpty()) {
                    storage.setString(key, value); written++
                }
                is Int -> { storage.setInt(key, value); written++ }
                is Long -> { storage.setLong(key, value); written++ }
                is Boolean -> { storage.setBoolean(key, value); written++ }
                is Double -> { storage.setString(key, value.toString()); written++ }
            }
        }

        Log.i(TAG, "Persisted $written provisioning extra(s).")
    }
}
