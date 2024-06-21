package com.doomscroll.checkapp_plugin.appBlocker;

import android.app.usage.UsageEvents;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;

import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import com.doomscroll.checkapp_plugin.CommonBlockerChecks;
import com.google.gson.reflect.TypeToken;

public class AppBlocker extends CommonBlockerChecks {
    private boolean blockedAppInUsage = false;

    public AppBlocker(Map<String, Object> toCheck) {
        super(toCheck);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public boolean shouldBlockApp(Context context) {
        checkAppUsage(context);
        checkCommonBlockers();
        return shouldBlock();
    }


    boolean shouldBlock() {
        return blockedAppInUsage && commonBlockers;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private void checkAppUsage(Context context) {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckApp = safeCast(toCheck.get("checkApp"), booleanTypeToken);
        if (shouldCheckApp) {
            TypeToken<List<Map<String, Object>>> typeToken = new TypeToken<List<Map<String, Object>>>() {
            };
            List<Map<String, Object>> apps = safeCast(toCheck.get("apps"), typeToken);
            for (Map<String, Object> app : apps) {
                String packageName = (String) app.get("packageName");
                blockedAppInUsage = isAppInForeground(packageName, context);
                if (blockedAppInUsage) {
                    break;
                }
            }
        }

    }
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static boolean isAppInForeground(String packageName, Context context) {
        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
        long endTime = System.currentTimeMillis();
        long beginTime = endTime - 80000; // delay in checking wifi/ location when user just turned on gps/ reboot.
        UsageEvents usageEvents = usageStatsManager.queryEvents(beginTime, endTime);
        UsageEvents.Event event = new UsageEvents.Event();
        long lastResumedTime = 0;
        long lastPausedTime = 0;

        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event);
            if (packageName.equals(event.getPackageName())) {
                if (event.getEventType() == UsageEvents.Event.ACTIVITY_RESUMED) {
                    lastResumedTime = event.getTimeStamp();
                } else if (event.getEventType() == UsageEvents.Event.ACTIVITY_PAUSED) {
                    lastPausedTime = event.getTimeStamp();
                }
            }
        }


        return lastResumedTime > lastPausedTime && (endTime - lastResumedTime) < 80000;
    }
}
