package com.doomscroll.checkapp_plugin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScheduleParser {
    private static List<Map<String, Object>> schedules = new ArrayList<>();
    private static boolean shouldCheckLocation;
    private static boolean shouldCheckWifi;

    private static boolean shouldCheckTiming;
    private static boolean shouldCheckDay;


    private static boolean shouldCheckApp;

    public ScheduleParser(List<Map<String, Object>> schedules) {
        ScheduleParser.schedules = schedules;
    }

    public static List<Map<String, Object>> getCheckLocation() {
        List<Map<String, Object>> locationsToCheck = new ArrayList<>();
        for (Map<String, Object> s : schedules) {
            List<List<String>> locations = (List<List<String>>) s.get("locations");
            assert locations != null;
            if (locations.isEmpty()) {
                shouldCheckLocation = false;

            } else {
                shouldCheckLocation = true;
                for (List<String> location : locations) {
                    Map<String, Object> locationMap = new HashMap<>();
                    locationMap.put("longitude", Double.parseDouble(location.get(0)));
                    locationMap.put("latitude", Double.parseDouble(location.get(1)));
                    locationMap.put("location", location.get(2));
                    locationsToCheck.add(locationMap);

                }
            }
//

        }

        return locationsToCheck;
    }

    public static List<String> getCheckWifi() {
        List<String> wifisToCheck = new ArrayList<>();

        for (Map<String, Object> s : schedules) {
            List<String> wifis = (List<String>) s.get("wifis");
            assert wifis != null;
            if (wifis.isEmpty()) {
                shouldCheckWifi = false;
            } else {
                shouldCheckWifi = true;
                wifisToCheck.addAll(wifis);
            }
        }
        return wifisToCheck;
    }

    public static List<Map<String, Object>> getCheckApps() {
        List<Map<String, Object>> appsToCheck = new ArrayList<>();
        for (Map<String, Object> s : schedules) {
            List<List<String>> apps = (List<List<String>>) s.get("apps");
            assert apps != null;
            if (apps.isEmpty()) {
                shouldCheckApp = false;

            } else {
                shouldCheckApp = true;
                for (List<String> app : apps) {
                    Map<String, Object> appMap = new HashMap<>();
                    appMap.put("appName", app.get(0));
                    appMap.put("packageName", app.get(1).replaceAll("\\s+", ""));
                    appMap.put("iconBase64String", app.get(2));
                    appsToCheck.add(appMap);

                }
            }
//

        }
        return appsToCheck;
    }

    public static List<Map<String, Object>> getCheckTiming() {
        List<Map<String, Object>> timingsToCheck = new ArrayList<>();
        for (Map<String, Object> s : schedules) {
            List<List<String>> timings = (List<List<String>>) s.get("timings");
            if (timings.isEmpty()) {
                shouldCheckTiming = false;

            } else {
                shouldCheckTiming = true;
                for (List<String> timing : timings) {
                    Map<String, Object> timingMap = new HashMap<>();
                    timingMap.put("startTiming", timing.get(0));
                    timingMap.put("endTiming", timing.get(1));
                    timingsToCheck.add(timingMap);

                }
            }
//

        }
        return timingsToCheck;
    }


    public static List<String> getCheckDays() {
        List<String> daysToCheck = new ArrayList<>();
        for (Map<String, Object> s : schedules) {
            List<String> days = (List<String>) s.get("days");
            if (days.isEmpty()) {
                shouldCheckDay = false;

            } else {
                shouldCheckDay = true;
                daysToCheck.addAll(days);
            }
//

        }
        return daysToCheck;
    }

    public static Map<String, Object> compileToCheck() {
        List<String> wifisToCheck = getCheckWifi();
        List<String> daysToCheck = getCheckDays();

        List<Map<String, Object>> appsToCheck = getCheckApps();
        List<Map<String, Object>> timingsToCheck = getCheckTiming();

        List<Map<String, Object>> locationsToCheck = getCheckLocation();
        Map<String, Object> toCheck = new HashMap<>();
        toCheck.put("wifis", wifisToCheck);
        toCheck.put("apps", appsToCheck);
        toCheck.put("locations", locationsToCheck);
        toCheck.put("checkWifi", shouldCheckWifi);
        toCheck.put("checkLocation", shouldCheckLocation);
        toCheck.put("checkApp", shouldCheckApp);
        toCheck.put("checkTiming", shouldCheckTiming);
        toCheck.put("timings", timingsToCheck);

        toCheck.put("checkDay", shouldCheckDay);
        toCheck.put("days", daysToCheck);


        return toCheck;

    }
}
