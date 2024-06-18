package com.doomscroll.checkapp_plugin;


import static com.doomscroll.checkapp_plugin.AppService.NOTIFICATION_CHANNEL;
import static com.doomscroll.checkapp_plugin.AppService.setLatLng;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;

import java.util.Timer;


public class LocationChecker {
    private static boolean requestingLocationUpdates;
    private static FusedLocationProviderClient fusedLocationClient;
    private static final LocationRequest locationRequest = new LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
            .setMinUpdateIntervalMillis(5000)
            .build();
    ;
    private static LocationCallback locationCallback;

    public static void getFusedLocationClient(Context context) {
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);
    }

    public static void sendLocationAccessNotification(Context context, String NOTIFICATION_CHANNEL, String blockType) {
        int requestID = (int) System.currentTimeMillis();
        Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);

        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(context, requestID, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, NOTIFICATION_CHANNEL).setSmallIcon(android.R.drawable.ic_menu_mylocation)
                .setContentTitle("Enable Location Access")
                .setContentIntent(pendingIntent)
                .setContentText("Doomscroll needs location access, since you enabled a " + blockType + " appblocking schedule. Please enable it in settings.")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true);

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(1001, builder.build());
    }

    public static void startLocationUpdates(Context context, String NOTIFICATION_CHANNEL) throws PackageManager.NameNotFoundException {

        Timer timer = new Timer();
        GPSCheckerTask gpsCheckerTask = new GPSCheckerTask.GPSCheckerTaskBuilder(context, NOTIFICATION_CHANNEL, "wifi", timer).build();
        timer.schedule(gpsCheckerTask, 0, 5000);

        if (locationCallback == null) {
            locationCallback = new LocationCallback() {


                @Override
                public void onLocationResult(LocationResult locationResult) {
//                Log.d("hi", String.valueOf(locationResult));
                    if (locationResult == null) {
                        return;
                    }
                    Location lastLocation = locationResult.getLastLocation();
                    if (lastLocation != null) {
                        double lat = lastLocation.getLatitude();
                        double lng = lastLocation.getLongitude();
                        setLatLng(lat,lng);
                        Log.d("llog location", String.valueOf(lat));
                    }
                }
            };

            fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper());
        }

    }

    //when there is no active schedule with location, should stop it
    public static void stopLocationUpdates() {
        if(requestingLocationUpdates){
            fusedLocationClient.removeLocationUpdates(locationCallback);

        }
    }
}
