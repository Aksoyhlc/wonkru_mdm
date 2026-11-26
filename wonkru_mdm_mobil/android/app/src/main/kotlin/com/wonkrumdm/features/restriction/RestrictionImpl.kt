package com.wonkrumdm.features.restriction

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.restriction.RestrictionAPI
import com.wonkrumdm.features.restriction.handlers.RestrictionHandler

class RestrictionImpl(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : RestrictionAPI {

    private val restrictionHandler = RestrictionHandler(context, dpm, adminComponent)

    override fun setRestriction(key: String, enabled: Boolean): Map<String, Any?> {
        return restrictionHandler.setRestriction(key, enabled).toMap()
    }

    override fun setBulkRestrictions(restrictions: Map<String?, Boolean?>): Map<String, Any?> {
        return restrictionHandler.setBulkRestrictions(restrictions).toMap()
    }

    override fun isRestrictionActive(key: String): Map<String, Any?> {
        return restrictionHandler.isRestrictionActive(key).toMap()
    }

}