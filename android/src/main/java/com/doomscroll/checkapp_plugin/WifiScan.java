package com.doomscroll.checkapp_plugin;


import static com.doomscroll.checkapp_plugin.AppService.NOTIFICATION_CHANNEL;
import static com.doomscroll.checkapp_plugin.BlockTask.setConnectedWifi;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.wifi.ScanResult;
import android.net.wifi.SupplicantState;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;

import io.flutter.plugin.common.MethodChannel;

public class WifiScan {
    static Timer timer;
    static boolean timerCreated;
    static List<ScanResult> scanResults = new ArrayList<>();
    private static BroadcastReceiver mWifiScanReceiver;

    //gets nearby wifi
    public static void initializeWifiScan(Context context) {
        Thread t1 = new Thread(() -> {

            WifiManager mWifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            mWifiScanReceiver = new BroadcastReceiver() {
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
        });
        t1.start();
    }

    public static void getNearbyWifi(MethodChannel.Result result, Context context) {
        initializeWifiScan(context);
        if (scanResults.isEmpty())
//            to fix next time - initially empty since onReceive not triggered initially
            result.error("POSSIBLE MISSING PERMISSIONS", "Location Services may not be turned on. If you just turned it on, give it a second.", null);
        else {
            result.success(scanResultToMap());
        }
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


    public static void getConnectedWiFiSSID(Context context) {
        timer = new Timer();
        GPSCheckerTask gpsCheckerTask = new GPSCheckerTask.GPSCheckerTaskBuilder(context, NOTIFICATION_CHANNEL, "wifi", timer).setCallback((Void) -> {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                registerConnectivityManager(context);
            }

        }).build();
        timer.schedule(gpsCheckerTask, 0, 5000);
        timerCreated = true;

    }

    public static void stopWifiTaskTimer() {
        if (timerCreated) {
            timer.cancel();
            timerCreated = false;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    public static void registerConnectivityManager(Context context) {

        final NetworkRequest request =
                new NetworkRequest.Builder()
                        .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                        .build();
        final ConnectivityManager connectivityManager =
                context.getSystemService(ConnectivityManager.class);
        ConnectivityManager.NetworkCallback networkCallback;

        networkCallback = new ConnectivityManager.NetworkCallback(ConnectivityManager.NetworkCallback.FLAG_INCLUDE_LOCATION_INFO) {

            @Override
            public void onAvailable(Network network) {
                // Handle network available
            }

            @Override
            public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
                WifiInfo wifiInfo = (WifiInfo) networkCapabilities.getTransportInfo();

                assert wifiInfo != null;
                String currentWifi = wifiInfo.getSSID();
                handleNetworkCapabilitiesChanged(currentWifi);
//                Log.d("Log wifi above api 31", currentWifi);
            }
        };
        connectivityManager.registerNetworkCallback(request, networkCallback);


    }

    //need to call in task scheduler
    public static void getCurrentWifiBelowApi31(Context context) {
        WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        WifiInfo wifiInfo;

        wifiInfo = wifiManager.getConnectionInfo();
        if (wifiInfo.getSupplicantState() == SupplicantState.COMPLETED) {
            String ssid = wifiInfo.getSSID();
            Log.d("check wifi", ssid);
            handleNetworkCapabilitiesChanged(ssid);
        }
    }

    private static void handleNetworkCapabilitiesChanged(String currentWifi) {

        String connectedWifi = currentWifi.replaceAll("^\"|\"$", "");

        setConnectedWifi(connectedWifi);
    }


    public static void unregisterWifiScanReceiver(Context context) {
        if (mWifiScanReceiver != null) {
            context.unregisterReceiver(mWifiScanReceiver);
            mWifiScanReceiver = null;
        }
    }
}

