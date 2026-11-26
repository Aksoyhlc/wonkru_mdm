package com.wonkrumdm.features.password.utils

import com.wonkrumdm.api.password.NativePasswordConfig

object PasswordUtils {
    fun toMap(config: NativePasswordConfig): Map<String, Any?> {
        return mapOf(
            "complexityLevel" to config.complexityLevel,
            "quality" to config.quality,
            "minLength" to config.minLength,
            "minUpperCase" to config.minUpperCase,
            "minLowerCase" to config.minLowerCase,
            "minLetters" to config.minLetters,
            "minNumeric" to config.minNumeric,
            "minSymbols" to config.minSymbols,
            "minNonLetter" to config.minNonLetter,
            "historyLength" to config.historyLength,
            "expirationTimeoutMs" to config.expirationTimeoutMs,
            "maxFailedAttempts" to config.maxFailedAttempts
        )
    }
}