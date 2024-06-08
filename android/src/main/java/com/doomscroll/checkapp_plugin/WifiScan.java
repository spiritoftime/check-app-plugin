package com.doomscroll.checkapp_plugin;


import android.content.Context;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.util.Log;

import java.util.List;

public class WifiScan {
    public static List<ScanResult> queryWifi(Context context) {
        WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        wifiManager.startScan();
        List<ScanResult> results = wifiManager.getScanResults();

        for (ScanResult result : results) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Log.d("WiFi", "SSID: " + result.SSID + ", RSSI: " + result.level + result.operatorFriendlyName);
            }
        }
        return results;
    }
}