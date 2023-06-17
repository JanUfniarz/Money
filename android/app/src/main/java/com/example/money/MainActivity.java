package com.example.money;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.example.money.account.AccountDatabase;
import com.example.money.budget.BudgetDatabase;
import com.example.money.entry.EntryDatabase;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.Invoker/MainActivity";

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        AccountDatabase account_db = AccountDatabase.getInstance(getApplicationContext());
        EntryDatabase entry_db = EntryDatabase.getInstance(getApplicationContext());
        BudgetDatabase budget_db = BudgetDatabase.getInstance(getApplicationContext());

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            final Map<String, Object> arguments = call.arguments();

                            String[] split = call.method.split("/");
                            Storable database;

                            switch (split[0]) {
                                default: result.notImplemented();
                                case "account" : database = account_db; break;
                                case "entry" : database = entry_db; break;
                                case "budget" : database = budget_db; break;
                            }

                            switch (split[1]) {

                                default:
                                    result.notImplemented();
                                    break;

                                case "add" : database.add(arguments);
                                    break;

                                case "delete" : database.delete(arguments);
                                    break;

                                case "update" : database.update(split[2], arguments);
                                    break;

                                case "get" : result.success(database.get(split[2], arguments));
                                        break;
                            }
                        }
                );
    }

    @RequiresApi(api = Build.VERSION_CODES.GINGERBREAD)
    public static String toFirstLetterUpperCase(String input) {
        return input == null || input.isEmpty() ? input
                : (input.substring(0, 1).toUpperCase()
                    + input.substring(1).toLowerCase())
                    .replaceAll("_", " ");
    }
}