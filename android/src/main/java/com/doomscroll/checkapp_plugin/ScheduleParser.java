package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.BlockTask.setRequestConnectedWifi;
import static com.doomscroll.checkapp_plugin.BlockTask.setRequestCurrentLocation;
import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScheduleParser {
    private final List<Map<String, Object>> schedules;

    public ScheduleParser(List<Map<String, Object>> schedules) {
        this.schedules = schedules;
//         service first start set requestConnectedWifi & requestCurrentLocation
        for (Map<String, Object> schedule : schedules) {
            getCheckWifi(schedule);
            getCheckLocation(schedule);
        }
    }

    public List<Map<String, Object>> getSchedules() {
        return schedules;
    }

    public static Map<String, Object> compileToCheck(Map<String, Object> schedule) {
        List<String> wifisToCheck = getCheckWifi(schedule);
        List<String> daysToCheck = getCheckDays(schedule);
        List<Map<String, Object>> appsToCheck = getCheckApps(schedule);
        List<Map<String, Object>> timingsToCheck = getCheckTiming(schedule);
        List<Map<String, Object>> locationsToCheck = getCheckLocation(schedule);

        Map<String, Object> toCheck = new HashMap<>();
        toCheck.put("wifis", wifisToCheck);
        toCheck.put("apps", appsToCheck);
        toCheck.put("locations", locationsToCheck);
        toCheck.put("checkWifi", !wifisToCheck.isEmpty());
        toCheck.put("checkLocation", !locationsToCheck.isEmpty());
        toCheck.put("checkApp", !appsToCheck.isEmpty());
        toCheck.put("checkTiming", !timingsToCheck.isEmpty());
        toCheck.put("timings", timingsToCheck);
        toCheck.put("checkDay", !daysToCheck.isEmpty());
        toCheck.put("days", daysToCheck);

        return toCheck;
    }

    private static List<Map<String, Object>> getCheckLocation(Map<String, Object> schedule) {

        TypeToken<List<List<String>>> typeToken = new TypeToken<List<List<String>>>() {
        };

        List<List<String>> locations = safeCast(schedule.get("locations"), typeToken);

        List<Map<String, Object>> locationsToCheck = new ArrayList<>();
        if (!locations.isEmpty()) {
            setRequestCurrentLocation(true);
            for (List<String> location : locations) {
                Map<String, Object> locationMap = new HashMap<>();
                locationMap.put("longitude", Double.parseDouble(location.get(0)));
                locationMap.put("latitude", Double.parseDouble(location.get(1)));
                locationMap.put("location", location.get(2));
                locationsToCheck.add(locationMap);
            }
        }
        return locationsToCheck;
    }

    private static List<String> getCheckWifi(Map<String, Object> schedule) {
        List<String> wifisToCheck = new ArrayList<>();
        TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
        };

        List<String> wifis = safeCast(schedule.get("wifis"), typeToken);
        if (!wifis.isEmpty()) {
            setRequestConnectedWifi(true);
            wifisToCheck.addAll(wifis);
        }
        return wifisToCheck;
    }

    private static List<Map<String, Object>> getCheckApps(Map<String, Object> schedule) {
        List<Map<String, Object>> appsToCheck = new ArrayList<>();
        TypeToken<List<List<String>>> typeToken = new TypeToken<List<List<String>>>() {
        };
        List<List<String>> apps = safeCast(schedule.get("apps"), typeToken);

        if (!apps.isEmpty()) {
            for (List<String> app : apps) {
                Map<String, Object> appMap = new HashMap<>();
                appMap.put("appName", app.get(0));
                appMap.put("packageName", app.get(1).replaceAll("\\s+", ""));
                appMap.put("iconBase64String", app.get(2));
                appsToCheck.add(appMap);
            }
        }
        return appsToCheck;
    }

    private static List<Map<String, Object>> getCheckTiming(Map<String, Object> schedule) {
        List<Map<String, Object>> timingsToCheck = new ArrayList<>();
        TypeToken<List<List<String>>> typeToken = new TypeToken<List<List<String>>>() {
        };

        List<List<String>> timings = safeCast(schedule.get("timings"), typeToken);
        if (!timings.isEmpty()) {
            for (List<String> timing : timings) {
                Map<String, Object> timingMap = new HashMap<>();
                timingMap.put("startTiming", timing.get(0));
                timingMap.put("endTiming", timing.get(1));
                timingsToCheck.add(timingMap);
            }
        }
        return timingsToCheck;
    }

    private static List<String> getCheckDays(Map<String, Object> schedule) {

        List<String> daysToCheck = new ArrayList<>();
        TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
        };

        List<String> days = safeCast(schedule.get("days"), typeToken);
        if (!days.isEmpty()) {
            daysToCheck.addAll(days);
        }
        return daysToCheck;
    }
}
