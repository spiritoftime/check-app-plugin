package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.safeCast;

import static org.junit.Assert.assertThrows;

import com.google.gson.reflect.TypeToken;

import junit.framework.TestCase;

import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
public class UtilsTest extends  TestCase {
    public void testSafeCast() {
        TypeToken<List<String>> typeToken = new TypeToken<List<String>>() {};
        List<String> wifisToInsert = new ArrayList<>();
        wifisToInsert.add("wifi1");
        HashMap<String, Object> schedule = new HashMap<>();
        schedule.put("wifis", wifisToInsert);

        List<String> wifis = safeCast(schedule.get("wifis"), typeToken);


        assertEquals(wifisToInsert, wifis);

        TypeToken<Integer> failToken = new TypeToken<Integer>() {};


        assertThrows(IllegalArgumentException.class, () -> {
            safeCast(schedule.get("wifis"), failToken);
        });
    }

}