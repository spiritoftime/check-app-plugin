package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;

import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;
import static com.doomscroll.checkapp_plugin.AppService.initializeService;

import static com.doomscroll.checkapp_plugin.Permissions.checkAccessibilityPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkGPSEnabled;
import static com.doomscroll.checkapp_plugin.Permissions.checkIsBatteryOptimizationDisabled;
import static com.doomscroll.checkapp_plugin.Permissions.checkLocationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkUsagePermission;

import static com.doomscroll.checkapp_plugin.Permissions.isBackgroundStartActivityPermissionGranted;
import static com.doomscroll.checkapp_plugin.Permissions.requestAccessibilityPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestBackgroundPermissionForXiaomi;
import static com.doomscroll.checkapp_plugin.Permissions.requestDisableBatteryOptimization;
import static com.doomscroll.checkapp_plugin.Permissions.requestEnableGPS;
import static com.doomscroll.checkapp_plugin.Permissions.requestLocationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestUsagePermission;

import static com.doomscroll.checkapp_plugin.WifiScan.getNearbyWifi;
import static com.doomscroll.checkapp_plugin.appBlocker.AppBlocker.isAppInForeground;

import android.annotation.SuppressLint;
import android.app.Activity;

import android.app.usage.UsageEvents;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;

import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;


import java.util.ArrayList;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class CheckappPlugin extends FlutterActivity implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final String FLUTTER_CHANNEL_NAME = "com.doomscroll.checkapp";
    private static final String CHANNEL_DETECT_METHOD = "DETECT_APP";
    private static final String REQUEST_OVERLAY_PERMISSION = "REQUEST_OVERLAY_PERMISSION";
    private static final String REQUEST_NOTIFICATION_PERMISSION = "REQUEST_NOTIFICATION_PERMISSION";

    private static final String REQUEST_USAGE_PERMISSION = "REQUEST_USAGE_PERMISSION";
    private static final String REQUEST_BACKGROUND_PERMISSION = "REQUEST_BACKGROUND_PERMISSION";
    private static final String REQUEST_LOCATION_PERMISSION = "REQUEST_LOCATION_PERMISSION";
    private static final String CHECK_LOCATION_PERMISSION = "CHECK_LOCATION_PERMISSION";
    private static final String CHECK_BACKGROUND_PERMISSION = "CHECK_BACKGROUND_PERMISSION";
    private static final String CHECK_NOTIFICATION_PERMISSION = "CHECK_NOTIFICATION_PERMISSION";
    private static final String CHECK_USAGE_PERMISSION = "CHECK_USAGE_PERMISSION";
    private static final String CHECK_OVERLAY_PERMISSION = "CHECK_OVERLAY_PERMISSION";

    private static final String CHECK_ACCESSIBILITY_PERMISSION = "CHECK_ACCESSIBILITY_PERMISSION";
    private static final String REQUEST_ACCESSIBILITY_PERMISSION = "REQUEST_ACCESSIBILITY_PERMISSION";
    private static final String CHECK_BATTERY_OPTIMIZATION_PERMISSION = "CHECK_BATTERY_OPTIMIZATION_PERMISSION";
    private static final String REQUEST_BATTERY_OPTIMIZATION_PERMISSION = "REQUEST_BATTERY_OPTIMIZATION_PERMISSION";

    private static final String GET_NEARBY_WIFI = "GET_NEARBY_WIFI";
    private static final String CHECK_GPS_ENABLED = "CHECK_GPS_ENABLED";
    private static final String REQUEST_ENABLE_GPS = "REQUEST_ENABLE_GPS";
    private static final String REQUERY_ACTIVE_SCHEDULES = "REQUERY_ACTIVE_SCHEDULES";


    private static final String GET_LAUNCHABLE_APPLICATIONS = "GET_LAUNCHABLE_APPLICATIONS";
    private MethodChannel channel;
    @SuppressLint("StaticFieldLeak")
    // can suppress as this is application context - https://stackoverflow.com/questions/37709918/warning-do-not-place-android-context-classes-in-static-fields-this-is-a-memory
    private static Context context;


    public static Context getCheckAppContext() {
        return context;
    }

    public void setContext(Context context) {
        CheckappPlugin.context = context;
    }

    @Nullable
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        setContext(flutterPluginBinding.getApplicationContext());

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FLUTTER_CHANNEL_NAME);
        channel.setMethodCallHandler(this);
        initializeService(context);

    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case CHECK_BATTERY_OPTIMIZATION_PERMISSION:
                result.success(checkIsBatteryOptimizationDisabled(context));
                break;
            case REQUEST_BATTERY_OPTIMIZATION_PERMISSION:
                requestDisableBatteryOptimization(context, activity);
                break;
            case GET_LAUNCHABLE_APPLICATIONS:
                List<Map<String, Object>> appList = getInstalledApplications();
                result.success(appList);
                break;
            case CHECK_ACCESSIBILITY_PERMISSION:
                result.success(checkAccessibilityPermission(context));
                break;
            case REQUEST_ACCESSIBILITY_PERMISSION:
                requestAccessibilityPermission(context, activity);
                break;
            case CHANNEL_DETECT_METHOD:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission(context, activity);
                }
                requestUsagePermission(context, activity);
                requestBackgroundPermissionForXiaomi(context, activity);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    boolean shouldShowPopUp = isAppInForeground("com.facebook.katana", context);
                    if (shouldShowPopUp) {
                        createIntentForService(context, REDIRECT_HOME);
                    }
                    result.success(shouldShowPopUp);
                }
                break;
            case CHECK_OVERLAY_PERMISSION:
                result.success(checkOverlayPermission(context));
                break;
            case REQUEST_OVERLAY_PERMISSION:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission(context, activity);
                }
                break;
            case CHECK_USAGE_PERMISSION:
                result.success(checkUsagePermission(context)); //NOTE: returns int. 0 = mode_allowed
                break;
            case REQUEST_USAGE_PERMISSION:
                requestUsagePermission(context, activity);
                break;

            case CHECK_NOTIFICATION_PERMISSION:
                result.success(checkNotificationPermission(context));
                break;
            case REQUEST_NOTIFICATION_PERMISSION:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    requestNotificationPermission(context, activity);
                }
                break;
            case CHECK_BACKGROUND_PERMISSION:
                result.success(isBackgroundStartActivityPermissionGranted(context));
                break;
            case REQUEST_BACKGROUND_PERMISSION:
                requestBackgroundPermissionForXiaomi(context, activity);
                break;
            case CHECK_LOCATION_PERMISSION:
                boolean isPermissionEnabled = checkLocationPermission(context, activity);
                result.success(isPermissionEnabled);
                break;
            case REQUEST_LOCATION_PERMISSION:
                requestLocationPermission(context, activity);
                break;
            case GET_NEARBY_WIFI:
                getNearbyWifi(result, context);
                break;
            case CHECK_GPS_ENABLED:
                result.success(checkGPSEnabled(context));
                break;
            case REQUEST_ENABLE_GPS:
                requestEnableGPS(context, activity);
                break;
            case REQUERY_ACTIVE_SCHEDULES:
                initializeService(context);

                break;
            default:
                result.notImplemented();
                break;
        }
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private List<Map<String, Object>> getInstalledApplications() {
        // searching main activities labeled to be launchers of the apps
        PackageManager pm = context.getPackageManager();
        Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);
        mainIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        List<ResolveInfo> resolveInfoList = pm.queryIntentActivities(mainIntent, PackageManager.GET_META_DATA);
        List<Map<String, Object>> appList = new ArrayList<>();

        for (ResolveInfo resolveInfo : resolveInfoList) {
            String packageName = resolveInfo.activityInfo.packageName;
            Drawable icon = resolveInfo.loadIcon(pm);
            Bitmap iconBitMap = Utils.drawableToBitmap(icon);
            String iconBase64String = Utils.bitmapToBase64(iconBitMap);
            String appName = "";
            if (resolveInfo.activityInfo.labelRes != 0) {
                try {
                    Resources resources = pm.getResourcesForApplication(resolveInfo.activityInfo.applicationInfo);
                    appName = resources.getString(resolveInfo.activityInfo.labelRes);

                } catch (PackageManager.NameNotFoundException e) {
                    Log.d("getInstalledApplication", e.toString());
                }
            } else {
                appName = resolveInfo.activityInfo.applicationInfo.loadLabel(pm).toString();

            }
            appList.add(new AppInfo(packageName, iconBase64String, appName).toMap());
        }

        return appList;
    }

    private class AppInfo {
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

}
