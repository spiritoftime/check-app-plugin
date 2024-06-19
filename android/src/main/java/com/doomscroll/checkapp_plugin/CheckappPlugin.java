package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;

import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;
import static com.doomscroll.checkapp_plugin.AppService.initializeService;
import static com.doomscroll.checkapp_plugin.AppService.setSchedulesAfterReQuery;

import static com.doomscroll.checkapp_plugin.Permissions.checkGPSEnabled;
import static com.doomscroll.checkapp_plugin.Permissions.checkLocationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.checkUsagePermission;

import static com.doomscroll.checkapp_plugin.Permissions.isBackgroundStartActivityPermissionGranted;
import static com.doomscroll.checkapp_plugin.Permissions.requestBackgroundPermissionForXiaomi;
import static com.doomscroll.checkapp_plugin.Permissions.requestEnableGPS;
import static com.doomscroll.checkapp_plugin.Permissions.requestLocationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestUsagePermission;
import static com.doomscroll.checkapp_plugin.ScheduleParser.compileToCheck;
import static com.doomscroll.checkapp_plugin.WifiScan.getConnectedWiFiSSID;
import static com.doomscroll.checkapp_plugin.WifiScan.getNearbyWifi;

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


    private static final String GET_NEARBY_WIFI = "GET_NEARBY_WIFI";
    private static final String CHECK_GPS_ENABLED = "CHECK_GPS_ENABLED";
    private static final String REQUEST_ENABLE_GPS = "REQUEST_ENABLE_GPS";
    private static final String REQUERY_ACTIVE_SCHEDULES = "REQUERY_ACTIVE_SCHEDULES";


    private static final String GET_LAUNCHABLE_APPLICATIONS = "GET_LAUNCHABLE_APPLICATIONS";
    private MethodChannel channel;
    @SuppressLint("StaticFieldLeak")
    // can suppress as this is application context - https://stackoverflow.com/questions/37709918/warning-do-not-place-android-context-classes-in-static-fields-this-is-a-memory
    private static Context context;
    @Nullable
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FLUTTER_CHANNEL_NAME);
        channel.setMethodCallHandler(this);
        initializeService(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case GET_LAUNCHABLE_APPLICATIONS:
                List<Map<String, Object>> appList = getInstalledApplications();
                result.success(appList);
                break;
            case CHANNEL_DETECT_METHOD:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission(context, activity);
                }
                requestUsagePermission(context, activity);
                requestBackgroundPermissionForXiaomi(context, activity);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    boolean shouldShowPopUp = isAppInForeground("com.facebook.katana");
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


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static boolean isAppInForeground( String packageName) {
        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
        long endTime = System.currentTimeMillis();
        long beginTime = endTime - 60000; // delay in checking wifi/ location when user just turned on gps.
        UsageEvents usageEvents = usageStatsManager.queryEvents(beginTime, endTime);
        UsageEvents.Event event = new UsageEvents.Event();
        long lastResumedTime = 0;
        long lastPausedTime = 0;

        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event);
            if (packageName.equals(event.getPackageName())) {
                if (event.getEventType() == UsageEvents.Event.ACTIVITY_RESUMED) {
                    lastResumedTime = event.getTimeStamp();
                } else if (event.getEventType() == UsageEvents.Event.ACTIVITY_PAUSED) {
                    lastPausedTime = event.getTimeStamp();
                }
            }
        }


        return lastResumedTime > lastPausedTime && (endTime - lastResumedTime) < 60000;
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


}
