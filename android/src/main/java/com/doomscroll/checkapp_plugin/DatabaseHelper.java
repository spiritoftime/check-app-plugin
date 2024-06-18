package com.doomscroll.checkapp_plugin;

import static com.doomscroll.checkapp_plugin.Utils.parseStringToArray;
import static com.doomscroll.checkapp_plugin.Utils.parseStringToSingleArray;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.io.File;
import java.util.ArrayList;
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
                "(SELECT GROUP_CONCAT('[' || l.longitude || ', ' || l.latitude || ', ' || l.location || ']') " +
                " FROM locations l WHERE l.scheduleId = s.id GROUP BY l.scheduleId) AS locations, " +
                "(SELECT GROUP_CONCAT('[' || w.wifiName || ']') " +
                " FROM wifis w WHERE w.scheduleId = s.id GROUP BY w.scheduleId) AS wifis, " +
                "(SELECT GROUP_CONCAT('[' || tm.startTiming || ', ' || tm.endTiming  ||  ']') " +
                " FROM timings tm JOIN times t ON tm.timeId = t.id  GROUP BY t.id) AS timings, " +
                "(SELECT GROUP_CONCAT('[' || d.day ||  ']') " +
                " FROM days d JOIN times t ON d.timeId = t.id  GROUP BY t.id) AS days, " +

                "(SELECT GROUP_CONCAT('[' || a.appName || ', ' || a.packageName || ', ' || a.iconBase64String || ']') " +
                " FROM apps a JOIN blocks b ON a.blockId = b.id  GROUP BY b.id) AS apps, " +
                "(SELECT GROUP_CONCAT('[' || w.url || ']') " +
                " FROM websites w JOIN blocks b ON w.blockId = b.id WHERE b.scheduleId = s.id GROUP BY b.scheduleId) AS websites, " +
                "(SELECT GROUP_CONCAT('[' || k.keyword || ']') " +
                " FROM keywords k JOIN blocks b ON k.blockId = b.id WHERE b.scheduleId = s.id GROUP BY b.scheduleId) AS keywords " +
                "FROM schedules s WHERE s.userId = ? AND s.isActive = 1;";


        List<Map<String, Object>> result = new ArrayList<>();
        Cursor cursor = db.rawQuery(query, new String[]{String.valueOf(userId)});

        while (cursor.moveToNext()) {
            Map<String, Object> schedule = new HashMap<>();
            String locations = cursor.getString(cursor.getColumnIndexOrThrow("locations"));
            String wifis = cursor.getString(cursor.getColumnIndexOrThrow("wifis"));

            String apps = cursor.getString(cursor.getColumnIndexOrThrow("apps"));
            String websites = cursor.getString(cursor.getColumnIndexOrThrow("websites"));
            String keywords = cursor.getString(cursor.getColumnIndexOrThrow("keywords"));

            String timings = cursor.getString(cursor.getColumnIndexOrThrow("timings"));
            String days = cursor.getString(cursor.getColumnIndexOrThrow("days"));


            List<List<String>> appList = parseStringToArray(apps);
            List<String> websiteList = parseStringToSingleArray(websites);
            List<String> keywordList = parseStringToSingleArray(keywords);
            List<List<String>> timingList = parseStringToArray(timings);
            List<List<String>> locationList = parseStringToArray(locations);
            List<String> wifiList = parseStringToSingleArray(wifis);
            List<String> dayList = parseStringToSingleArray(days);
            schedule.put("apps", appList);
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

}
