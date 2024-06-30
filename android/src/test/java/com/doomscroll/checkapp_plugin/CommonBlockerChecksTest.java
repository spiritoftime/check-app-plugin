package com.doomscroll.checkapp_plugin;

import static org.mockito.Mockito.doCallRealMethod;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

import com.doomscroll.checkapp_plugin.appBlocker.BlockTask;

import junit.framework.TestCase;

import org.mockito.Mock;
import org.mockito.MockedStatic;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;


public class CommonBlockerChecksTest extends TestCase {
    @Mock
    CommonBlockerChecks commonBlockerChecks;

    @Override
    protected void setUp() throws Exception {
        super.setUp();
        commonBlockerChecks = mock(CommonBlockerChecks.class);

    }

    public void testCheckCommonBlockers() {
    }

    public void testCheckBlockedLocation() {
        CommonBlockerChecks commonBlockerChecks = mock(CommonBlockerChecks.class);

        HashMap<String, Object> location = new HashMap<>();
        location.put("longitude", 102.8);
        location.put("latitude", 105.8);

        List<HashMap<String, Object>> locations = Collections.singletonList(location);

        HashMap<String, Object> toCheck = new HashMap<>();
        toCheck.put("checkLocation", true);
        toCheck.put("locations", locations);

        commonBlockerChecks.toCheck = toCheck;

        try (MockedStatic<BlockTask> mockedStatic = mockStatic(BlockTask.class)) {
            mockedStatic.when(BlockTask::getCurrentLng).thenReturn(102.8);
            mockedStatic.when(BlockTask::getCurrentLat).thenReturn(105.8);


            doCallRealMethod().when(commonBlockerChecks).checkBlockedLocation();

            commonBlockerChecks.checkBlockedLocation();

            assertTrue(commonBlockerChecks.atBlockedLocation);
            mockedStatic.when(BlockTask::getCurrentLat).thenReturn(106.8);
            commonBlockerChecks.checkBlockedLocation();
            assertFalse(commonBlockerChecks.atBlockedLocation);
            mockedStatic.when(BlockTask::getCurrentLat).thenReturn(105.8004);
            commonBlockerChecks.checkBlockedLocation();
            assertTrue(commonBlockerChecks.atBlockedLocation);




        }
    }

    public void testCheckBlockedWifi() {


    }

    public void testCheckDay() {
    }

    public void testCheckTiming() {
    }
}