package com.doomscroll.checkapp_plugin.accessibilityService;


import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.analyzeCapturedUrl;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getSupportedBrowsers;
import static com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialAppInterceptor.checkPartiallyBlocked;
import static com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialAppInterceptor.getSupportedPartialBlockings;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;

import android.os.Build;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;


import com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.SupportedBrowserConfig;
import com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialBlockingConfig;

/**
 * Used to block websites (browserInterceptor)
 * and parts of application (eg. Youtube Shorts) - partialInterceptor
 */
public class AccessibilityInterceptorService extends AccessibilityService {
    private final HashMap<String, Long> previousUrlDetections = new HashMap<>();

    @Override
    protected void onServiceConnected() {
        AccessibilityServiceInfo info = getServiceInfo();
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED;
        info.packageNames = packageNames();
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_VISUAL;
        //throttling of accessibility event notification
        info.notificationTimeout = 300;
        //support ids interception
        info.flags = AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS |
                AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS;

        this.setServiceInfo(info);
    }

    private String captureUrl(AccessibilityNodeInfo info, SupportedBrowserConfig config) {
        List<AccessibilityNodeInfo> nodes = info.findAccessibilityNodeInfosByViewId(config.addressBarId);
        if (nodes == null || ((List<?>) nodes).isEmpty()) {
            return null;
        }

        AccessibilityNodeInfo addressBarNodeInfo = nodes.get(0);
        String url = null;
        if (addressBarNodeInfo.getText() != null) {
            url = addressBarNodeInfo.getText().toString();
        }
        addressBarNodeInfo.recycle();
        return url;
    }


    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void onAccessibilityEvent(@NonNull AccessibilityEvent event) {
        AccessibilityNodeInfo parentNodeInfo = event.getSource();


        if (parentNodeInfo == null) {
            return;
        }
        String nodeId = parentNodeInfo.getViewIdResourceName();
        String packageName = event.getPackageName().toString();

        checkPartiallyBlocked(nodeId, packageName, this);

        SupportedBrowserConfig browserConfig = null;
        for (SupportedBrowserConfig supportedConfig : getSupportedBrowsers()) {
            if (supportedConfig.packageName.equals(packageName)) {
                browserConfig = supportedConfig;
            }
        }
        //this is not supported browser, so exit
        if (browserConfig == null) {
            return;
        }

        String capturedUrl = captureUrl(parentNodeInfo, browserConfig);

        //we can't find a url. Browser either was updated or opened page without url text field
        if (capturedUrl == null) {
            return;
        }

        long eventTime = event.getEventTime();
        String detectionId = packageName + ", and url " + capturedUrl;
        //noinspection ConstantConditions
        long lastRecordedTime = previousUrlDetections.containsKey(detectionId) ? previousUrlDetections.get(detectionId) : 0;
        //some kind of redirect throttling
        if (eventTime - lastRecordedTime > 2000) {
            previousUrlDetections.put(detectionId, eventTime);
            analyzeCapturedUrl(capturedUrl, browserConfig.packageName, "facebook.com", this);
        }
    }


    @Override
    public void onInterrupt() {
    }

    @NonNull
    private static String[] packageNames() {
        List<String> packageNames = new ArrayList<>();
        for (SupportedBrowserConfig config : getSupportedBrowsers()) {
            packageNames.add(config.packageName);
        }
        for (PartialBlockingConfig config : getSupportedPartialBlockings()) {
            packageNames.add(config.packageName);
        }
        return packageNames.toArray(new String[0]);
    }


}