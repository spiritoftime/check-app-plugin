package com.doomscroll.checkapp_plugin.appBlocker;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentConnectedWifi;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentLat;
import static com.doomscroll.checkapp_plugin.appBlocker.BlockTask.getCurrentLng;
import static com.doomscroll.checkapp_plugin.CheckappPlugin.isAppInForeground;
import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static com.doomscroll.checkapp_plugin.Utils.isCurrentTimeWithinRange;
import static com.doomscroll.checkapp_plugin.Utils.roundToDecimalPlaces;
import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import com.doomscroll.checkapp_plugin.CommonBlockerChecks;
import com.google.gson.reflect.TypeToken;

public class AppBlocker extends CommonBlockerChecks {
    private boolean blockedAppInUsage = false;

    public AppBlocker(Map<String, Object> toCheck) {
        super(toCheck);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public boolean shouldBlockApp(Context context) {
        checkAppUsage(context);
        checkCommonBlockers();
        return shouldBlock();
    }


    boolean shouldBlock() {
        return blockedAppInUsage && commonBlockers;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private void checkAppUsage(Context context) {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckApp = safeCast(toCheck.get("checkApp"), booleanTypeToken);
        if (shouldCheckApp) {
            TypeToken<List<Map<String, Object>>> typeToken = new TypeToken<List<Map<String, Object>>>() {
            };
            List<Map<String, Object>> apps = safeCast(toCheck.get("apps"), typeToken);
            for (Map<String, Object> app : apps) {
                String packageName = (String) app.get("packageName");
                blockedAppInUsage = isAppInForeground(packageName, context);
                if (blockedAppInUsage) {
                    break;
                }
            }
        }

    }
}
