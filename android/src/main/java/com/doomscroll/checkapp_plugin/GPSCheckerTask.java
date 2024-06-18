package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.LocationChecker.sendLocationAccessNotification;

import android.content.Context;
import android.location.LocationManager;


import androidx.core.util.Consumer;

import java.util.Timer;
import java.util.TimerTask;
import java.util.function.Function;

public class GPSCheckerTask extends TimerTask {
    private final Context context;

    private final String NOTIFICATION_CHANNEL;
    private final String blockType;
    private final Timer timer;
    //optional param
    private final Consumer<Void> callback;


    private GPSCheckerTask(GPSCheckerTaskBuilder builder) {
        this.context = builder.context;
        this.NOTIFICATION_CHANNEL = builder.NOTIFICATION_CHANNEL;
        this.blockType = builder.blockType;
        this.timer = builder.timer;
        this.callback = builder.callback;
    }

    public static class GPSCheckerTaskBuilder {
        //        required params
        private final Context context;

        private final String NOTIFICATION_CHANNEL;
        private final String blockType;
        private final Timer timer;
        private Consumer<Void> callback;

        public GPSCheckerTaskBuilder(Context context, String notificationChannel, String blockType, Timer timer) {
            this.context = context;
            NOTIFICATION_CHANNEL = notificationChannel;
            this.blockType = blockType;
            this.timer = timer;
        }

        public GPSCheckerTaskBuilder setCallback(Consumer<Void> callback) {
            this.callback = callback;
            return this;
        }

        public GPSCheckerTask build() {
            return new GPSCheckerTask(this);
        }
    }

    @Override
    public void run() {
        LocationManager manager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        final boolean isGPSEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        if (!isGPSEnabled) {
            sendLocationAccessNotification(context, NOTIFICATION_CHANNEL, blockType);
        }
        if (isGPSEnabled && callback != null) {
            callback.accept(null);
            timer.cancel();

        }

    }


}
