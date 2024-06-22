package com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor;

import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.doomscroll.checkapp_plugin.CommonBlockerChecks;
import com.google.gson.reflect.TypeToken;

import java.util.List;
import java.util.Map;

public class WebsiteBlocker extends CommonBlockerChecks {
    private boolean blockedWebsiteInUsage = false;


    public WebsiteBlocker(Map<String, Object> toCheck) {
        super(toCheck);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public boolean shouldBlockWebsite( String capturedUrl) {
        checkWebsiteUsage( capturedUrl);
        checkCommonBlockers();
        return shouldBlock();
    }

    boolean shouldBlock() {
        return blockedWebsiteInUsage && commonBlockers;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private void checkWebsiteUsage( String capturedUrl) {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckWebsite = safeCast(toCheck.get("checkKeyword"), booleanTypeToken) || safeCast(toCheck.get("checkWebsite"), booleanTypeToken);
        if(!shouldCheckWebsite) return;
        TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
        };
        List<String> keywords = safeCast(toCheck.get("keywords"), typeToken);
        for (String keyword : keywords) {
            if (capturedUrl.contains(keyword)) {
                blockedWebsiteInUsage = true;
                break;
            }
        }
        List<String> websites = safeCast(toCheck.get("websites"), typeToken);
        for (String website : websites) {
            if (capturedUrl.contains(website)) {
                blockedWebsiteInUsage = true;
                break;
            }
        }


    }
}

