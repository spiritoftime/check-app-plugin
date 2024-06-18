package com.doomscroll.checkapp_plugin;


import static com.doomscroll.checkapp_plugin.CheckappPlugin.isAppInForeground;
import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static com.doomscroll.checkapp_plugin.Utils.isCurrentTimeWithinRange;

import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;
import java.util.Objects;

// see DatabaseHelper query - current obj structure{
//  "currentWifi",  "currentLat","currentLng","locations":[{"longitude","latitude","location"}],"apps":[{"appName","packageName","iconBase64String"}],"wifis":[],"checkWifi","checkLocation","checkApp"
//        }
public class AppBlocker {
    private static boolean blockedAppInUsage = false;
    private static boolean atBlockedLocation = false;
    private static boolean usingBlockedWifi = false;
    private static boolean blockedDay = false;
    private static boolean blockedTiming = false;


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static boolean shouldBlockApp(Map<String, Object> toCheck) {
        boolean shouldCheckApp = (boolean) toCheck.get("checkApp");
        boolean shouldCheckLocation = (boolean) toCheck.get("checkLocation");
        boolean shouldCheckWifi = (boolean) toCheck.get("checkWifi");
        boolean shouldCheckDay = (boolean) toCheck.get("checkDay");
        boolean shouldCheckTiming = (boolean) toCheck.get("checkTiming");


        if (shouldCheckApp) {
            List<Map<String, Object>> apps = (List<Map<String, Object>>) toCheck.get("apps");
            checkAppUsage(apps);
        }

        if (shouldCheckLocation) {
            List<Map<String, Object>> locations = (List<Map<String, Object>>) toCheck.get("locations");
            double currentLat = (double) toCheck.get("currentLat");
            double currentLng = (double) toCheck.get("currentLng");
            checkBlockedLocation(locations, currentLat, currentLng);


        } else {
            atBlockedLocation = true;
        }
        if (shouldCheckWifi) {
            List<String> wifis = (List<String>) toCheck.get("wifis");
            String currentWifi = (String) toCheck.get("currentWifi");
            checkBlockedWifi(wifis, currentWifi);


        } else {
            usingBlockedWifi = true;
        }
        List<String> currentDayTime = getCurrentDayTime();

        if (shouldCheckDay) {
            String currentDay = currentDayTime.get(0);
            List<String> days = (List<String>) toCheck.get("days");
            checkDay(days, currentDay);
        } else {
            blockedDay = true;
        }

        if (shouldCheckTiming) {
            List<Map<String, Object>> timings = (List<Map<String, Object>>) toCheck.get("timings");

            String currentTiming24HFormat = currentDayTime.get(1);

            checkTiming(timings, currentTiming24HFormat);
        } else {
            blockedTiming = true;
        }
        return shouldBlock();

    }
    private static boolean shouldBlock() {
        return usingBlockedWifi && atBlockedLocation && blockedAppInUsage && blockedDay && blockedTiming;
    }
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private static void checkAppUsage(List<Map<String, Object>> apps) {
        for (Map<String, Object> app : apps) {
            String packageName = (String) app.get("packageName");
            blockedAppInUsage = isAppInForeground(packageName);
            if(blockedAppInUsage) {
                break;
            }

        }
    }

    private static void checkBlockedLocation(List<Map<String, Object>> locations, double currentLat, double currentLng) {
        for (Map<String, Object> location : locations) {
            double longitude = (double) location.get("longitude");
            double latitude = (double) location.get("latitude");
            if (latitude == currentLat && longitude == currentLng) {
                atBlockedLocation = true;
                break;
            }


        }
    }

    private static void checkBlockedWifi(List<String> wifis, String currentWifi) {
        for (String wifi : wifis) {
            if (Objects.equals(wifi, currentWifi)) {
                usingBlockedWifi = true;
                break;
            }
        }
    }

    private static void checkDay(List<String> days, String currentDay) {
        for (String day : days) {
            if (Objects.equals(day, currentDay)) {
                blockedDay = true;
                break;
            }
        }
    }

    private static void checkTiming(List<Map<String, Object>> timings, String currentTiming24HFormat) {
        for (Map<String, Object> timing : timings) {
            String startTiming = (String) timing.get("startTiming");
            String endTiming = (String) timing.get("endTiming");
            if (isCurrentTimeWithinRange(startTiming, endTiming, currentTiming24HFormat)) {
                blockedTiming = true;
                break;
            }
        }
    }
}
