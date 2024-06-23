package com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor;

import java.util.List;

public class PartialBlockingConfig {
    public String packageName;
    public String feature;
    public List<String> ids;

    public PartialBlockingConfig(String packageName, List<String> ids,String feature) {
        this.ids = ids;
        this.feature = feature;
        this.packageName = packageName;
    }

}