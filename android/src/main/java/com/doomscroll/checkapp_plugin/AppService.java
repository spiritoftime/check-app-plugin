package com.doomscroll.checkapp_plugin;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.util.Objects;

public class AppService extends Service {
    final static String REDIRECT_HOME = "REDIRECT_HOME";
    final static String NOTIFICATION_CHANNEL = "NOTIFICATION_CHANNEL";

    final static String START = "START";
    final static String STOP = "STOP";


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
            case STOP:
                stopSelf();
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
        }
    }
}


