package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.LocationChecker.getFusedLocationClient;
import static com.doomscroll.checkapp_plugin.LocationChecker.startLocationUpdates;
import static com.doomscroll.checkapp_plugin.LocationChecker.stopLocationUpdates;
import static com.doomscroll.checkapp_plugin.ScheduleParser.compileToCheck;
import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
import static com.doomscroll.checkapp_plugin.WifiScan.getCurrentWifiBelowApi31;
import static com.doomscroll.checkapp_plugin.WifiScan.initializeWifiScan;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;

import android.app.Service;
import android.content.Context;

import android.content.Intent;

import android.content.pm.PackageManager;


import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;

public class AppService extends Service {
    final static String REDIRECT_HOME = "REDIRECT_HOME";
    final static String NOTIFICATION_CHANNEL = "NOTIFICATION_CHANNEL";

    static List<Map<String, Object>> schedules;
    final static String REQUEST_LOCATION = "REQUEST_LOCATION";
    final static String STOP_REQUEST_LOCATION = "STOP_REQUEST_LOCATION";

    final static String START = "START";
    final static String STOP = "STOP";
    private static String connectedWifi;
    private static double currentLat;
    private static double currentLng;
    private static Map<String, Object> toCheck;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        switch (Objects.requireNonNull(intent.getAction())) {
            case REDIRECT_HOME:
                goToHomeScreen();
                break;
            case START:
                start();
                break;
            case STOP:
                stopSelf();
                break;
            case STOP_REQUEST_LOCATION:
                stopLocationUpdates();
                break;
            case REQUEST_LOCATION:
                try {
                    startLocationUpdates(this, NOTIFICATION_CHANNEL);
                } catch (PackageManager.NameNotFoundException e) {
                    throw new RuntimeException(e);
                }
                break;


        }
        return super.onStartCommand(intent, flags, startId);
    }

    private void goToHomeScreen() {
        Intent startMain = new Intent(Intent.ACTION_MAIN);
        startMain.addCategory(Intent.CATEGORY_HOME);
        startMain.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startMain.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        this.startActivity(startMain);

    }

    public static void createIntentForService(Context context, String intentAction) {
        Intent serviceIntent = new Intent(context, AppService.class);
        serviceIntent.setAction(intentAction);
        context.startService(serviceIntent);
    }

    private void start() {
        Notification notification = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL).setContentText("This service runs in the foreground to check your location/wifi/app usage according to your enabled app blocking schedule").build();
        startForeground(1, notification);
        initializeWifiScan(this);

    }
    //        code for starting service

    public static void initializeServiceAtFlutter(Context context) {
        try (DatabaseHelper dbHelper = new DatabaseHelper(context)) {
            String userId = dbHelper.getUserId();
            if (!Objects.equals(userId, "user")) {
                schedules = dbHelper.getSchedules(userId);
                ScheduleParser parser = new ScheduleParser(schedules);
                toCheck = compileToCheck();

                toCheck.put("currentLat", currentLat);
                toCheck.put("currentLng", currentLng);
                Timer timer = new Timer();
                BlockTask blockTask = new BlockTask(toCheck, context);
                timer.schedule(blockTask, 0, 2000);

            }
        } catch (Exception e) {
            // Handle any exceptions that may occur
            e.printStackTrace();
        }
        Intent serviceIntent = new Intent(context, AppService.class);
        serviceIntent.setAction(START);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL, "Running Notification", NotificationManager.IMPORTANCE_NONE);
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);


            context.startForegroundService(serviceIntent);


        } else {
            context.startService(serviceIntent);

        }
        getFusedLocationClient(context);
//         queries the active schedules
        createIntentForService(context, REQUEST_LOCATION); // autostarts location if active schedule demands for it
//         autostart wifi if active schedule demands for it
//        should stop location & wifi when no active schedule needs it
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getConnectedWiFiSSID(context);
        }else{
            getCurrentWifiBelowApi31(context);
        }


    }

    public static void setConnectedWifi(String currentConnectedWifi) {
        connectedWifi = currentConnectedWifi;

        toCheck.put("currentWifi", connectedWifi);
    }

    public static void setLatLng(double lat, double lng) {
        currentLat = lat;
        currentLng = lng;
    }

}


