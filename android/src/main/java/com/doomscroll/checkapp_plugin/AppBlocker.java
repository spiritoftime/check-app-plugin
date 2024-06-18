package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;
import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;
import static com.doomscroll.checkapp_plugin.CheckappPlugin.isAppInForeground;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;
import java.util.Objects;

//{
//  "currentWifi",  "currentLat","currentLng","locations":[{"longitude","latitude","location"}],"apps":[{"appName","packageName","iconBase64String"}],"wifis":[],"checkWifi","checkLocation","checkApp"
//        }
public class AppBlocker {
    private static boolean blockedAppInUsage = false;
    private static boolean atBlockedLocation = false;
    private static boolean usingBlockedWifi = false;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static boolean shouldBlockApp(Map<String, Object> toCheck) {
        boolean shouldCheckApp = (boolean) toCheck.get("checkApp");
        boolean shouldCheckLocation = (boolean) toCheck.get("checkLocation");
        boolean shouldCheckWifi = (boolean) toCheck.get("checkWifi");

        if (shouldCheckApp) {
            List<Map<String, Object>> apps = (List<Map<String, Object>>) toCheck.get("apps");
            for (Map<String, Object> app : apps) {
                String packageName = (String) app.get("packageName");
                blockedAppInUsage = isAppInForeground(packageName);
                break;


            }
        }

        if (shouldCheckLocation) {
            List<Map<String, Object>> locations = (List<Map<String, Object>>) toCheck.get("locations");
            double currentLat = (double) toCheck.get("currentLat");
            double currentLng = (double) toCheck.get("currentLng");

            for (Map<String, Object> location : locations) {
                double longitude = (double) location.get("longitude");
                double latitude = (double) location.get("latitude");
                if (latitude == currentLat && longitude == currentLng) {
                    atBlockedLocation = true;
                    break;
                }


            }

        } else {
            atBlockedLocation = true;
        }
        if (shouldCheckWifi) {
            List<String> wifis = (List<String>) toCheck.get("wifis");
            String currentWifi = (String) toCheck.get("currentWifi");

            for (String wifi : wifis) {
                if (Objects.equals(wifi, currentWifi)) {
                    usingBlockedWifi = true;
                    break;
                }
            }

        } else {
            usingBlockedWifi = true;
        }
        return (usingBlockedWifi && atBlockedLocation && blockedAppInUsage ) ;

    }
}
