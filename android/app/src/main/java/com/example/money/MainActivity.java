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
    private static final String CHANNEL = "com.flutter.balance_card/MainActivity";

    private final List<Account> accounts = new ArrayList<>();

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        accounts.add(new Account("Test Acc", 1250.75));
        accounts.add(new Account("Test 2", 124.50));
        accounts.add(new Account("Test 3", 12.50));

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
                                    break;

                                case "getName":
                                    try {
                                        String name = ((Account) accounts
                                                .get((int) arguments.get("index")))
                                                .name;
                                        result.success(name);
                                    } catch (IndexOutOfBoundsException e) {
                                        result.error(
                                                "IOOBE",
                                                "IndexOutOfBoundsException",
                                                "");
                                    }
                                    break;
                                case "getValue":
                                    try {
                                        double value = ((Account) accounts
                                                .get((int) arguments.get("index")))
                                                .value;
                                        result.success(value);
                                    } catch (IndexOutOfBoundsException e) {
                                        result.error(
                                                "IOOBE",
                                                "IndexOutOfBoundsException",
                                                "");
                                    }
                                    break;
                                case "getLength":
                                    int len = accounts.size();
                                    result.success(len);
                                    break;
                            }
                        }
                );
    }
}
