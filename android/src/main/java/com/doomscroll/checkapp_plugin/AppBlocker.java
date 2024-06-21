package com.doomscroll.checkapp_plugin;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import static com.doomscroll.checkapp_plugin.BlockTask.getCurrentConnectedWifi;
import static com.doomscroll.checkapp_plugin.BlockTask.getCurrentLat;
import static com.doomscroll.checkapp_plugin.BlockTask.getCurrentLng;
import static com.doomscroll.checkapp_plugin.CheckappPlugin.isAppInForeground;
import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static com.doomscroll.checkapp_plugin.Utils.isCurrentTimeWithinRange;
import static com.doomscroll.checkapp_plugin.Utils.roundToDecimalPlaces;
import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import com.google.gson.reflect.TypeToken;

public class AppBlocker {
    private boolean blockedAppInUsage = false;
    private boolean atBlockedLocation = false;
    private boolean usingBlockedWifi = false;
    private boolean blockedDay = false;
    private boolean blockedTiming = false;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public boolean shouldBlockApp(Map<String, Object> toCheck, Context context) {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckApp = safeCast(toCheck.get("checkApp"), booleanTypeToken);
        boolean shouldCheckLocation = safeCast(toCheck.get("checkLocation"), booleanTypeToken);

        boolean shouldCheckWifi = safeCast(toCheck.get("checkWifi"), booleanTypeToken);

        boolean shouldCheckDay = safeCast(toCheck.get("checkDay"), booleanTypeToken);
        boolean shouldCheckTiming = safeCast(toCheck.get("checkTiming"), booleanTypeToken);

        checkAppUsage(toCheck, shouldCheckApp, context);
        checkBlockedLocation(toCheck, shouldCheckLocation);
        checkBlockedWifi(toCheck, shouldCheckWifi);
        checkDay(toCheck, shouldCheckDay);
        checkTiming(toCheck, shouldCheckTiming);

        return shouldBlock();
    }

    private boolean shouldBlock() {
        return usingBlockedWifi && atBlockedLocation && blockedAppInUsage && blockedDay && blockedTiming;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private void checkAppUsage(Map<String, Object> toCheck, boolean shouldCheckApp, Context context) {
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

    private void checkBlockedLocation(Map<String, Object> toCheck, boolean shouldCheckLocation) {
        if (shouldCheckLocation) {
            TypeToken<List<Map<String, Object>>> typeToken = new TypeToken<List<Map<String, Object>>>() {
            };
            List<Map<String, Object>> locations = safeCast(toCheck.get("locations"), typeToken);


            double currentLat = getCurrentLat();
            double currentLng = getCurrentLng();
            for (Map<String, Object> location : locations) {
                TypeToken<Double> doubleTypeToken = new TypeToken<Double>() {
                };
                double longitude = safeCast(location.get("longitude"), doubleTypeToken);
                double latitude = safeCast(location.get("latitude"), doubleTypeToken);

//            note: cannot just do equality check.
//            1 decimal place: This level of precision can identify a region within about 111 kilometers (69 miles).
//            2 decimal places: This can identify a region within about 1.1 kilometers (0.69 miles).
//            3 decimal places: This can identify a region within about 110 meters (361 feet).
//            4 decimal places: This can identify a region within about 11 meters (36 feet).
//            5 decimal places: This can identify a region within about 1.1 meters (3.6 feet).
//            6 decimal places: This can identify a region within about 11 centimeters (4.3 inches).
//            7 decimal places: This can identify a region within about 1.1 centimeters (0.4 inches).
//            8 decimal places: This can identify a region within about 1.1 millimeters (0.04 inches).

                if (roundToDecimalPlaces(latitude, 3) == roundToDecimalPlaces(currentLat, 3)
                        && roundToDecimalPlaces(longitude, 3) == roundToDecimalPlaces(currentLng, 3)) {
                    atBlockedLocation = true;
                    break;
                } else atBlockedLocation = false;
            }

        } else {
            atBlockedLocation = true;
        }

    }

    private void checkBlockedWifi(Map<String, Object> toCheck, boolean shouldCheckWifi) {
        if (shouldCheckWifi) {
            TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
            };
            List<String> wifis = safeCast(toCheck.get("wifis"), typeToken);
            String currentWifi = getCurrentConnectedWifi();
            for (String wifi : wifis) {
                if (Objects.equals(wifi, currentWifi)) {
                    usingBlockedWifi = true;
                    break;
                } else {
                    usingBlockedWifi = false;
                }
            }
        } else {
            usingBlockedWifi = true;
        }


    }

    private void checkDay(Map<String, Object> toCheck, boolean shouldCheckDay) {
        List<String> currentDayTime = getCurrentDayTime();

        if (shouldCheckDay) {
            String currentDay = currentDayTime.get(0);

            TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
            };
            List<String> days = safeCast(toCheck.get("days"), typeToken);

            for (String day : days) {
                if (Objects.equals(day, currentDay)) {
                    blockedDay = true;
                    break;
                } else {
                    blockedDay = false;
                }
            }
        } else {
            blockedDay = true;
        }

    }

    private void checkTiming(Map<String, Object> toCheck, boolean shouldCheckTiming) {
        List<String> currentDayTime = getCurrentDayTime();

        if (shouldCheckTiming) {
            TypeToken<List<Map<String, Object>>> typeToken = new TypeToken<List<Map<String, Object>>>() {
            };
            List<Map<String, Object>> timings = safeCast(toCheck.get("timings"), typeToken);
            String currentTiming24HFormat = currentDayTime.get(1);

            for (Map<String, Object> timing : timings) {
                String startTiming = (String) timing.get("startTiming");
                String endTiming = (String) timing.get("endTiming");
                if (isCurrentTimeWithinRange(startTiming, endTiming, currentTiming24HFormat)) {
                    blockedTiming = true;
                    break;
                } else {
                    blockedTiming = false;
                }
            }
        } else {
            blockedTiming = true;
        }


    }
}
