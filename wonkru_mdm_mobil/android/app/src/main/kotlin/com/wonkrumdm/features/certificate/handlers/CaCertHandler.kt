package com.wonkrumdm.features.certificate.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import com.wonkrumdm.features.certificate.utils.CertUtils
import javax.security.auth.x500.X500Principal

class CaCertHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "CaCertHandler"

    fun installCaCertificate(certData: ByteArray): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val success = dpm.installCaCert(adminComponent, certData)
            if (success) {
                successResult("CA certificate installed successfully.")
            } else {
                errorResult("CA certificate not installed (format error or already installed).")
            }
        } catch (e: Exception) {
            errorResult("Install error: ${e.message}")
        }
    }

    fun getInstalledCaCertificates(): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val certBytesList = dpm.getInstalledCaCerts(adminComponent)
            val resultList = ArrayList<Any?>()

            certBytesList.forEachIndexed { index, bytes ->
                val x509 = CertUtils.parseX509(bytes)
                if (x509 != null) {
                    val alias = x509.subjectX500Principal
                        .getName(X500Principal.RFC2253)
                        .split(",")
                        .firstOrNull { it.trimStart().startsWith("CN=") }
                        ?.substringAfter("CN=")
                        ?.trim()
                        ?: "ca_$index"
                    resultList.add(CertUtils.toNativeInfo(x509, alias, true))
                }
            }

            successResult("Found ${resultList.size} installed CA(s).", resultList)
        } catch (e: Exception) {
            errorResult("List error: ${e.message}")
        }
    }
}