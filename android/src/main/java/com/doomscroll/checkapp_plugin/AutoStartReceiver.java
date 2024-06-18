package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.initializeService;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class AutoStartReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            Log.d("BootCompletedReceiver", "Device boot completed");
            initializeService(context);
        }

    }
}
