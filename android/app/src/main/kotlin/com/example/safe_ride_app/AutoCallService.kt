package com.example.yourapp

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class AutoCallService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val rootNode = rootInActiveWindow ?: return
        clickCallButton(rootNode)
    }

    private fun clickCallButton(node: AccessibilityNodeInfo?) {
        if (node == null) return

        if (node.text != null && (node.text.toString().equals("Call", true) || node.text.toString().equals("Appeler", true))) {
            if (node.isClickable) {
                node.performAction(AccessibilityNodeInfo.ACTION_CLICK)
                return
            }
        }

        for (i in 0 until node.childCount) {
            clickCallButton(node.getChild(i))
        }
    }

    override fun onInterrupt() {}
}
