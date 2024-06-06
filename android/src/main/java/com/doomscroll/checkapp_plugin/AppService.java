package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.LocationChecker.startLocationUpdates;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;

import android.app.Service;
import android.content.Context;

import android.content.Intent;
import android.content.pm.PackageManager;


import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;


import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;

import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;
import com.google.android.gms.location.LocationRequest;


import java.util.Objects;

public class AppService extends Service {
    final static String REDIRECT_HOME = "REDIRECT_HOME";
    final static String NOTIFICATION_CHANNEL = "NOTIFICATION_CHANNEL";


    final static String REQUEST_LOCATION = "REQUEST_LOCATION";
    final static String STOP_REQUEST_LOCATION = "STOP_REQUEST_LOCATION";

    final static String START = "START";
    final static String STOP = "STOP";
    private static FusedLocationProviderClient fusedLocationClient;
    private final LocationRequest locationRequest = new LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
            .setMinUpdateIntervalMillis(5000)
            .build();
    ;
    private LocationCallback locationCallback;

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
                fusedLocationClient.removeLocationUpdates(locationCallback);
                break;
            case REQUEST_LOCATION:
                try {
                    startLocationUpdates(this,NOTIFICATION_CHANNEL,fusedLocationClient,locationRequest);
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
    //        code for starting service

    public static void initializeServiceAtFlutter(Context context) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL, "Running Notification", NotificationManager.IMPORTANCE_NONE);
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);

            Intent serviceIntent = new Intent(context, AppService.class);
            serviceIntent.setAction(START);
            context.startService(serviceIntent);
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);

        }
    }


}


