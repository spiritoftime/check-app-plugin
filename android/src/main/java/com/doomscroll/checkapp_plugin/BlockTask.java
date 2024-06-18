package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppBlocker.shouldBlockApp;
import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;
import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;

import android.content.Context;

import java.util.Map;
import java.util.TimerTask;

public class BlockTask extends TimerTask {
    private final Map<String, Object> toCheck;
    private final Context context;

    public BlockTask(Map<String, Object> toCheck, Context context) {

        this.toCheck = toCheck;
        this.context = context;
    }

    @Override
    public void run() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
            boolean shouldBlockApp = shouldBlockApp(toCheck);
            if(shouldBlockApp){
                createIntentForService(context, REDIRECT_HOME);
            }
        }
    }
}
