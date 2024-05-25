package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.NOTIFICATION_CHANNEL;
import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;
import static com.doomscroll.checkapp_plugin.AppService.START;

import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;
import static com.doomscroll.checkapp_plugin.AppService.initializeServiceAtFlutter;
import static com.doomscroll.checkapp_plugin.Permissions.requestBackgroundPermissionForXiaomi;
import static com.doomscroll.checkapp_plugin.Permissions.requestNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestUsagePermission;

import android.Manifest;
import android.app.Activity;
import android.app.AppOpsManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
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
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;

import java.lang.reflect.Method;
import java.util.Locale;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class CheckappPlugin extends FlutterActivity implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String FACEBOOK_PACKAGE_NAME = "com.facebook.katana";

    private static final String FLUTTER_CHANNEL_NAME = "com.doomscroll.checkapp";
    private static final String CHANNEL_DETECT_METHOD = "DETECT_APP";
    private static final String CHANNEL_OVERLAY_PERMISSION = "REQUEST_OVERLAY_PERMISSION";
    private static final String REQUEST_NOTIFICATION_PERMISSION = "REQUEST_NOTIFICATION_PERMISSION";

    private static final String CHANNEL_USAGE_PERMISSION = "REQUEST_USAGE_PERMISSION";
    private static final String GET_PLATFORM_VERSION = "getPlatformVersion";
    private static final String REQUEST_BACKGROUND_PERMISSION = "REQUEST_BACKGROUND_PERMISSION";


    private MethodChannel channel;
    private Context context;
    @Nullable
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FLUTTER_CHANNEL_NAME);
        channel.setMethodCallHandler(this);
        initializeServiceAtFlutter(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case CHANNEL_DETECT_METHOD:

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission(context, activity);
                }
                requestUsagePermission(context, activity);
                requestBackgroundPermissionForXiaomi(context, activity);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    boolean shouldShowPopUp = isFacebookAppInForeground();
                    if (shouldShowPopUp) {
                        createIntentForService(context, REDIRECT_HOME);
                    }
                    result.success(shouldShowPopUp);

                }
                break;
            case CHANNEL_OVERLAY_PERMISSION:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestOverlayPermission(context, activity);
                }
                break;
            case CHANNEL_USAGE_PERMISSION:
                requestUsagePermission(context, activity);
                break;
            case GET_PLATFORM_VERSION:
                result.success(getPlatformVersion());
                break;
            case REQUEST_NOTIFICATION_PERMISSION:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    requestNotificationPermission(context, activity);
                }
                break;

            case REQUEST_BACKGROUND_PERMISSION:
                requestBackgroundPermissionForXiaomi(context, activity);
            default:
                result.notImplemented();
                break;
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
