package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.WifiScan.getCurrentWifiBelowApi31;

import android.content.Context;

import java.util.TimerTask;

public class BelowApi31WifiCheckerTask extends TimerTask {
    private final Context context;

    BelowApi31WifiCheckerTask(Context context) {
        this.context = context;
    }

    @Override
    public void run() {
        getCurrentWifiBelowApi31(context);

    }
}
