package com.doomscroll.checkapp_plugin;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AppOpsManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;


import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;

import com.doomscroll.checkapp_plugin.accessibilityService.AccessibilityInterceptorService;

import java.lang.reflect.Method;

import java.util.Locale;

public class Permissions {
    private static final int OVERLAY_PERMISSION_REQUEST_CODE = 1001;
    private static final int NOTIFICATION_PERMISSION_REQUEST_CODE = 1002;
    public static final int OP_BACKGROUND_START_ACTIVITY = 10021;

    private static final int LOCATION_PERMISSION_CODE = 1003;

    public static int checkUsagePermission(Context context) {
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

    public static void requestUsagePermission(Context context, Activity activity) {
        int mode = checkUsagePermission(context);
        if (mode != AppOpsManager.MODE_ALLOWED && activity != null) {
            activity.startActivity(new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS));
        }
    }

    public static boolean checkOverlayPermission(Context context) {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(context);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public static void requestOverlayPermission(Context context, Activity activity) {
        if (activity != null && !checkOverlayPermission(context)) {

            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + activity.getPackageName()));
            activity.startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE);
        }
    }

    //    needed to run foreground service
    public static boolean checkNotificationPermission(Context context) {
        return NotificationManagerCompat.from(context).areNotificationsEnabled();
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    public static void requestNotificationPermission(Context context, Activity activity) {

        boolean notificationPermissionEnabled = checkNotificationPermission(context);


        if (!notificationPermissionEnabled && activity != null) {

            String[] permissions = {Manifest.permission.POST_NOTIFICATIONS};

            ActivityCompat.requestPermissions(activity, permissions, NOTIFICATION_PERMISSION_REQUEST_CODE);

        }

    }

    //check special permission open new windows while running in background enabled or not (unique to mui)
//     see https://stackoverflow.com/questions/59645936/displaying-popup-windows-while-running-in-the-background

    @SuppressWarnings("JavaReflectionMemberAccess")
    public static boolean isBackgroundStartActivityPermissionGranted(Context context) {
        try {
            AppOpsManager mgr = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            Method m = AppOpsManager.class.getMethod("checkOpNoThrow", int.class, int.class, String.class);
            int result = (int) m.invoke(mgr, OP_BACKGROUND_START_ACTIVITY, android.os.Process.myUid(), context.getPackageName());
            return result == AppOpsManager.MODE_ALLOWED;
        } catch (Exception e) {
            Log.d("Exception", e.toString());
        }
        return true;
    }

    public static void requestBackgroundPermissionForXiaomi(Context context, Activity activity) {
        if (!isBackgroundStartActivityPermissionGranted(context) && activity != null) {
            if ("xiaomi".equals(Build.MANUFACTURER.toLowerCase(Locale.ROOT))) {
                Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR");
                intent.setClassName("com.miui.securitycenter",
                        "com.miui.permcenter.permissions.PermissionsEditorActivity");
                intent.putExtra("extra_pkgname", context.getPackageName());
                activity.startActivity(intent);
            }
        }
    }

    public static boolean checkLocationPermission(Context context, Activity activity) {
        boolean isPermissionEnabled = ActivityCompat.checkSelfPermission(
                context,
                android.Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
                &&
                ActivityCompat.checkSelfPermission(
                        context,
                        android.Manifest.permission.ACCESS_FINE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED;

        return isPermissionEnabled;


    }

    public static boolean checkGPSEnabled(Context context) {
        LocationManager manager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        final boolean isGPSEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        return isGPSEnabled;
    }

    public static void requestEnableGPS(Context context, Activity activity) {
        if (!checkGPSEnabled(context)) {
            Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
            activity.startActivityForResult(intent, 123456);

        }
    }

    @SuppressLint("InlinedApi")
    public static void requestLocationPermission(Context context, Activity activity) {


        if (!checkLocationPermission(context, activity)) {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:" + activity.getPackageName()));
            activity.startActivityForResult(intent, LOCATION_PERMISSION_CODE);


        }

    }

    public static boolean checkAccessibilityPermission(Context context) {
        String prefString = Settings.Secure.getString(context.getContentResolver(),
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
        ComponentName componentName = new ComponentName(context, AccessibilityInterceptorService.class);
        String flattenedName = componentName.flattenToString();

        return prefString != null && prefString.contains(flattenedName);

    }

    public static void requestAccessibilityPermission(Context context, Activity activity) {
        if (!checkAccessibilityPermission(context)) {
            Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
            activity.startActivityForResult(intent, 2000);
        }
    }


}
