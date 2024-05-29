package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.AppService.REDIRECT_HOME;

import static com.doomscroll.checkapp_plugin.AppService.createIntentForService;
import static com.doomscroll.checkapp_plugin.AppService.initializeServiceAtFlutter;
import static com.doomscroll.checkapp_plugin.Permissions.requestBackgroundPermissionForXiaomi;
import static com.doomscroll.checkapp_plugin.Permissions.requestNotificationPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestOverlayPermission;
import static com.doomscroll.checkapp_plugin.Permissions.requestUsagePermission;

import android.app.Activity;

import android.app.usage.UsageEvents;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PictureDrawable;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;


import java.io.ByteArrayOutputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import android.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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

    private static final String GET_LAUNCHABLE_APPLICATIONS = "GET_LAUNCHABLE_APPLICATIONS";
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
            case GET_LAUNCHABLE_APPLICATIONS:
                List<Map<String, Object>> appList = getInstalledApplications();
                result.success(appList);
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
            Bitmap iconBitMap = drawableToBitmap(icon);
            String iconBase64String = bitmapToBase64(iconBitMap);
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
            appList.add(new AppService.AppInfo(packageName, iconBase64String,appName).toMap());
        }

        return appList;
    }


    public static Bitmap drawableToBitmap (Drawable drawable) {
        Bitmap bitmap = null;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if(bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }
        if(drawable instanceof PictureDrawable){
            Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bmp);
            canvas.drawPicture(((PictureDrawable) drawable).getPicture());
            return bmp;
        }

        if(drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

//    might be inefficient - see https://stackoverflow.com/questions/9224056/android-bitmap-to-base64-string
    public static String bitmapToBase64(Bitmap bitmap){
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
    }

}
