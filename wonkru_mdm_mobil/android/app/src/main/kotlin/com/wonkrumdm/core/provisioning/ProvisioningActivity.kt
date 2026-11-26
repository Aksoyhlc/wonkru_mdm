package com.wonkrumdm.core.provisioning

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.Intent
import android.os.Bundle
import android.util.Log

class ProvisioningActivity : Activity() {

    private companion object {
        const val TAG = "MDM"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        when (intent?.action) {
            DevicePolicyManager.ACTION_GET_PROVISIONING_MODE -> handleGetProvisioningMode()
            DevicePolicyManager.ACTION_ADMIN_POLICY_COMPLIANCE -> handleAdminPolicyCompliance()
            else -> {
                Log.w(TAG, "ProvisioningActivity started with unexpected action: ${intent?.action}")
                setResult(RESULT_CANCELED)
                finish()
            }
        }
    }

    private fun handleGetProvisioningMode() {
        Log.i(TAG, "Returning fully managed device provisioning mode.")
        val result = Intent().putExtra(
            DevicePolicyManager.EXTRA_PROVISIONING_MODE,
            DevicePolicyManager.PROVISIONING_MODE_FULLY_MANAGED_DEVICE
        )
        setResult(RESULT_OK, result)
        finish()
    }

    private fun handleAdminPolicyCompliance() {
        Log.i(TAG, "Admin policy compliance step. Persisting provisioning extras...")
        ProvisioningExtras.persistFrom(applicationContext, intent)
        setResult(RESULT_OK)
        finish()
    }
}
