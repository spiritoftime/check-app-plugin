package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;
import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;


import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;
import java.util.TimerTask;


public class BlockTask extends TimerTask {
    private final List<Map<String, Object>> schedules;
    private final Context context;
    private static boolean requestConnectedWifi;
    private static boolean requestCurrentLocation;
    private static double currentLat;
    private static double currentLng;
    private static String connectedWifi;
    public static String getCurrentConnectedWifi() {
        return connectedWifi;
    }

    public static void setConnectedWifi(String currentConnectedWifi) {
        connectedWifi = currentConnectedWifi;

    }

    public static void setRequestConnectedWifi(boolean requestConnectedWifi) {
        BlockTask.requestConnectedWifi = requestConnectedWifi;
    }

    public static void setRequestCurrentLocation(boolean requestCurrentLocation) {
        BlockTask.requestCurrentLocation = requestCurrentLocation;
    }

    public static boolean getRequestConnectedWifi() {
        return requestConnectedWifi;
    }

    public static boolean getRequestCurrentLocation() {
        return requestCurrentLocation;
    }
    public static double getCurrentLat() {
        return currentLat;
    }
    public static double getCurrentLng() {
        return currentLng;
    }

    public static void setCurrentLat(double currentLat) {
        BlockTask.currentLat = currentLat;
    }
    public static void setCurrentLng(double currentLng){
        BlockTask.currentLng = currentLng;
    }

    public BlockTask(List<Map<String, Object>> schedules, Context context) {
        this.schedules = schedules;
        this.context = context;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    @Override
    public void run() {


        for (Map<String, Object> schedule : schedules) {

            AppBlocker appBlocker = new AppBlocker();
            Map<String, Object> toCheck = ScheduleParser.compileToCheck(schedule);
            boolean shouldBlock = appBlocker.shouldBlockApp(toCheck,context);

            if (shouldBlock) {
                createIntentForService(context, REDIRECT_HOME);
                break;
            }
        }
    }
}
