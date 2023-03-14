package com.example.money;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.epic/main";

    private List<Account> accounts = new ArrayList<>();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            final Map<String, Object> arguments = call.arguments();

                            if (call.method.equals("addAccount")) {
                                //result.success(addAccount());
                                addAccount(
                                        (String) arguments.get("name"),
                                        (double) arguments.get("value")
                                );
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void addAccount(String name, double value) {
        accounts.add(new Account(name, value));
    }
}
