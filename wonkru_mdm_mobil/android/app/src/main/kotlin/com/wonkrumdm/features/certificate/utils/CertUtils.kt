package com.wonkrumdm.features.certificate.utils

import com.wonkrumdm.api.certificate.NativeCertificateInfo
import java.io.ByteArrayInputStream
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate

object CertUtils {

    fun parseX509(certBytes: ByteArray): X509Certificate? {
        return try {
            val factory = CertificateFactory.getInstance("X.509")
            factory.generateCertificate(ByteArrayInputStream(certBytes)) as? X509Certificate
        } catch (e: Exception) {
            null
        }
    }

    fun toNativeInfo(cert: X509Certificate, alias: String?, isCa: Boolean): NativeCertificateInfo {
        return NativeCertificateInfo(
            alias = alias,
            subject = cert.subjectDN.name,
            issuer = cert.issuerDN.name,
            validFrom = cert.notBefore.time,
            validTo = cert.notAfter.time,
            isCa = isCa
        )
    }
}
