package com.example.money;

import android.os.Build;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.epic/main";

    private List<Account> accounts = new ArrayList<>();

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            final Map<String, Object> arguments = call.arguments();

                            switch (call.method) {
                                default:
                                    result.notImplemented();
                                    break;
                                case "addAccount":
                                    //result.success(addAccount());
                                    accounts.add(new Account(
                                            (String) arguments.get("name"),
                                            (double) arguments.get("value")
                                    ));
                                    break;
                                case "balanceSum":
                                    double sum = accounts.stream()
                                            .map(account -> account.value)
                                            .reduce(Double::sum).orElseThrow();
                                    String res = String.valueOf(sum);
                                    result.success(res);

                            }
                        }
                );
    }
}
