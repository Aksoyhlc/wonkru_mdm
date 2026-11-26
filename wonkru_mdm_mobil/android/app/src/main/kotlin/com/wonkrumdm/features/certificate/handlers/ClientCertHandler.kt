package com.wonkrumdm.features.certificate.handlers

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.util.Log
import com.wonkrumdm.core.BaseMdmManager
import com.wonkrumdm.core.MdmResult
import java.io.ByteArrayInputStream
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.Certificate
import java.util.Enumeration

class ClientCertHandler(
    context: Context,
    dpm: DevicePolicyManager,
    admin: ComponentName
) : BaseMdmManager(context, dpm, admin) {

    override val logTag = "ClientCertHandler"

    fun installUserKeyPair(
        p12Data: ByteArray,
        password: String,
        alias: String,
        isWifi: Boolean
    ): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val keyStore = KeyStore.getInstance("PKCS12")
            keyStore.load(ByteArrayInputStream(p12Data), password.toCharArray())

            var privateKey: PrivateKey? = null
            var chain: Array<Certificate>? = null

            val aliases: Enumeration<String> = keyStore.aliases()
            while (aliases.hasMoreElements()) {
                val tempAlias = aliases.nextElement()
                if (keyStore.isKeyEntry(tempAlias)) {
                    privateKey = keyStore.getKey(tempAlias, password.toCharArray()) as? PrivateKey
                    chain = keyStore.getCertificateChain(tempAlias)
                    break
                }
            }

            if (privateKey == null || chain == null) {
                return errorResult("No Private Key or Certificate Chain found in P12 file.")
            }

            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                DevicePolicyManager.INSTALLKEY_SET_USER_SELECTABLE
            } else {
                0
            }

            val success = dpm.installKeyPair(
                adminComponent,
                privateKey,
                chain,
                alias,
                flags
            )

            if (success) successResult("Client certificate installed. Alias: $alias")
            else errorResult("Certificate install failed (system rejected). alias=$alias")

        } catch (e: Exception) {
            Log.e(logTag, "P12 Parse Error", e)
            errorResult("Certificate processing error: ${e.message}")
        }
    }

    fun removeKeyPair(alias: String): MdmResult {
        if (!isDeviceOwner()) return permissionError()

        return try {
            val success = dpm.removeKeyPair(adminComponent, alias)
            if (success) successResult("Certificate removed: $alias")
            else errorResult("Certificate not removed (not found or no permission): $alias")
        } catch (e: Exception) {
            errorResult("Certificate removal error (alias=$alias): ${e.message}")
        }
    }
}