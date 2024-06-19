package com.doomscroll.checkapp_plugin;

import android.Manifest;
import android.app.Activity;
import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.provider.Settings;
import android.test.mock.MockContext;

import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import java.lang.reflect.Method;
import java.util.Locale;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

import junit.framework.TestCase;

@RunWith(MockitoJUnitRunner.class)
public class PermissionsTest extends TestCase {

    @Mock
    private MockContext mockContext;


    @Mock
    private PackageManager mockPackageManager;

    @Mock
    private ApplicationInfo mockApplicationInfo;

    @Mock
    private AppOpsManager mockAppOpsManager;



    @Before
    public void setUp() {
        when(mockContext.getPackageManager()).thenReturn(mockPackageManager);
        when(mockContext.getSystemService(Context.APP_OPS_SERVICE)).thenReturn(mockAppOpsManager);


    }

    @Test
    public void testCheckUsagePermission() throws Exception {
        when(mockPackageManager.getApplicationInfo(anyString(), eq(0))).thenReturn(mockApplicationInfo);
        when(mockAppOpsManager.checkOpNoThrow(anyString(), eq(mockApplicationInfo.uid), eq(mockApplicationInfo.packageName)))
                .thenReturn(AppOpsManager.MODE_ALLOWED);

        int result = Permissions.checkUsagePermission(mockContext);
        assertEquals(AppOpsManager.MODE_ALLOWED, result);
    }

}
