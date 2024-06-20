package com.doomscroll.checkapp_plugin;


import android.app.AppOpsManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import android.test.mock.MockContext;



import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;


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
