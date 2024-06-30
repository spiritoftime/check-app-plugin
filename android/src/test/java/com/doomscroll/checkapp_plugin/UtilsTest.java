package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.getCurrentDayTime;
import static com.doomscroll.checkapp_plugin.Utils.isCurrentTimeWithinRange;
import static com.doomscroll.checkapp_plugin.Utils.parseStringToArray;
import static com.doomscroll.checkapp_plugin.Utils.parseStringToSingleArray;
import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import static org.junit.Assert.assertThrows;

import com.google.gson.reflect.TypeToken;

import junit.framework.TestCase;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

public class UtilsTest extends TestCase {
    public void testCurrentTimeWithinDateRange() {
//        tc 1 : outside range
        assertFalse(isCurrentTimeWithinRange("11:00", "15:00", "04:00"));
//        within range
        assertTrue(isCurrentTimeWithinRange("11:00", "15:00", "12:00"));
//        within range - next day
        assertTrue(isCurrentTimeWithinRange("23:00", "04:00", "01:00"));

    }

    public void testSafeCast() {
        TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {
        };
        List<String> wifisToInsert = new ArrayList<>();
        wifisToInsert.add("wifi1");
        HashMap<String, Object> schedule = new HashMap<>();
        schedule.put("wifis", wifisToInsert);

        List<String> wifis = safeCast(schedule.get("wifis"), typeToken);


        assertEquals(wifisToInsert, wifis);
//fail case
        TypeToken<Integer> failToken = new TypeToken<Integer>() {
        };


        assertThrows(IllegalArgumentException.class, () -> {
            safeCast(schedule.get("wifis"), failToken);
        });
    }

    public void testParseStringToArray() {
        // Test case 1: Normal input
        String tc1 = "[00:38,00:38],[21:45,10:30]";
        List<List<String>> tc1List = parseStringToArray(tc1);
        assertEquals(2, tc1List.size());
        assertEquals("00:38", tc1List.get(0).get(0));
        assertEquals("00:38", tc1List.get(0).get(1));
        assertEquals("21:45", tc1List.get(1).get(0));
        assertEquals("10:30", tc1List.get(1).get(1));

        String tc2 = "";
        List<List<String>> tc2List = parseStringToArray(tc2);
        assertTrue(tc2List.isEmpty());

        String tc3 = "invalid input";
        List<List<String>> tc3List = parseStringToArray(tc3);
        assertEquals("nvalid input", tc3List.get(0).get(0));

        String tc4 = "[00:38]";
        List<List<String>> tc4List = parseStringToArray(tc4);
        assertEquals(1, tc4List.size());
        assertEquals("00:38", tc4List.get(0).get(0));
    }


    public void testParseStringToSingleArray() {
        String tc1 = "[Wednesday,Thursday]";
        List<String> tc1List = parseStringToSingleArray(tc1);
        assertEquals("Wednesday", tc1List.get(0));
        assertEquals(2, tc1List.size());
        assertEquals("Thursday", tc1List.get(1));

        // Test case 2: Empty input
        String tc2 = "";
        List<String> tc2List = parseStringToSingleArray(tc2);
        assertTrue(tc2List.isEmpty());

        String tc3 = "invalid input";
        List<String> tc3List = parseStringToSingleArray(tc3);
        assertEquals(tc3, tc3List.get(0));

        String tc4 = "[Monday]";
        List<String> tc4List = parseStringToSingleArray(tc4);
        assertEquals(1, tc4List.size());
        assertEquals("Monday", tc4List.get(0));
    }

    public void testGetCurrentDayTime() {
        // Get the current day and time using Java's Calendar and SimpleDateFormat
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE", Locale.getDefault());
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm", Locale.getDefault());

        String expectedDay = dayFormat.format(calendar.getTime());
        String expectedTime = timeFormat.format(calendar.getTime());

        List<String> currentDayTime = getCurrentDayTime();

        assertEquals(2, currentDayTime.size());

        assertEquals(expectedDay, currentDayTime.get(0));

        assertEquals(expectedTime, currentDayTime.get(1));
    }

}