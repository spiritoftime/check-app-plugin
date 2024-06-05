package com.doomscroll.checkapp_plugin;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Location;
import android.location.LocationManager;
import android.os.IBinder;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;
import com.google.android.gms.location.LocationRequest;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class AppService extends Service {
    final static String REDIRECT_HOME = "REDIRECT_HOME";
    final static String NOTIFICATION_CHANNEL = "NOTIFICATION_CHANNEL";
    final static String REQUEST_LOCATION = "REQUEST_LOCATION";
    final static String STOP_REQUEST_LOCATION = "STOP_REQUEST_LOCATION";

    final static String START = "START";
    final static String STOP = "STOP";
    static final String GET_LAUNCHABLE_APPLICATIONS = "GET_LAUNCHABLE_APPLICATIONS";
    private static FusedLocationProviderClient fusedLocationClient;
    private LocationRequest locationRequest;
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
                startLocationUpdates();
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
        Notification notification = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL).build();
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

    @SuppressLint({"MissingPermission", "NewApi"})
    private void startLocationUpdates() {
        locationRequest = new LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
                .setMinUpdateIntervalMillis(5000)
                .build();
        // need to request for gps to be enabled
        locationCallback = new LocationCallback() {
            LocationManager manager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
            boolean isGPSEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);



            @Override
            public void onLocationResult(LocationResult locationResult) {
                Log.d("hi", String.valueOf(locationResult));
                if (locationResult == null) {
                    return;
                }
                Location lastLocation = locationResult.getLastLocation();
                if (lastLocation != null) {
                    double lat = lastLocation.getLatitude();
                    double lng = lastLocation.getLongitude();
                    Log.d("coords", "lat: " + lat + " lng: " + lng);
                }
            }
        };

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper());
    }

    private void showEnableGpsDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(AppService.this);
        builder.setMessage("GPS is disabled. Please enable GPS to continue.")
                .setCancelable(false)
                .setPositiveButton("Enable GPS", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        AppService.this.startActivity(intent);
                    }
                })
                .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }

}


