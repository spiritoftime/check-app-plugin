package com.doomscroll.checkapp_plugin.accessibilityService.partialInterceptor;

import java.util.List;

public class PartialBlockingConfig {
    public String packageName;
    public List<String> ids;

    public PartialBlockingConfig(String packageName, List<String> ids) {
        this.ids = ids;
        this.packageName = packageName;
    }

}