package com.wonkrumdm.features.settings.handlers

import android.content.Context
import android.os.Build
import com.scottyab.rootbeer.RootBeer
import com.wonkrumdm.logging.WLog
import java.io.File

class RootDetectorHelper(private val context: Context) {

    private val rootBeer: RootBeer by lazy { RootBeer(context) }

    fun isRooted(): Boolean {
        return rootBeer.isRooted
    }

    fun getRootInfo(): Map<String, Any?> {
        return mapOf(
            "isRooted" to rootBeer.isRooted,
            "isRootedWithoutBusyBoxCheck" to rootBeer.isRootedWithoutBusyBoxCheck,
            "detectRootManagementApps" to rootBeer.detectRootManagementApps(),
            "detectPotentiallyDangerousApps" to rootBeer.detectPotentiallyDangerousApps(),
            "detectTestKeys" to rootBeer.detectTestKeys(),
            "checkForBusyBoxBinary" to rootBeer.checkForBusyBoxBinary(),
            "checkForSuBinary" to rootBeer.checkForSuBinary(),
            "checkSuExists" to rootBeer.checkSuExists(),
            "checkForRWPaths" to rootBeer.checkForRWPaths(),
            "checkForDangerousProps" to rootBeer.checkForDangerousProps(),
            "checkForRootNative" to rootBeer.checkForRootNative(),
            "detectRootCloakingApps" to rootBeer.detectRootCloakingApps(),
            "isSelinuxFlagInEnabled" to isSelinuxEnforcing(),
            "checkForMagiskBinary" to rootBeer.checkForMagiskBinary(),
            "deviceInfo" to getDeviceInfo()
        )
    }

    private fun isSelinuxEnforcing(): Boolean {
        return try {
            File("/sys/fs/selinux/enforce").readText().trim() == "1"
        } catch (e: Exception) {
            WLog.w("RootDetectorHelper", "SELinux state unreadable; treating as non-enforcing", e)
            false
        }
    }

    private fun getDeviceInfo(): Map<String, String> {
        return mapOf(
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "device" to Build.DEVICE,
            "fingerprint" to Build.FINGERPRINT,
            "androidVersion" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT.toString()
        )
    }
}