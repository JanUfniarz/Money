package com.example.money;

import io.flutter.embedding.android.FlutterActivity;

public class Account extends FlutterActivity {
    public String name;
    public double value;

    public Account(String name, double value) {
        this.name = name;
        this.value = value;
    }
}
