package com.doomscroll.checkapp_plugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PictureDrawable;
import android.util.Base64;

import com.google.gson.reflect.TypeToken;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class Utils {

    public static Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap = null;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if (bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }
        if (drawable instanceof PictureDrawable) {
            Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bmp);
            canvas.drawPicture(((PictureDrawable) drawable).getPicture());
            return bmp;
        }

        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    //    might be inefficient - see https://stackoverflow.com/questions/9224056/android-bitmap-to-base64-string
    public static String bitmapToBase64(Bitmap bitmap) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
    }

    public static List<List<String>> parseStringToArray(String input) {
        if (input == null || input.isEmpty()) {
            return new ArrayList<>();
        }
        // Remove surrounding square brackets and split by "],["
        String[] pairs = input.substring(1, input.length() - 1).split("],\\[");

        List<List<String>> result = new ArrayList<>();

        for (String pair : pairs) {
            String[] elements = pair.split(",");
            List<String> innerList = Arrays.asList(elements);
            result.add(innerList);
        }

        return result;
    }

    public static List<String> parseStringToSingleArray(String input) {
        if (input == null || input.isEmpty()) {
            return new ArrayList<>();
        }

        String[] elements = input // Remove all whitespace
                .replaceAll("[\\[\\]]", "") // Remove square brackets
                .split(","); // Split by comma
        return Arrays.asList(elements);
    }

    public static List<String> getCurrentDayTime() {
        List<String> currentDayTime = new ArrayList<>();
        // Get the current time
        Calendar calendar = Calendar.getInstance();

        // Define the desired format for day and 23-hour time
        SimpleDateFormat sdf = new SimpleDateFormat("EEEE HH:mm", Locale.getDefault());

        // Format the current time
        String formattedTime = sdf.format(calendar.getTime());
        currentDayTime.add(formattedTime.split(" ")[0]); // day
        currentDayTime.add(formattedTime.split(" ")[1]);

        return currentDayTime;
    }

    public static boolean isCurrentTimeWithinRange(String start, String end, String current) {
        @SuppressLint("SimpleDateFormat") SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");

        try {
            Date startTime = sdf.parse(start);
            Date endTime = sdf.parse(end);
            Date currentTime = sdf.parse(current);

            if (startTime.before(endTime)) {
                return currentTime.after(startTime) && currentTime.before(endTime);
            } else {
                // Handles the case where end time is on the next day (e.g., 22:00 - 06:00)
                return currentTime.after(startTime) || currentTime.before(endTime);
            }
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static double roundToDecimalPlaces(double num, int dp) {
        BigDecimal bdNum = new BigDecimal(num).setScale(dp, RoundingMode.HALF_UP);
        return bdNum.doubleValue();
    }

    public static <T> T safeCast(Object o, TypeToken<T> typeToken) {
        Class<?> rawType = typeToken.getRawType();
        if (rawType.isInstance(o)) {
            try {
                return (T) rawType.cast(o);
            } catch (ClassCastException e) {
                throw new IllegalArgumentException("Object is not of the expected type", e);
            }
        }
        throw new IllegalArgumentException("Type Token type not same as object");
    }

    public static void goToHomeScreen(Context context) {
        Intent startMain = new Intent(Intent.ACTION_MAIN);
        startMain.addCategory(Intent.CATEGORY_HOME);
        startMain.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startMain.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        context.startActivity(startMain);

    }



}
