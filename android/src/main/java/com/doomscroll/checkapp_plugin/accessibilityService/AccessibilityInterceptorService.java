package com.doomscroll.checkapp_plugin.accessibilityService;


import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.analyzeCapturedUrl;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.captureUrl;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getShouldCheckKeywords;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getShouldCheckWebsites;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getSupportedBrowserConfigs;
import static com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialAppInterceptor.checkPartialApplicationBlocked;
import static com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialAppInterceptor.getShouldCheckPartialBlockers;
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


import com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.SupportedBrowserConfig;
import com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialBlockingConfig;

/**
 * Used to block websites (browserInterceptor)
 * and parts of application (eg. Youtube Shorts) - partialInterceptor
 */
public class AccessibilityInterceptorService extends AccessibilityService {
    private final HashMap<String, Long> previousUrlDetections = new HashMap<>();

    private  void setServiceInfo() {

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

    @Override
    protected void onServiceConnected() {
//NOTE: on debug mode you may need to enable twice. not an issue in prod
        setServiceInfo();
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    @Override
    public void onAccessibilityEvent(@NonNull AccessibilityEvent event) {
        AccessibilityNodeInfo parentNodeInfo = event.getSource();


        if (parentNodeInfo == null) {
            return;
        }
        String nodeId = parentNodeInfo.getViewIdResourceName();
        String packageName = event.getPackageName().toString();
        if (getShouldCheckPartialBlockers()) {
            checkPartialApplicationBlocked(nodeId, packageName, this);
        }
        if (!getShouldCheckKeywords() && !getShouldCheckWebsites()) return;

        SupportedBrowserConfig browserConfig = null;
        for (SupportedBrowserConfig supportedConfig : getSupportedBrowserConfigs()) {
            if (supportedConfig.packageName.equals(packageName)) {
                browserConfig = supportedConfig;
            }
        }
        //this is not supported browser, so exit
        if (browserConfig == null) {
            return;
        }
        String capturedUrl = captureUrl(parentNodeInfo, browserConfig);


        if (capturedUrl == null || capturedUrl.equals("doomscroll_redirect.com")) {
            return;
        }

        long eventTime = event.getEventTime();
        String detectionId = packageName + ", and url " + capturedUrl;
        //noinspection ConstantConditions
        long lastRecordedTime = previousUrlDetections.containsKey(detectionId) ? previousUrlDetections.get(detectionId) : 0;
        //some kind of redirect throttling
        if (eventTime - lastRecordedTime > 2000) {
            previousUrlDetections.put(detectionId, eventTime);
            analyzeCapturedUrl(capturedUrl, browserConfig.packageName, this);
        }
    }


    @Override
    public void onInterrupt() {
    }

    @NonNull
    private static String[] packageNames() {
        List<String> packageNames = new ArrayList<>();
        for (SupportedBrowserConfig config : getSupportedBrowserConfigs()) {
            packageNames.add(config.packageName);
        }
        packageNames.addAll(getSupportedPartialBlockings().keySet());
        return packageNames.toArray(new String[0]);
    }


}