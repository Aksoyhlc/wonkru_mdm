package com.wonkrumdm.managers

import android.annotation.SuppressLint
import android.app.Application
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.content.ContextCompat
import com.wonkrumdm.api.app.AppEventApi
import com.wonkrumdm.features.app.receivers.AppChangeReceiver
import com.wonkrumdm.features.audio.receivers.VolumeReceiver
import com.wonkrumdm.features.wifi.receivers.WifiStateReceiver
import com.wonkrumdm.logging.WLog
import io.flutter.plugin.common.BinaryMessenger

class MdmBroadcastManager(
    private val context: Context,
    private val messenger: BinaryMessenger
) {
    private data class ReceiverEntry(
        val receiver: BroadcastReceiver,
        val filter: IntentFilter
    )

    private val receivers = mutableListOf<ReceiverEntry>()

    fun initialize() {
        val appApi = AppEventApi(messenger)

        addAppChangeReceiver(appApi)
        addVolumeReceiver()
        addWifiStateReceiver()
    }

    private fun addWifiStateReceiver() {
        val receiver = WifiStateReceiver()
        receivers.add(ReceiverEntry(receiver, WifiStateReceiver.getIntentFilter()))
    }

    private fun addVolumeReceiver() {
        val receiver = VolumeReceiver()
        receivers.add(ReceiverEntry(receiver, VolumeReceiver.getIntentFilter()))
    }

    private fun addAppChangeReceiver(api: AppEventApi) {
        val receiver = AppChangeReceiver(api)
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_PACKAGE_ADDED)
            addAction(Intent.ACTION_PACKAGE_REMOVED)
            addAction(Intent.ACTION_PACKAGE_REPLACED)
            addAction(Intent.ACTION_PACKAGE_FULLY_REMOVED)
            addDataScheme("package")
        }
        receivers.add(ReceiverEntry(receiver, filter))
    }

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    fun registerAll() {
        val ctx = if (context is Application) context else context.applicationContext
        for (entry in receivers) {
            ContextCompat.registerReceiver(
                ctx,
                entry.receiver,
                entry.filter,
                ContextCompat.RECEIVER_NOT_EXPORTED
            )
        }
    }

    fun unregisterAll() {
        val ctx = if (context is Application) context else context.applicationContext
        for (entry in receivers) {
            try {
                ctx.unregisterReceiver(entry.receiver)
            } catch (e: Exception) {
                WLog.w(TAG, "unregisterReceiver failed (already unregistered?)", e)
            }
        }
    }

    companion object {
        private const val TAG = "MdmBroadcastManager"
    }
}
