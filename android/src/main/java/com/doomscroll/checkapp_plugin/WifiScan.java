package com.doomscroll.checkapp_plugin;


import static androidx.core.content.ContextCompat.registerReceiver;

import static com.doomscroll.checkapp_plugin.AppService.NOTIFICATION_CHANNEL;
import static com.doomscroll.checkapp_plugin.AppService.setConnectedWifi;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.MethodChannel;

public class WifiScan {
    private static boolean isGPSEnabled;
    public static String connectedWifi;
    static List<ScanResult> scanResults;

    public static void initializeWifiScan(Context context) {
        WifiManager mWifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        final BroadcastReceiver mWifiScanReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context c, Intent intent) {
                if (Objects.equals(intent.getAction(), WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)) {
                    scanResults = mWifiManager.getScanResults();

                }
            }
        };
        context.registerReceiver(mWifiScanReceiver,
                new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
        mWifiManager.startScan();
    }

    public static void getNearbyWifi(MethodChannel.Result result) {
        if (scanResults.isEmpty())
            result.error("MISSING PERMISSIONS", "Location Services not turned on", null);
        result.success(scanResultToMap());
    }

    private static List<Map<String, Object>> scanResultToMap() {
        List<Map<String, Object>> wifiList = new ArrayList<>();
        for (ScanResult scanResult : scanResults) {
            Map<String, Object> resultMap = new HashMap<>();
            if (!scanResult.SSID.isEmpty()) {
                resultMap.put("wifiName", scanResult.SSID);
                wifiList.add(resultMap);
            }

        }
        return wifiList;
    }

    public static class GetCurrentWifiTask extends TimerTask {
        @Override
        public void run() {
        }

    }

    public static void getConnectedWiFiSSID(Context context) {
        Timer timer = new Timer();
        GPSCheckerTask gpsCheckerTask = new GPSCheckerTask.GPSCheckerTaskBuilder(context, NOTIFICATION_CHANNEL, "wifi", timer).setCallback((Void) -> {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                registerConnectivityManager(context);
            }
        }).build();
        timer.schedule(gpsCheckerTask, 0, 5000);


    }

    @RequiresApi(api = Build.VERSION_CODES.S)

    public static void registerConnectivityManager(Context context) {

        final NetworkRequest request =
                new NetworkRequest.Builder()
                        .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                        .build();
        final ConnectivityManager connectivityManager =
                context.getSystemService(ConnectivityManager.class);
        final ConnectivityManager.NetworkCallback networkCallback = new ConnectivityManager.NetworkCallback(ConnectivityManager.NetworkCallback.FLAG_INCLUDE_LOCATION_INFO
        ) {

            @Override
            public void onAvailable(Network network) {
            }

            @Override
            public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
                WifiInfo wifiInfo = null;

                wifiInfo = (WifiInfo) networkCapabilities.getTransportInfo();

                assert wifiInfo != null;
                String connectedWifi = wifiInfo.getSSID().replaceAll("^\"|\"$", "");

                setConnectedWifi(connectedWifi);
            }
        };
        connectivityManager.registerNetworkCallback(request, networkCallback);
    }
}

