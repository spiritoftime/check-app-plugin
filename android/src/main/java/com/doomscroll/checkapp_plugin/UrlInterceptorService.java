package com.doomscroll.checkapp_plugin;


import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Build;
import android.provider.Browser;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import android.net.Uri;

public class UrlInterceptorService extends AccessibilityService {
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
        if (nodes == null || ((List<?>) nodes).size() <= 0) {
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
        String id = parentNodeInfo.getViewIdResourceName();
        if (id != null) {
            Log.d("id", id);

        }
        String packageName = event.getPackageName().toString();
        for (PartialBlockingConfig partialBlockingConfig : getSupportedPartialBlockings()) {
            if (partialBlockingConfig.packageName.equals(packageName)) {
                for (String blockedId : partialBlockingConfig.ids) {
                    if (Objects.equals(id, blockedId)) {


                        redirectToHome();
                        break;

                    }
                }
            }
        }

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
//        parentNodeInfo.recycle();

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
            analyzeCapturedUrl(capturedUrl, browserConfig.packageName);
        }
    }

    private void analyzeCapturedUrl(@NonNull String capturedUrl, @NonNull String browserPackage) {
        String redirectUrl = "https://doomscroll_redirect.com";
        if (capturedUrl.contains("facebook.com")) {
            performRedirect(redirectUrl, browserPackage);
        }
    }

    private void redirectToHome() {
        Intent homeIntent = new Intent(Intent.ACTION_MAIN);
        homeIntent.addCategory(Intent.CATEGORY_HOME);
        homeIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(homeIntent);
    }

    /**
     * we just reopen the browser app with our redirect url using service context
     * We may use more complicated solution with invisible activity to send a simple intent to open the url
     */
    private void performRedirect(@NonNull String redirectUrl, @NonNull String browserPackage) {

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(redirectUrl));
            intent.setPackage(browserPackage);
            intent.putExtra(Browser.EXTRA_APPLICATION_ID, browserPackage);

            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);

            startActivity(intent);
        } catch (ActivityNotFoundException e) {
            // the expected browser is not installed
            Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(redirectUrl));
            i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            startActivity(i);
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

    private static class SupportedBrowserConfig {
        public String packageName, addressBarId;

        public SupportedBrowserConfig(String packageName, String addressBarId) {
            this.packageName = packageName;
            this.addressBarId = addressBarId;
        }
    }

    private static class PartialBlockingConfig {
        public String packageName;
        public List<String> ids;

        public PartialBlockingConfig(String packageName, List<String> ids) {
            this.ids = ids;
            this.packageName = packageName;
        }
    }

    private static List<PartialBlockingConfig> getSupportedPartialBlockings() {
        List<PartialBlockingConfig> partialBlockingConfigList = new ArrayList<>();
        List<String> idsToBlock = new ArrayList<>();
        idsToBlock.add("youtube:id/reel_player_page_container");
        idsToBlock.add("com.google.android.youtube:id/watch_player");
        idsToBlock.add("com.google.android.youtube:id/reel_recycler");


        partialBlockingConfigList.add(new PartialBlockingConfig("com.google.android.youtube", idsToBlock));
        return partialBlockingConfigList;
    }

    /**
     * @return a list of supported browser configs
     * This list could be instead obtained from remote server to support future browser updates without updating an app
     */
    @NonNull
    private static List<SupportedBrowserConfig> getSupportedBrowsers() {
        List<SupportedBrowserConfig> browsers = new ArrayList<>();
        browsers.add(new SupportedBrowserConfig("com.android.chrome", "com.android.chrome:id/url_bar"));
        browsers.add(new SupportedBrowserConfig("org.mozilla.firefox", "org.mozilla.firefox:id/url_bar_title"));
        browsers.add(new SupportedBrowserConfig("com.brave.browser", "com.brave.browser:id/url_bar"));

        return browsers;
    }
}