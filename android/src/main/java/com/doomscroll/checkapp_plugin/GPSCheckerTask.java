package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.LocationChecker.sendLocationAccessNotification;

import android.content.Context;
import android.location.LocationManager;


import androidx.core.util.Consumer;

import java.util.Timer;
import java.util.TimerTask;

public class GPSCheckerTask extends TimerTask {
    private final Context context;

    private final String NOTIFICATION_CHANNEL;
    private final String blockType;
    private final Timer timer;

    public GPSCheckerTask(Context context,  String NOTIFICATION_CHANNEL, String blockType,Timer timer) {
        this.context = context;
        this.timer = timer;
        this.NOTIFICATION_CHANNEL = NOTIFICATION_CHANNEL;
        this.blockType = blockType;

    }

    @Override
    public void run() {
        LocationManager manager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        final boolean isGPSEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        if (!isGPSEnabled) {
            sendLocationAccessNotification(context, NOTIFICATION_CHANNEL, blockType);
        }
        if(isGPSEnabled) timer.cancel();


    }
}
