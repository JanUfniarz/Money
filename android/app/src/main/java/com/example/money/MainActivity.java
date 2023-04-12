package com.example.money;

import android.os.Build;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.room.Room;

import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;
import com.example.money.entry.EntryDatabase;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.balance_card/MainActivity";

    private List<Account> accounts = new ArrayList<>();

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        AppContextSingleton.setContext(getApplicationContext());

        //# YT
        AccountDatabase account_db = Room.databaseBuilder(
                getApplicationContext(),
                AccountDatabase.class,
                "Account_database")
                .allowMainThreadQueries().build();

        EntryDatabase entry_db = Room.databaseBuilder(
                        getApplicationContext(),
                        EntryDatabase.class,
                        "Entry_database")
                .allowMainThreadQueries().build();

        reload(account_db, entry_db);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            final Map<String, Object> arguments = call.arguments();

                            switch (call.method) {

                                default:
                                    result.notImplemented();
                                    break;

                                case "addAccount":
                                    account_db.accountDao().InsertAll(new Account(
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
                                    String name = (accounts
                                            .get((int) arguments.get("index")))
                                            .name;
                                    result.success(name);
                                    break;

                                case "getValue":
                                    double value = (accounts
                                            .get((int) arguments.get("index")))
                                            .value;
                                    result.success(value);
                                    break;

                                case "getLength":
                                    int len = accounts.size();
                                    result.success(len);
                                    break;

                                case "changeName" :
                                    Account toChangeN = accounts.get((int) arguments.get("index"));
                                    toChangeN.name = (String) arguments.get("newName");
                                    account_db.accountDao().updateAccounts(toChangeN);
                                    break;

                                case "changeValue" :
                                    Account toChangeV = accounts.get((int) arguments.get("index"));
                                    toChangeV.value = (double) arguments.get("newValue");
                                    account_db.accountDao().updateAccounts(toChangeV);
                                    break;

                                case "deleteAccount" :
                                    account_db.accountDao().delete(
                                            accounts.get((int) arguments.get("index")));
                                    break;
                            }
                            reload(account_db, entry_db);
                        }
                );
    }

    private void reload(AccountDatabase account_db,
                        EntryDatabase entry_db) {
        accounts = account_db.accountDao().getAllAccounts();
    }
}
