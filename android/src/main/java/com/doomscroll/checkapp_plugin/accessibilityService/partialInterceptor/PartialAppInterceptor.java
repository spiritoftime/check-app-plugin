package com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor;

import static com.doomscroll.checkapp_plugin.Utils.goToHomeScreen;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class PartialAppInterceptor {
    public static List<PartialBlockingConfig> getSupportedPartialBlockings() {
        List<PartialBlockingConfig> partialBlockingConfigList = new ArrayList<>();
        List<String> idsToBlock = new ArrayList<>();
        idsToBlock.add("youtube:id/reel_player_page_container");
        idsToBlock.add("com.google.android.youtube:id/watch_player");
        idsToBlock.add("com.google.android.youtube:id/reel_recycler");


        partialBlockingConfigList.add(new PartialBlockingConfig("com.google.android.youtube", idsToBlock));
        return partialBlockingConfigList;
    }



    public static void checkPartiallyBlocked( String nodeId,@NonNull String packageName, Context context){
        if (nodeId != null) {
            for (PartialBlockingConfig partialBlockingConfig : getSupportedPartialBlockings()) {
                if (partialBlockingConfig.packageName.equals(packageName)) {
                    for (String blockedId : partialBlockingConfig.ids) {
                        if (Objects.equals(nodeId, blockedId)) {
                            goToHomeScreen(context);
                            break;

                        }
                    }
                }
            }
        }
    }
}
