package com.parental.safety

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class ChildAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "ChildAccessibility"
        var isLocked: Boolean = false
        var blockedPackages: Set<String> = hashSetOf(
            "com.facebook.katana",
            "com.instagram.android",
            "com.zhiliaoapp.musically", // TikTok
            "com.snapchat.android"
        )
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return
            Log.d(TAG, "Foreground package detected: $packageName (Lock state: $isLocked)")

            // If bedtime lock or remote instant lock is active
            if (isLocked && packageName != applicationContext.packageName) {
                bringSafetyAppToFront()
                return
            }

            // If a specific restricted application is opened
            if (blockedPackages.contains(packageName)) {
                Log.w(TAG, "Restricted application opened: $packageName. Intercepting.")
                bringSafetyAppToFront()
            }
        }
    }

    private fun bringSafetyAppToFront() {
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        if (intent != null) {
            startActivity(intent)
        }
    }

    override fun onInterrupt() {
        Log.w(TAG, "ChildAccessibilityService interrupted")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.i(TAG, "ChildAccessibilityService connected and actively protecting")
    }
}
