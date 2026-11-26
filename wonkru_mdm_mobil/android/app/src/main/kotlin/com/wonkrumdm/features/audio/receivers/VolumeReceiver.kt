package com.wonkrumdm.features.audio.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.util.Log
import com.wonkrumdm.api.audio.AudioEventAPI
import com.wonkrumdm.api.audio.NativeVolumeEvent
import com.wonkrumdm.core.receivers.MultiEngineEventRegistry
import io.flutter.plugin.common.BinaryMessenger

class VolumeReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "VolumeReceiver"
        private const val VOLUME_CHANGED_ACTION = "android.media.VOLUME_CHANGED_ACTION"

        private val registry = MultiEngineEventRegistry("AudioEventAPI") { AudioEventAPI(it) }

        fun initialize(messenger: BinaryMessenger) {
            registry.register(messenger)
        }

        fun dispose(messenger: BinaryMessenger? = null) {
            registry.dispose(messenger)
        }

        fun getIntentFilter(): IntentFilter {
            return IntentFilter(VOLUME_CHANGED_ACTION)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != VOLUME_CHANGED_ACTION) return

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val streamType = intent.getIntExtra("android.media.EXTRA_VOLUME_STREAM_TYPE", -1)
        if (streamType == -1) return
        if (streamType != AudioManager.STREAM_MUSIC) return

        val currentVol = audioManager.getStreamVolume(streamType)
        val maxVol = audioManager.getStreamMaxVolume(streamType)
        val percent = if (maxVol > 0) {
            ((currentVol.toDouble() / maxVol.toDouble()) * 100).toInt()
        } else 0
        val ringerMode = audioManager.ringerMode

        val event = NativeVolumeEvent(
            streamType = streamType.toLong(),
            volumePercent = percent.toLong(),
            ringerMode = ringerMode.toLong()
        )

        val apis = registry.all()
        if (apis.isEmpty()) {
            Log.w(TAG, "No API available, volume event dropped (stream=$streamType)")
            return
        }
        for (api in apis) {
            api.onVolumeChanged(event) { result ->
                result.exceptionOrNull()?.let { e ->
                    Log.w(TAG, "onVolumeChanged callback failed (engine may be destroyed)", e)
                }
            }
        }
    }
}