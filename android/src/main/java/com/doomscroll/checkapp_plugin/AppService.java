package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getShouldCheckKeywords;
import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.getShouldCheckWebsites;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getRequestConnectedWifi;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getRequestCurrentLocation;
import static com.doomscroll.checkapp_plugin.CheckappPlugin.getCheckAppContext;
import static com.doomscroll.checkapp_plugin.LocationChecker.getFusedLocationClient;
import static com.doomscroll.checkapp_plugin.LocationChecker.startLocationUpdates;
import static com.doomscroll.checkapp_plugin.LocationChecker.stopLocationUpdates;
//import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
//import static com.doomscroll.checkapp_plugin.WifiScan.getCurrentWifiBelowApi31;
import static com.doomscroll.checkapp_plugin.Utils.goToHomeScreen;
import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
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


import com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor;
import com.doomscroll.checkapp_plugin.appBlocker.BlockTask;
import com.doomscroll.realTimeDb.RealTimeFirebaseDb;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;

public class AppService extends Service {
    final public static String REDIRECT_HOME = "REDIRECT_HOME";
    final static String NOTIFICATION_CHANNEL = "NOTIFICATION_CHANNEL";

    static List<Map<String, Object>> schedules;
    final static String REQUEST_LOCATION = "REQUEST_LOCATION";
    final static String STOP_REQUEST_LOCATION = "STOP_REQUEST_LOCATION";

    final static String START = "START";
    final static String STOP = "STOP";

    static Timer belowAPI31WifiTimer;
    static boolean belowAPI31WifiTimerCreated;

    static Timer blockAppTimer;
    static boolean blockAppTimerCreated;
    static boolean isServiceInitialized = false;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        switch (Objects.requireNonNull(intent.getAction())) {
            case REDIRECT_HOME:
                goToHomeScreen(this);
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
    }

    public static void initializeService(Context context) {
        String userId = "user";
        //                    ----------------------start foreground service --------------------
        // need to cancel previous taskTimers when user edited the blocker to give grace period. eg: current time - 7pm. user set schedule to block from 7pm, blocked. user immediately changed schedule to 715pm, will continue to block because previous blockTimer with 7pm timing not cleared and continue blocking.
        if (isServiceInitialized) {
            clearAllTimers();
        }
        isServiceInitialized = true;
        Intent serviceIntent = new Intent(context, AppService.class);
        serviceIntent.setAction(START);
        getFusedLocationClient(context);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL, "Running Notification", NotificationManager.IMPORTANCE_NONE);
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);


            context.startForegroundService(serviceIntent);


        } else {
            context.startService(serviceIntent);

        }
        try (DatabaseHelper dbHelper = new DatabaseHelper(context)) {
            userId = dbHelper.getUserId();
            if (!Objects.equals(userId, "user")) {
                schedules = dbHelper.getSchedules(userId);
                if (!schedules.isEmpty()) {
//                    ----------------------start creating task to block app--------------------
                    ScheduleParser scheduleParser = new ScheduleParser(schedules);
                    List<Map<String, Object>> parsedSchedules = scheduleParser.getSchedules();

                    blockAppTimer = new Timer();
                    BlockTask blockTask = new BlockTask(parsedSchedules, context);
                    blockAppTimer.schedule(blockTask, 0, 2000);
                    blockAppTimerCreated = true;
                    //                    ----------------------start location update --------------------
                    if (getRequestCurrentLocation()) {
                        createIntentForService(context, REQUEST_LOCATION); // autostart location if active schedule demands for it
                    } else {
                        createIntentForService(context, STOP_REQUEST_LOCATION);
                    }
//                    website blocker
                    if(getShouldCheckWebsites() ||getShouldCheckKeywords() ){
                        RealTimeFirebaseDb.querySupportedBrowserConfigs();

                        BrowserInterceptor.getInstance(parsedSchedules);
                    }
                    //                    ----------------------start wifi update --------------------
//         autostart wifi if active schedule demands for it
//        should stop location & wifi when no active schedule needs it
                    if (getRequestConnectedWifi()) {
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
                            belowAPI31WifiTimerCreated = false;

                        }
                    }


                } else {

                    createIntentForService(context, STOP);
                }


            }


        } catch (Exception e) {
            // Handle any exceptions that may occur
            Log.d("Unable to initialize db", e.toString());
        }

    }

    @Override
    public void onDestroy() { // used when user deactivates all active scheules
        super.onDestroy();
        unregisterWifiScanReceiver(getCheckAppContext());
        clearAllTimers();
        isServiceInitialized = false;

    }

    private static void clearAllTimers() {
        if (blockAppTimerCreated) {
            blockAppTimer.cancel();
            blockAppTimerCreated = false;
        }
        if (belowAPI31WifiTimerCreated) {
            belowAPI31WifiTimer.cancel();
            belowAPI31WifiTimerCreated = false;
        }
        stopWifiTaskTimer();
    }


}


