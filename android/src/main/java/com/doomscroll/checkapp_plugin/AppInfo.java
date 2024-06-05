package com.doomscroll.checkapp_plugin;

import java.util.HashMap;
import java.util.Map;

public  class AppInfo {
    String packageName;
    String iconBase64String;
    String appName;

    AppInfo(String packageName, String iconBase64String, String appName) {
        this.packageName = packageName;
        this.iconBase64String = iconBase64String;
        this.appName = appName;
    }

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("packageName", packageName);
        map.put("iconBase64String", iconBase64String);
        map.put("appName", appName);
        return map;
    }
}