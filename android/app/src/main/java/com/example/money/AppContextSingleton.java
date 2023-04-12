package com.example.money;

import android.content.Context;

//# GPT
public class AppContextSingleton {
    private static Context appContext;

    public static void setContext(Context context) {
        appContext = context.getApplicationContext();
    }

    public static Context getContext() {
        return appContext;
    }
}
