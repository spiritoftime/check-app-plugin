package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static org.mockito.Mockito.doCallRealMethod;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

import com.doomscroll.checkapp_plugin.appBlocker.BlockTask;
import com.doomscroll.checkapp_plugin.Utils;

import junit.framework.TestCase;

import org.mockito.Mock;
import org.mockito.MockedStatic;

import java.util.ArrayList;
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


    public void testCheckBlockedLocation() {

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
        List<String> wifis = new ArrayList<>();
        wifis.add("Singtel");
        HashMap<String, Object> toCheck = new HashMap<>();
        toCheck.put("checkWifi", true);
        toCheck.put("wifis", wifis);

        commonBlockerChecks.toCheck = toCheck;
        try (MockedStatic<BlockTask> mockedStatic = mockStatic(BlockTask.class)) {
            mockedStatic.when(BlockTask::getCurrentConnectedWifi).thenReturn("Singtel");
            doCallRealMethod().when(commonBlockerChecks).checkBlockedWifi();
            commonBlockerChecks.checkBlockedWifi();
            assertTrue(commonBlockerChecks.usingBlockedWifi);
            mockedStatic.when(BlockTask::getCurrentConnectedWifi).thenReturn("Hi");
            commonBlockerChecks.checkBlockedWifi();
            assertFalse(commonBlockerChecks.usingBlockedWifi);
        }
    }

    public void testCheckDay() {
        List<String> days = new ArrayList<>();
        days.add(getCurrentDayTime().get(0));
        HashMap<String, Object> toCheck = new HashMap<>();
        toCheck.put("checkDay", true);
        toCheck.put("days", days);
        commonBlockerChecks.toCheck = toCheck;
        doCallRealMethod().when(commonBlockerChecks).checkDay();
        commonBlockerChecks.checkDay();
        assertTrue(commonBlockerChecks.blockedDay);

    }

    public void testCheckTiming() {
        HashMap<String, Object> toCheck = new HashMap<>();
        toCheck.put("checkTiming", true);

        List<HashMap<String, Object>> timings = new ArrayList<>();
        HashMap<String, Object> timing1 = new HashMap<>();
        timing1.put("startTiming", "00:00");
        timing1.put("endTiming", "23:59");
        timings.add(timing1);

        toCheck.put("timings", timings);
        commonBlockerChecks.toCheck = toCheck;

        doCallRealMethod().when(commonBlockerChecks).checkTiming();

        commonBlockerChecks.checkTiming();
        assertTrue(commonBlockerChecks.blockedTiming);
    }
}