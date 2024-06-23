package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.parseStringToArray;
import static com.doomscroll.checkapp_plugin.Utils.parseStringToSingleArray;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "doomscroll.db";
    private static final int DATABASE_VERSION = 1;
    private final Context context;

    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;

    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        // Initialize your tables here
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Handle database upgrades
    }

    private boolean doesDatabaseExist(Context context) {
        File dbFile = context.getDatabasePath(DATABASE_NAME);
        return dbFile.exists();
    }

    public String getUserId() {
        String userId = "user";

        if (!doesDatabaseExist(context)) {
            Log.d("Database Status", "Database has not been created from flutter side");
            return userId;
        }
        SQLiteDatabase db = this.getReadableDatabase();

        String query = "SELECT id " +
                "FROM users " +
                "LIMIT 1";

        try (Cursor cursor = db.rawQuery(query, null)) {

            if (cursor != null && cursor.moveToFirst()) {
                userId = cursor.getString(cursor.getColumnIndexOrThrow("id"));
            }
        } catch (Exception e) {
            Log.d("No User Yet", "Query User Error");
        }

        return userId;
    }

    public List<Map<String, Object>> getSchedules(String userId) {
        SQLiteDatabase db = this.getReadableDatabase();
        String query = "SELECT " +
                "s.id AS scheduleId, " +
                "(SELECT GROUP_CONCAT('[' || l.longitude || ',' || l.latitude || ',' || l.location || ']') " +
                " FROM locations l WHERE l.scheduleId = s.id GROUP BY l.scheduleId) AS locations, " +
                "(SELECT GROUP_CONCAT('[' || w.wifiName || ']') " +
                " FROM wifis w WHERE w.scheduleId = s.id GROUP BY w.scheduleId) AS wifis, " +
                "(SELECT GROUP_CONCAT('[' || tm.startTiming || ',' || tm.endTiming  ||  ']') " +
                " FROM timings tm JOIN times t ON tm.timeId = t.id WHERE t.scheduleId = s.id GROUP BY t.id) AS timings, " +
                "(SELECT GROUP_CONCAT('[' || d.day ||  ']') " +
                " FROM days d JOIN times t ON d.timeId = t.id WHERE t.scheduleId = s.id GROUP BY t.id) AS days, " +
                "(SELECT GROUP_CONCAT('[' || a.appName || ',' || a.packageName || ',' || a.iconBase64String || ']') " +
                " FROM apps a JOIN blocks b ON a.blockId = b.id JOIN schedules s2 ON b.scheduleId = s2.id WHERE s2.id = s.id GROUP BY b.id) AS apps, " +
                "(SELECT GROUP_CONCAT('[' || pb.appName || ',' || pb.feature  || ',' || pb.packageName  || ']') " +
                " FROM partialblockers pb JOIN blocks b ON pb.blockId = b.id JOIN schedules s2 ON b.scheduleId = s2.id WHERE s2.id = s.id GROUP BY b.id) AS partialblockers, " +
                "(SELECT GROUP_CONCAT('[' || w.url || ']') " +
                " FROM websites w JOIN blocks b ON w.blockId = b.id JOIN schedules s2 ON b.scheduleId = s2.id WHERE s2.id = s.id GROUP BY b.id) AS websites, " +
                "(SELECT GROUP_CONCAT('[' || k.keyword || ']') " +
                " FROM keywords k JOIN blocks b ON k.blockId = b.id JOIN schedules s2 ON b.scheduleId = s2.id WHERE s2.id = s.id GROUP BY b.id) AS keywords " +
                "FROM schedules s WHERE s.userId = ? AND s.isActive = 1;";

        List<Map<String, Object>> result = new ArrayList<>();
        Cursor cursor = db.rawQuery(query, new String[]{String.valueOf(userId)});

        while (cursor.moveToNext()) {
            Map<String, Object> schedule = new HashMap<>();
            String locations = cursor.getString(cursor.getColumnIndexOrThrow("locations"));
            String wifis = cursor.getString(cursor.getColumnIndexOrThrow("wifis"));
            String partialblockers = cursor.getString(cursor.getColumnIndexOrThrow("partialblockers"));

            String apps = cursor.getString(cursor.getColumnIndexOrThrow("apps"));
            String websites = cursor.getString(cursor.getColumnIndexOrThrow("websites"));
            String keywords = cursor.getString(cursor.getColumnIndexOrThrow("keywords"));
            String timings = cursor.getString(cursor.getColumnIndexOrThrow("timings"));
            String days = cursor.getString(cursor.getColumnIndexOrThrow("days"));

            List<List<String>> appList = parseStringToArray(apps);
            List<List<String>> partialBlockerList = parseStringToArray(partialblockers);

            List<String> websiteList = parseStringToSingleArray(websites);
            List<String> keywordList = parseStringToSingleArray(keywords);
            List<List<String>> timingList = parseStringToArray(timings);
            List<List<String>> locationList = parseLocations(locations);
            List<String> wifiList = parseStringToSingleArray(wifis);
            List<String> dayList = parseStringToSingleArray(days);

            schedule.put("apps", appList);
            schedule.put("partialBlockers", partialBlockerList);

            schedule.put("websites", websiteList);
            schedule.put("keywords", keywordList);
            schedule.put("timings", timingList);
            schedule.put("locations", locationList);
            schedule.put("wifis", wifiList);
            schedule.put("days", dayList);

            result.add(schedule);
        }

        cursor.close();
        return result;
    }

    public static List<List<String>> parseLocations(String locationString) {
        //        [103.8473557, 1.4235911, Blk 419, Yishun Avenue 11, Yishun, Northwest, Singapore, 760418, Singapore],[103.8336942, 1.428136, Yishun, Northwest, Singapore]
        if (locationString == null || locationString.isEmpty()) {
            return new ArrayList<>();
        }

        List<List<String>> locations = new ArrayList<>();
        String[] stringLocations = locationString.split("]");
        for (int x = 0; x < stringLocations.length; x++) {
            String stringLocation = stringLocations[x];
            List<String> location = getLocation(x, stringLocation);

            locations.add(location);
        }
        return locations;

    }

    @NonNull
    private static List<String> getLocation(int x, String stringLocation) {
        List<String> location = new ArrayList<>();
        String[] l;
        if (x == 0) {
            l = stringLocation.replace("[", "").replace("]", "").split(",");
        } else {
            l = stringLocation.replace("[", "").replace("]", "").substring(1).split(",");
        }

        String lng = l[0].trim();
        String lat = l[1].trim();
        StringBuilder locationBuilder = new StringBuilder();
        for (int i = 2; i < l.length; i++) {
            locationBuilder.append(l[i].trim());
            if (i < l.length - 1) {
                locationBuilder.append(", "); // Add comma separator between parts
            }
        }

        String locationName = locationBuilder.toString();
        location.add(lng);
        location.add(lat);
        location.add(locationName);
        return location;
    }

}
