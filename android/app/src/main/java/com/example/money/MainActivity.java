package com.example.money;

import android.os.Build;

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
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.balance_card/MainActivity";

    private List<Account> accounts = new ArrayList<>();
    private AccountDatabase account_db;
    private  List<Entry> entries = new ArrayList<>();
    private EntryDatabase entry_db;

    private final Singleton singleton = Singleton.getInstance();

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        account_db = Room.databaseBuilder(
                getApplicationContext(),
                AccountDatabase.class,
                "Account_database")
                .allowMainThreadQueries().build();

        entry_db = Room.databaseBuilder(
                        getApplicationContext(),
                        EntryDatabase.class,
                        "Entry_database")
                .allowMainThreadQueries().build();

        reload();

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
                                    result.success(String.valueOf(
                                            accounts.stream()
                                                    .map(this::getValue)
                                                    .reduce(Double::sum)
                                                    .orElseThrow()));
                                    break;

                                case "getName":
                                    result.success((accounts
                                            .get((int) arguments.get("index")))
                                            .name);
                                    break;

                                case "getValue":
                                    result.success(getValue(accounts
                                            .get((int) arguments.get("index"))));
                                    break;

                                case "getLength":
                                    result.success(accounts.size());
                                    break;

                                case "changeName":
                                    Account toChangeN = accounts.get((int) arguments.get("index"));
                                    toChangeN.name = (String) arguments.get("newName");
                                    account_db.accountDao().updateAccounts(toChangeN);
                                    break;

                                case "changeValue":
                                    Account toChangeV = accounts.get((int) arguments.get("index"));
                                    setValue(toChangeV,
                                            (double) arguments.get("newValue"));
                                    account_db.accountDao().updateAccounts(toChangeV);
                                    break;

                                case "deleteAccount":
                                    account_db.accountDao().delete(
                                            accounts.get((int) arguments.get("index")));
                                    break;

                                case "addEntry":
                                    addEntry(arguments);
                                    break;

                                case "getLengthOfEntries" :
                                    result.success(entries.size());
                                    break;

                                case "getEntryType" :
                                    result.success(toFirstLetterUpperCase(
                                            entries.get((int) arguments.get("index"))
                                                    .type.toString()));
                                    break;

                                case "getEntryTitle" :
                                    result.success(entries.get(
                                            (int) arguments.get("index"))
                                            .title);
                                    break;

                                case "getEntryAmount" :
                                    result.success(entries.get(
                                            (int) arguments.get("index"))
                                            .amount);
                                    break;

                                case "getEntryCategory" :
                                    result.success(toFirstLetterUpperCase(
                                            entries.get((int) arguments.get("index"))
                                                    .category.toString()));
                                    break;

                                case "getEntryAccountName" :
                                    result.success(entries.get(
                                            (int) arguments.get("index"))
                                            .account.name);
                                    break;

                                case "getEntryAccount2Name" :
                                    result.success(entries.get(
                                            (int) arguments.get("index"))
                                            .account2.name);
                                    break;

                                case "getEntryDate" :
                                    result.success(Converter.dateToTimestamp(
                                            entries.get((int) arguments.get("index"))
                                                    .date));
                                    break;

                                case "deleteEntry" :
                                    entry_db.entryDao()
                                            .delete(entries.get(
                                                    (int) arguments.get("index")
                                            ));
                                    break;

                                case "categorySum" :
                                    result.success(entries.stream()
                                            .filter(entry -> entry.category == strToCategory(
                                                    (String) arguments.get("category")))
                                            .filter(entry -> entry.type == strToType(
                                                    (String) arguments.get("type")))
                                            .map(entry -> entry.amount)
                                            .reduce(Double::sum)
                                            .orElse(0.0));
                                    break;

                                case "getInitValueSum" :
                                    result.success(accounts.stream()
                                            .map(a -> a.value)
                                            .reduce(Double::sum)
                                            .orElse(0.0));
                                    break;

                                case "getInitialValue" :
                                    result.success(accByName(
                                            (String) arguments.get("account"))
                                            .value);
                                    break;
                            }
                            reload();
                        }
                );
    }

    private void addEntry(Map<String, Object> arguments) {
        //* title
        String title = (String) arguments.get("title");

        //* type
        Type type = strToType(
                (String) arguments.get("type"));

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
        Account account = accByName((String) arguments.get("account"));

        //* account2
        Account account2 = accByName((String) arguments.get("account2"));
        if (arguments.get("account2").equals("#")) account2.name = "#";

        //*category
        Category category = strToCategory(
                (String) arguments.get("category"));

        entry_db.entryDao().InsertAll(
                new Entry(title, type, amount, date,
                        account, account2, category));
    }

    private Account accByName(String name) {
        for (Account ac : accounts)
            if (ac.name.equals(name))
                return ac;
        return new Account("!!!", -1);
    }

    private Type strToType(String typeStr) {
        Type type = Type.INCOME;
        switch (typeStr) {
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
        return type;
    }

    private Category strToCategory(String categoryStr) {
        Category category = Category.OTHER;
        switch (categoryStr) {
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

            case "Full time job":
                category = Category.FULL_TIME_JOB;
                break;
            case "Part time job":
                category = Category.PART_TIME_JOB;
                break;
            case "Exploitation":
                category = Category.EXPLOITATION;
                break;
            case "Passive income":
                category = Category.PASSIVE_INCOME;
                break;

            case "Other":
                category = Category.OTHER;
                break;
        }
        return category;
    }

    private void reload() {
        accounts = account_db.accountDao().getAllAccounts();
        singleton.allAccounts = accounts;

        entries = entry_db.entryDao().getAllEntries();
        Collections.reverse(entries);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private double getValue(Account account) {
        final double[] value = {account.value};

        entries.stream()
                .filter(entry -> entry.account == account)
                .forEach(entry -> {
                    switch (entry.type) {
                        case INCOME:
                            value[0] += entry.amount;
                            break;
                        case EXPENSE:
                        case TRANSFER:
                            value[0] -= entry.amount;
                            break;
                        default:
                            throw new RuntimeException(
                                    "Unknown entry type: " + entry.type
                            );
                    }
                });
        entries.stream()
                .filter(entry -> entry.account2 == account)
                .forEach(entry -> value[0] += entry.amount);
        return value[0];
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void setValue(Account account, double finalValue) {
        final double[] value = {finalValue};

        entries.stream()
                .filter(entry -> entry.account == account)
                .forEach(entry -> {
                    switch (entry.type) {
                        case INCOME:
                            value[0] -= entry.amount;
                            break;
                        case EXPENSE:
                        case TRANSFER:
                            value[0] += entry.amount;
                            break;
                        default:
                            throw new RuntimeException(
                                    "Unknown entry type: " + entry.type
                            );
                    }
                });
        entries.stream()
                .filter(entry -> entry.account2 == account)
                .forEach(entry -> value[0] -= entry.amount);
        account.value = value[0];
    }

    @RequiresApi(api = Build.VERSION_CODES.GINGERBREAD)
    private static String toFirstLetterUpperCase(String input) {
        if (input == null || input.isEmpty()) return input;

        String lowerCaseInput = input.toLowerCase();
        String firstLetterUpperCase = lowerCaseInput.substring(0, 1).toUpperCase();
        String restOfString = lowerCaseInput.substring(1);
        String connected = firstLetterUpperCase + restOfString;
        return connected.replaceAll("_", " ");
    }
}