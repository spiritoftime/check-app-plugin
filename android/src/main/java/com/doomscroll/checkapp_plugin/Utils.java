package com.doomscroll.checkapp_plugin;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PictureDrawable;
import android.util.Base64;

import java.io.ByteArrayOutputStream;

public class Utils {

    public static Bitmap drawableToBitmap (Drawable drawable) {
        Bitmap bitmap = null;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if(bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }
        if(drawable instanceof PictureDrawable){
            Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bmp);
            canvas.drawPicture(((PictureDrawable) drawable).getPicture());
            return bmp;
        }

        if(drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
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
    public static String bitmapToBase64(Bitmap bitmap){
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
    }
    public static String[][] parseStringToArray(String input) {
        if (input == null || input.isEmpty()) {
            return new String[0][0];
        }
        // Remove surrounding square brackets and split by "],["
        String[] pairs = input.substring(1, input.length() - 1).split("\\],\\[");

        String[][] result = new String[pairs.length][];

        for (int i = 0; i < pairs.length; i++) {
            result[i] = pairs[i].split(",");
        }

        return result;
    }
    public static String[] parseStringToSingleArray(String input) {
        if (input == null || input.isEmpty()) {
            return new String[0];
        }

        // Remove surrounding square brackets and split by "],["
        String[] elements = input.substring(1, input.length() - 1).split("\\],\\[");

        return elements;
    }
}
