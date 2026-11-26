package com.wonkrumdm.features.certificate

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import com.wonkrumdm.api.certificate.CertificateAPI
import com.wonkrumdm.features.certificate.handlers.CaCertHandler
import com.wonkrumdm.features.certificate.handlers.ClientCertHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class CertificateImpl(
    context: Context,
    dpm: DevicePolicyManager,
    adminComponent: ComponentName
) : CertificateAPI {

    private val caHandler = CaCertHandler(context, dpm, adminComponent)
    private val clientHandler = ClientCertHandler(context, dpm, adminComponent)

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    fun dispose() {
        scope.cancel()
    }

    override fun installCaCertificate(
        certData: ByteArray,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = caHandler.installCaCertificate(certData)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getInstalledCaCertificates(callback: (Result<Map<String, Any?>>) -> Unit) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = caHandler.getInstalledCaCertificates()
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun installUserKeyPair(
        p12Data: ByteArray,
        password: String,
        alias: String,
        isWifi: Boolean,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = clientHandler.installUserKeyPair(p12Data, password, alias, isWifi)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun removeKeyPair(
        alias: String,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        scope.launch(Dispatchers.IO) {
            try {
                val result = clientHandler.removeKeyPair(alias)
                callback(Result.success(result.toMap()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}
