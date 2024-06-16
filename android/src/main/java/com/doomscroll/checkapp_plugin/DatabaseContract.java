package com.doomscroll.checkapp_plugin;
import android.provider.BaseColumns;

public final class DatabaseContract {

    // Private constructor to prevent instantiation
    private DatabaseContract() {}
public static class Schedule implements BaseColumns{
        public static final String TABLE_NAME = "schedules";
        public static final String COLUMN_NAME_ID = "id";
}
    // Inner class defining the Location table contents
    public static class Location implements BaseColumns {
        public static final String TABLE_NAME = "location";
        public static final String COLUMN_NAME_LOCATION = "location";
        public static final String COLUMN_NAME_LONGITUDE = "longitude";
        public static final String COLUMN_NAME_LATITUDE = "latitude";
    }

    // Inner class defining the Wifi table contents
    public static class Wifi implements BaseColumns {
        public static final String TABLE_NAME = "wifi";
        public static final String COLUMN_NAME_WIFI_NAME = "wifiName";
    }

    // Inner class defining the App table contents
    public static class App implements BaseColumns {
        public static final String TABLE_NAME = "app";
        public static final String COLUMN_NAME_PACKAGE_NAME = "packageName";
        public static final String COLUMN_NAME_ICON_BASE64_STRING = "iconBase64String";
        public static final String COLUMN_NAME_APP_NAME = "appName";
        public static final String COLUMN_NAME_BLOCK_ID = "blockId";
    }

    // Inner class defining the Website table contents
    public static class Website implements BaseColumns {
        public static final String TABLE_NAME = "website";
        public static final String COLUMN_NAME_URL = "url";
        public static final String COLUMN_NAME_BLOCK_ID = "blockId";
    }

    // Inner class defining the Keyword table contents
    public static class Keyword implements BaseColumns {
        public static final String TABLE_NAME = "keyword";
        public static final String COLUMN_NAME_KEYWORD = "keyword";
        public static final String COLUMN_NAME_BLOCK_ID = "blockId";
    }

    // Inner class defining the Timing table contents
    public static class Timing implements BaseColumns {
        public static final String TABLE_NAME = "timing";
        public static final String COLUMN_NAME_START_TIMING = "startTiming";
        public static final String COLUMN_NAME_END_TIMING = "endTiming";
        public static final String COLUMN_NAME_ID = "id"; // Assuming this is a foreign key
    }

    // Inner class defining the Day table contents
    public static class Day implements BaseColumns {
        public static final String TABLE_NAME = "day";
        public static final String COLUMN_NAME_DAY = "day";
        public static final String COLUMN_NAME_TIME_ID = "timeId"; // Assuming this is a foreign key
        public static final String COLUMN_NAME_ID = "id"; // Assuming this is a foreign key
    }
}
