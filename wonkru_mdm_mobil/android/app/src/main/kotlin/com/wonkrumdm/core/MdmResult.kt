package com.wonkrumdm.core

data class MdmResult(
    val success: Boolean,
    val message: String? = null,
    val data: Any? = null
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "success" to success,
            "message" to message,
            "data" to data
        )
    }
}