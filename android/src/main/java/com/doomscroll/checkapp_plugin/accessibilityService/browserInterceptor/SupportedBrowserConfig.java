package com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor;

public  class SupportedBrowserConfig {
    public String packageName, addressBarId;

    public SupportedBrowserConfig(String packageName, String addressBarId) {
        this.packageName = packageName;
        this.addressBarId = addressBarId;
    }
}
