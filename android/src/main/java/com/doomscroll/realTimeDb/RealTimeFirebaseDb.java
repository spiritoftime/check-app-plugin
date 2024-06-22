package com.doomscroll.realTimeDb;

import static com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.BrowserInterceptor.setSupportedBrowserConfigs;

import android.util.Log;

import com.doomscroll.checkapp_plugin.accessibilityService.browserInterceptor.SupportedBrowserConfig;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;
public class RealTimeFirebaseDb {
    static FirebaseDatabase database = FirebaseDatabase.getInstance();
    static DatabaseReference myRef = database.getReference("supportedBrowserConfig");

    public static void querySupportedBrowserConfigs() {
        myRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (dataSnapshot.exists()) {
                    List<SupportedBrowserConfig> browsers = new ArrayList<>();

                    for (DataSnapshot browserSnapshot : dataSnapshot.getChildren()) {
                        // Get package_name and id_url_bar
                        String packageName = browserSnapshot.child("package_name").getValue(String.class);
                        String idUrlBar = browserSnapshot.child("id_url_bar").getValue(String.class);

                        browsers.add(new SupportedBrowserConfig(packageName, idUrlBar));
                    }
                    setSupportedBrowserConfigs(browsers);
                } else {
                    Log.d("Firebase", "No such document");
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                // Getting Post failed, log a message
                Log.w("browser configs", "loadPost:onCancelled", databaseError.toException());
            }
        });
    }
}