package com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor;


import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.provider.Browser;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

public class BrowserInterceptor {
    /**
     * @return a list of supported browser configs
     * This list could be instead obtained from remote server to support future browser updates without updating an app
     */
    @NonNull
    public static List<SupportedBrowserConfig> getSupportedBrowsers() {
        List<SupportedBrowserConfig> browsers = new ArrayList<>();
        browsers.add(new SupportedBrowserConfig("com.android.chrome", "com.android.chrome:id/url_bar"));
        browsers.add(new SupportedBrowserConfig("org.mozilla.firefox", "org.mozilla.firefox:id/url_bar_title"));
        browsers.add(new SupportedBrowserConfig("com.brave.browser", "com.brave.browser:id/url_bar"));

        return browsers;
    }

    public static void analyzeCapturedUrl(@NonNull String capturedUrl, @NonNull String browserPackage, @NonNull String blockedUrl, @NonNull Context context) {
        String redirectUrl = "https://doomscroll_redirect.com";
        if (capturedUrl.contains(blockedUrl)) {
            performRedirect(redirectUrl, browserPackage, context);
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
}
