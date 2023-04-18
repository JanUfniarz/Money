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
import com.example.money.entry.Category;
import com.example.money.entry.Converter;
import com.example.money.entry.Entry;
import com.example.money.entry.EntryDatabase;
import com.example.money.entry.Type;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.balance_card/MainActivity";

    private List<Account> accounts = new ArrayList<>();
    private  List<Entry> entries = new ArrayList<>();

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

                                case "changeName":
                                    Account toChangeN = accounts.get((int) arguments.get("index"));
                                    toChangeN.name = (String) arguments.get("newName");
                                    account_db.accountDao().updateAccounts(toChangeN);
                                    break;

                                case "changeValue":
                                    Account toChangeV = accounts.get((int) arguments.get("index"));
                                    toChangeV.value = (double) arguments.get("newValue");
                                    account_db.accountDao().updateAccounts(toChangeV);
                                    break;

                                case "deleteAccount":
                                    account_db.accountDao().delete(
                                            accounts.get((int) arguments.get("index")));
                                    break;

                                case "addEntry":
                                    //* tittle
                                    String tittle = (String) arguments.get("tittle");

                                    //* type
                                    Type type = Type.INCOME;
                                    switch ((String) arguments.get("type")) {
                                        case "Income":
                                            type = Type.INCOME;
                                            break;
                                        case "Expense":
                                            type = Type.EXPENSE;
                                            break;
                                        case "Transfer":
                                            type = Type.TRANSFER;
                                            break;
                                    }

                                    //* amount
                                    double amount = (double) arguments.get("amount");

                                    //* date
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    Date date;

                                    try {
                                        date = sdf.parse((String) arguments.get("date"));
                                    } catch (ParseException e) {
                                        throw new RuntimeException(e);
                                    }

                                    //* account
                                    Account account = new Account("!!!", -1);
                                    for (Account ac : accounts)
                                        if (ac.name == arguments.get("account"))
                                            account = ac;

                                    //*category
                                    Category category = Category.OTHER;
                                    switch ((String) arguments.get("category")) {
                                        case "Basic expenditure":
                                            category = Category.BASIC_EXPENDITURE;
                                            break;
                                        case "Enterprise":
                                            category = Category.ENTERPRISE;
                                            break;
                                        case "Travelling":
                                            category = Category.TRAVELLING;
                                            break;
                                        case "House":
                                            category = Category.HOUSE;
                                            break;
                                        case "Health and beauty":
                                            category = Category.HEALTH_AND_BEAUTY;
                                            break;
                                        case "Transport":
                                            category = Category.TRANSPORT;
                                            break;
                                        case "Other":
                                            category = Category.OTHER;
                                            break;
                                    }

                                    entry_db.entryDao().InsertAll(
                                            new Entry(tittle, type, amount, date, account, category));

                                    break;

                                case "getLengthOfEntries" :
                                    int len2 = entries.size();
                                    result.success(len2);
                                    break;

                                case "getEntryData" :
                                    Entry entry = entries.get((int) arguments.get("index"));

                                    Map<String, Object> response = new HashMap<>();
                                    response.put("type", toFirstLetterUpperCase(
                                            entry.type.toString()));
                                    response.put("tittle", entry.tittle);
                                    response.put("amount", entry.amount);
                                    response.put("category", toFirstLetterUpperCase(
                                            entry.category.toString()));
                                    response.put("accountName", entry.account.name);
                                    response.put("date", Converter.dateToTimestamp(entry.date));

                                    result.success(response);
                                    break;
                            }
                            reload(account_db, entry_db);
                        }
                );
    }

    private void reload(AccountDatabase account_db,
                        EntryDatabase entry_db) {
        accounts = account_db.accountDao().getAllAccounts();
        entries = entry_db.entryDao().getAllEntries();
    }

    public static String toFirstLetterUpperCase(String input) {
        if (input == null || input.isEmpty()) return input;

        String lowerCaseInput = input.toLowerCase();
        String firstLetterUpperCase = lowerCaseInput.substring(0, 1).toUpperCase();
        String restOfString = lowerCaseInput.substring(1);
        return firstLetterUpperCase + restOfString;
    }
}