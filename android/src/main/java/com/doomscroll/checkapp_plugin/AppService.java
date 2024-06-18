package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.LocationChecker.getFusedLocationClient;
import static com.doomscroll.checkapp_plugin.LocationChecker.startLocationUpdates;
import static com.doomscroll.checkapp_plugin.LocationChecker.stopLocationUpdates;
import static com.doomscroll.checkapp_plugin.ScheduleParser.compileToCheck;
//import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
//import static com.doomscroll.checkapp_plugin.WifiScan.getCurrentWifiBelowApi31;
import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
import static com.doomscroll.checkapp_plugin.WifiScan.initializeWifiScan;
import static com.doomscroll.checkapp_plugin.WifiScan.stopWifiTaskTimer;
import static com.doomscroll.checkapp_plugin.WifiScan.unregisterWifiScanReceiver;
//import static com.doomscroll.checkapp_plugin.WifiScan.stopWifiTaskTimer;

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
    private static Map<String, Object> toCheck = new HashMap<>();
    static Timer belowAPI31WifiTimer;
    static boolean belowAPI31WifiTimerCreated;

    static Timer blockAppTimer;
    static boolean blockAppTimerCreated;
    static boolean isWifiScanReceiverFirstRegistered = false;

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


    }

    @Override
    public void onCreate() {
        super.onCreate();
        initializeWifiScan(this);
    }

    public static void initializeService(Context context) {
        String userId = "user";
        //                    ----------------------start foreground service --------------------

        Intent serviceIntent = new Intent(context, AppService.class);
        serviceIntent.setAction(START);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL, "Running Notification", NotificationManager.IMPORTANCE_NONE);
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);


            context.startForegroundService(serviceIntent);
            getFusedLocationClient(context);


        } else {
            context.startService(serviceIntent);

        }
        try (DatabaseHelper dbHelper = new DatabaseHelper(context)) {
            userId = dbHelper.getUserId();
            if (!Objects.equals(userId, "user")) {
                schedules = dbHelper.getSchedules(userId);
                if (!schedules.isEmpty()) {
//                    ----------------------start creating task to block app--------------------
                    new ScheduleParser(schedules);
                    toCheck = compileToCheck();

                    toCheck.put("currentLat", currentLat);
                    toCheck.put("currentLng", currentLng);
                    blockAppTimer = new Timer();
                    BlockTask blockTask = new BlockTask(toCheck, context);
                    blockAppTimer.schedule(blockTask, 0, 2000);

                    //                    ----------------------start location update --------------------
                    if (!Objects.equals(userId, "user") && !schedules.isEmpty()) {
                        if (Boolean.TRUE.equals(toCheck.get("checkLocation"))) {
                            createIntentForService(context, REQUEST_LOCATION); // autostart location if active schedule demands for it
                        } else {
                            createIntentForService(context, STOP_REQUEST_LOCATION);
                        }
                        //                    ----------------------start wifi update --------------------
//         autostart wifi if active schedule demands for it
//        should stop location & wifi when no active schedule needs it
                        if (Boolean.TRUE.equals(toCheck.get("checkWifi"))) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                                getConnectedWiFiSSID(context);
                            } else {
                                belowAPI31WifiTimer = new Timer();
                                BelowApi31WifiCheckerTask belowApi31WifiCheckerTask = new BelowApi31WifiCheckerTask(context);
                                belowAPI31WifiTimer.schedule(belowApi31WifiCheckerTask, 0, 2000);
                                belowAPI31WifiTimerCreated = true;
                            }
                        } else {
                            stopWifiTaskTimer();
                            if (belowAPI31WifiTimerCreated) {
                                belowAPI31WifiTimer.cancel();
                            }
                        }


                    }
                } else{

                    createIntentForService(context,STOP);
                }


            }


        } catch (Exception e) {
            // Handle any exceptions that may occur
            Log.d("Unable to initialize db", e.toString());
        }

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterWifiScanReceiver(this);
        if (blockAppTimerCreated) {
            blockAppTimer.cancel();
        }
        if (belowAPI31WifiTimerCreated) {
            belowAPI31WifiTimer.cancel();
        }
        stopWifiTaskTimer();

    }

    public static void setConnectedWifi(String currentConnectedWifi) {
        connectedWifi = currentConnectedWifi;

        toCheck.put("currentWifi", connectedWifi);
    }

    public static void setSchedulesAfterReQuery(List<Map<String, Object>> newSchedules) {
        schedules = newSchedules;

    }

    public static void setToCheck(Map<String, Object> newToCheck) {
        toCheck = newToCheck;
    }

    public static void setLatLng(double lat, double lng) {
        currentLat = lat;
        currentLng = lng;
    }

}


