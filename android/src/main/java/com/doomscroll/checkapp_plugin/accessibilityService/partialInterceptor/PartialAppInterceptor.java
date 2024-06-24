package com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor;

import static com.doomscroll.checkapp_plugin.Utils.goToHomeScreen;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getParsedSchedules;

import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.doomscroll.checkapp_plugin.ScheduleParser;
import com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.WebsiteBlocker;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class PartialAppInterceptor {
    private static boolean shouldCheckPartialBlockers;

    public static void setShouldCheckPartialBlockers(boolean shouldCheckPartialBlockers) {
        PartialAppInterceptor.shouldCheckPartialBlockers = shouldCheckPartialBlockers;
    }

    public static boolean getShouldCheckPartialBlockers() {
        return shouldCheckPartialBlockers;
    }

    public static Map<String, List<PartialBlockingConfig>> getSupportedPartialBlockings() {
        Map<String, List<PartialBlockingConfig>> partialBlockingConfigList = new HashMap<>();
        List<PartialBlockingConfig> partialBlockingConfigs = new ArrayList<>();
        List<String> idsToBlock = new ArrayList<>();
        idsToBlock.add("youtube:id/reel_player_page_container");
        idsToBlock.add("com.google.android.youtube:id/reel_recycler");


        partialBlockingConfigs.add(new PartialBlockingConfig("com.google.android.youtube", idsToBlock, "Shorts"));

        partialBlockingConfigList.put("com.google.android.youtube", partialBlockingConfigs);

        return partialBlockingConfigList;
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static void checkPartialApplicationBlocked(String nodeId, @NonNull String packageName, Context context) {
        if (nodeId == null) return;

        for (Map<String, Object> schedule : getParsedSchedules()) {
            Map<String, Object> toCheck = ScheduleParser.compileToCheck(schedule);
            PartialAppBlocker partialAppBlocker = new PartialAppBlocker(toCheck);

            boolean shouldBlock = partialAppBlocker.shouldBlockPartialApplication(nodeId, packageName);

            if (shouldBlock) {
                goToHomeScreen(context);
                break;
            }
        }
    }
}
