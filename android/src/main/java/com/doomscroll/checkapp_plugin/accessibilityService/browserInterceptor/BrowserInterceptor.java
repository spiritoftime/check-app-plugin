package com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor;


import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;
import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Browser;
import android.view.accessibility.AccessibilityNodeInfo;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.doomscroll.checkapp_plugin.ScheduleParser;
import com.doomscroll.checkapp_plugin.appBlocker.AppBlocker;
import com.doomscroll.checkapp_plugin.appBlocker.BlockTask;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BrowserInterceptor {
    private static BrowserInterceptor instance;

    private static List<Map<String, Object>> parsedSchedules = new ArrayList<>();

    private BrowserInterceptor(List<Map<String, Object>> parsedSchedules) {
        BrowserInterceptor.parsedSchedules = parsedSchedules;
    }

    public static synchronized BrowserInterceptor getInstance(List<Map<String, Object>> parsedSchedules) {
        if (instance == null) {
            instance = new BrowserInterceptor(parsedSchedules);
        } else {
            instance.updateParsedSchedules(parsedSchedules);
        }
        return instance;
    }

    // Method to update parsedSchedules
    private void updateParsedSchedules(List<Map<String, Object>> parsedSchedules) {
        BrowserInterceptor.parsedSchedules = parsedSchedules;
    }

    // Getter for parsedSchedules
    public static List<Map<String, Object>> getParsedSchedules() {
        return parsedSchedules;
    }

    private static boolean shouldCheckWebsites;
    private static boolean shouldCheckKeywords;

    public static boolean getShouldCheckKeywords() {
        return shouldCheckKeywords;
    }

    public static boolean getShouldCheckWebsites() {
        return shouldCheckWebsites;
    }

    public static void setShouldCheckKeywords(boolean shouldCheckKeywords) {
        BrowserInterceptor.shouldCheckKeywords = shouldCheckKeywords;
    }

    public static void setShouldCheckWebsites(boolean shouldCheckWebsites) {
        BrowserInterceptor.shouldCheckWebsites = shouldCheckWebsites;
    }

    private static List<SupportedBrowserConfig> supportedBrowserConfigs = new ArrayList<>();

    public static List<SupportedBrowserConfig> getSupportedBrowserConfigs() {
        return supportedBrowserConfigs;
    }

    public static void setSupportedBrowserConfigs(List<SupportedBrowserConfig> supportedBrowserConfigs) {
        BrowserInterceptor.supportedBrowserConfigs = supportedBrowserConfigs;
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static void analyzeCapturedUrl(@NonNull String capturedUrl, @NonNull String browserPackage, @NonNull Context context) {
        String redirectUrl = "https://doomscroll_redirect.com";
        for (Map<String, Object> schedule : parsedSchedules) {
            Map<String, Object> toCheck = ScheduleParser.compileToCheck(schedule);
            WebsiteBlocker websiteBlocker = new WebsiteBlocker(toCheck);

            boolean shouldBlock = websiteBlocker.shouldBlockWebsite(capturedUrl);

            if (shouldBlock) {
                performRedirect(redirectUrl, browserPackage, context);
                break;
            }

        }
    }

    /**
     * we just reopen the browser app with our redirect url using service context
     * We may use more complicated solution with invisible activity to send a simple intent to open the url
     */
    public static void performRedirect(@NonNull String redirectUrl, @NonNull String browserPackage, @NonNull Context context) {

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(redirectUrl));
            intent.setPackage(browserPackage);
            intent.putExtra(Browser.EXTRA_APPLICATION_ID, browserPackage);

            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);

            context.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            // the expected browser is not installed
            Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(redirectUrl));
            i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            context.startActivity(i);
        }
    }

    public static String captureUrl(AccessibilityNodeInfo info, SupportedBrowserConfig config) {
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
}
