package com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor;

import static com.doomscroll.checkapp_plugin.Utils.safeCast;
import static com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor.PartialAppInterceptor.getSupportedPartialBlockings;

import android.os.Build;

import androidx.annotation.RequiresApi;

import com.doomscroll.checkapp_plugin.CommonBlockerChecks;
import com.google.gson.reflect.TypeToken;

import java.util.List;
import java.util.Map;
import java.util.Objects;

public class PartialAppBlocker extends CommonBlockerChecks {
    private boolean blockedPartialApplicationInUsage = false;


    public PartialAppBlocker(Map<String, Object> toCheck) {
        super(toCheck);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public boolean shouldBlockPartialApplication(String nodeId, String packageName) {
        checkPartialApplicationUsage(nodeId, packageName);
        checkCommonBlockers();
        return shouldBlock();
    }

    boolean shouldBlock() {
        return blockedPartialApplicationInUsage && commonBlockers;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private void checkPartialApplicationUsage(String nodeId, String packageName) {
        TypeToken<Boolean> booleanTypeToken = new TypeToken<Boolean>() {
        };
        boolean shouldCheckPartiallyBlockedApplication = safeCast(toCheck.get("checkPartialBlockers"), booleanTypeToken);
        if (!shouldCheckPartiallyBlockedApplication) return;
        TypeToken<List<Map<String, Object>>> typeToken = new TypeToken<List<Map<String, Object>>>() {
        };
        List<Map<String, Object>> partiallyBlockedApps = safeCast(toCheck.get("partialBlockers"), typeToken);
        for (Map<String, Object> pb : partiallyBlockedApps) {

            String pbPackageName = (String) pb.get("packageName");
            if(!Objects.equals(pbPackageName, packageName)) continue;
            String feature = (String) pb.get("feature");

            List<PartialBlockingConfig> partialBlockingConfigs = getSupportedPartialBlockings().get(pbPackageName);
            if (partialBlockingConfigs == null) return;
            for (PartialBlockingConfig config : partialBlockingConfigs) {
                if (Objects.equals(config.feature, feature)) {
                    for (String id : config.ids) {
                        if (Objects.equals(id, nodeId)) {
                            blockedPartialApplicationInUsage = true;
                            break;
                        }
                    }
                }

            }
        }
    }
}
