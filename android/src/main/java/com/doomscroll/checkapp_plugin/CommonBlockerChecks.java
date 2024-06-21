package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static com.doomscroll.checkapp_plugin.Utils.isCurrentTimeWithinRange;
import static com.doomscroll.checkapp_plugin.Utils.roundToDecimalPlaces;
import static com.doomscroll.checkapp_plugin.Utils.safeCast;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentConnectedWifi;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentLat;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentLng;


import com.google.gson.reflect.TypeToken;

import java.util.List;
import java.util.Map;
import java.util.Objects;

public abstract class CommonBlockerChecks {
    protected boolean atBlockedLocation = false;
    protected boolean usingBlockedWifi = false;
    protected boolean blockedDay = false;
    protected boolean blockedTiming = false;
    protected boolean commonBlockers = false;
    protected Map<String, Object> toCheck;

public CommonBlockerChecks(Map<String, Object> toCheck){
    this.toCheck = toCheck;

}

    protected void checkCommonBlockers() {
        checkBlockedLocation();
        checkTiming();
        checkBlockedWifi();
        checkDay();
        commonBlockers = usingBlockedWifi && atBlockedLocation && blockedDay && blockedTiming;
    }

    protected void checkBlockedLocation() {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckLocation = safeCast(toCheck.get("checkLocation"), booleanTypeToken);
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

    protected void checkBlockedWifi() {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };

        boolean shouldCheckWifi = safeCast(toCheck.get("checkWifi"), booleanTypeToken);
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

    protected void checkDay() {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckDay = safeCast(toCheck.get("checkDay"), booleanTypeToken);
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

    protected void checkTiming() {
        List<String> currentDayTime = getCurrentDayTime();
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };


        boolean shouldCheckTiming = safeCast(toCheck.get("checkTiming"), booleanTypeToken);
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
