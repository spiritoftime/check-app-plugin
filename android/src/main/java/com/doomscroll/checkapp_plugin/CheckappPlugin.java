package com.doomscroll.checkapp_plugin;

import android.app.Activity;
import android.app.AppOpsManager;
import android.app.usage.UsageEvents;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class CheckappPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String FACEBOOK_PACKAGE_NAME = "com.facebook.katana";
    private static final int OVERLAY_PERMISSION_REQUEST_CODE = 1001;
    private static final String FLUTTER_CHANNEL_NAME = "com.doomscroll.checkapp";
    private static final String CHANNEL_DETECT_METHOD = "DETECT_APP";
    private static final String CHANNEL_OVERLAY_PERMISSION = "REQUEST_OVERLAY_PERMISSION";
    private static final String CHANNEL_USAGE_PERMISSION = "REQUEST_USAGE_PERMISSION";
    private static final String GET_PLATFORM_VERSION = "getPlatformVersion";

    private MethodChannel channel;
    private Context context;
    @Nullable
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FLUTTER_CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case CHANNEL_DETECT_METHOD:
                boolean shouldShowPopUp = false;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission();
                }
                requestUsagePermission();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    shouldShowPopUp = isFacebookAppInForeground();
                }
                result.success(shouldShowPopUp);
                break;
            case CHANNEL_OVERLAY_PERMISSION:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission();
                }
                break;
            case CHANNEL_USAGE_PERMISSION:
                requestUsagePermission();
                break;
            case GET_PLATFORM_VERSION:
                result.success(getPlatformVersion());
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private void requestOverlayPermission() {
        if (activity != null && !checkOverlayPermission()) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + activity.getPackageName()));
            activity.startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE);
        }
    }

    private boolean checkOverlayPermission() {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(context);
    }

    private int checkUsagePermission() {
        PackageManager packageManager = context.getPackageManager();
        ApplicationInfo applicationInfo;
        try {
            applicationInfo = packageManager.getApplicationInfo(context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            Log.e("PackageManager", e.toString());
            return 0;
        }
        AppOpsManager appOpsManager = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            return appOpsManager.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName);
        }
        return AppOpsManager.MODE_ALLOWED;
    }

    private void requestUsagePermission() {
        int mode = checkUsagePermission();
        if (mode != AppOpsManager.MODE_ALLOWED && activity != null) {
            activity.startActivity(new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS));
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    private boolean isFacebookAppInForeground() {
        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
        long endTime = System.currentTimeMillis();
        long beginTime = endTime - 1000;
        UsageEvents usageEvents = usageStatsManager.queryEvents(beginTime, endTime);
        UsageEvents.Event event = new UsageEvents.Event();
        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event);
            if (event.getEventType() == UsageEvents.Event.ACTIVITY_RESUMED &&
                    FACEBOOK_PACKAGE_NAME.equals(event.getPackageName())) {
                return true;
            }
        }
        return false;
    }

    public String getPlatformVersion() {
        return "Android " + Build.VERSION.RELEASE;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode == OVERLAY_PERMISSION_REQUEST_CODE) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Settings.canDrawOverlays(context)) {
                    Log.d("Permission", "Overlay permission granted");
                }
            }
            return false;
        });
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
}
