package com.wonkrumdm.core

import android.os.Handler
import android.os.Looper
import android.util.Log

class AnrWatchdog private constructor(
    private val timeoutMs: Long
) : Thread("AnrWatchdog") {

    companion object {
        private const val TAG = "AnrWatchdog"
        private const val DEFAULT_TIMEOUT_MS = 5000L

        @Volatile
        private var instance: AnrWatchdog? = null

        fun start(timeoutMs: Long = DEFAULT_TIMEOUT_MS) {
            if (instance?.isAlive == true) return
            instance = AnrWatchdog(timeoutMs).apply {
                isDaemon = true
                start()
            }
        }

        fun stop() {
            instance?.interrupt()
            instance = null
        }
    }

    private val mainHandler = Handler(Looper.getMainLooper())

    @Volatile
    private var tickCompleted = true

    override fun run() {
        while (!isInterrupted) {
            tickCompleted = false
            mainHandler.post { tickCompleted = true }

            try {
                sleep(timeoutMs)
            } catch (e: InterruptedException) {
                return
            }

            if (!tickCompleted) {
                reportAnr()

                try {
                    sleep(timeoutMs)
                } catch (e: InterruptedException) {
                    return
                }
            }
        }
    }

    private fun reportAnr() {
        val mainThread = Looper.getMainLooper().thread
        val stackTrace = mainThread.stackTrace

        val sb = StringBuilder()
        sb.appendLine("ANR DETECTED")
        sb.appendLine("Main thread blocked for ${timeoutMs}ms+")
        sb.appendLine("Main thread stack trace:")
        for (element in stackTrace) {
            sb.appendLine("  at $element")
        }
        sb.appendLine("Active threads: ${Thread.activeCount()}")

        Log.e(TAG, sb.toString())
    }
}