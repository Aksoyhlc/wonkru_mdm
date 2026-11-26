package com.wonkrumdm.core.receivers

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.wonkrumdm.MainActivity
import com.wonkrumdm.core.SelfPermissionManager
import com.wonkrumdm.core.provisioning.ProvisioningExtras

class MdmDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Log.i("MDM", "Admin permission enabled.")
        // Device Owner may be assigned after Application.onCreate; grant permissions here too.
        SelfPermissionManager.grantSelfRuntimePermissions(context)
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Log.i("MDM", "Admin permission disabled.")
    }

    override fun onProfileProvisioningComplete(context: Context, intent: Intent) {
        super.onProfileProvisioningComplete(context, intent)
        Log.i("MDM", "Provisioning complete. Launching application...")

        ProvisioningExtras.persistFrom(context, intent)
        SelfPermissionManager.grantSelfRuntimePermissions(context)

        val launchIntent = Intent(context, MainActivity::class.java)
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(launchIntent)
    }
}