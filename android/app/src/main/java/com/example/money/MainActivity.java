package com.example.money;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.room.Room;

import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;
import com.example.money.budget.Budget;
import com.example.money.budget.BudgetDatabase;
import com.example.money.enums.Interval;
import com.example.money.enums.Category;
import com.example.money.entry.Entry;
import com.example.money.entry.EntryDatabase;
import com.example.money.enums.Type;

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
    private static final String CHANNEL = "com.flutter.Invoker/MainActivity";

    private List<Account> accounts = new ArrayList<>();
    private AccountDatabase account_db;
    private  List<Entry> entries = new ArrayList<>();
    private EntryDatabase entry_db;
    private List<Budget> budgets = new ArrayList<>();
    private BudgetDatabase budget_db;

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

        budget_db = Room.databaseBuilder(
                        getApplicationContext(),
                        BudgetDatabase.class,
                        "Budget_database")
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
                                    result.success(getValue(arguments.get("index") != null
                                            ? accounts.get((int) arguments.get("index"))
                                            : accByName((String) arguments.get("name"))));
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
                                    try {
                                        entry_db.entryDao().InsertAll(
                                                new Entry(
                                                        (String) arguments.get("title"),
                                                        Type.valueOf(
                                                                ((String) arguments.get("type"))
                                                                        .toUpperCase()
                                                                        .replaceAll(" ", "_")),
                                                        (double) arguments.get("amount"),
                                                        new SimpleDateFormat("yyyy-MM-dd")
                                                                .parse((String) arguments.get("date")),
                                                        accByName((String) arguments.get("account")),
                                                        arguments.get("account2").equals("#")
                                                                ? new Account("#", -1)
                                                                : accByName((String) arguments.get("account2")),
                                                        Category.valueOf(
                                                                ((String) arguments.get("category"))
                                                                        .toUpperCase()
                                                                        .replaceAll(" ", "_"))
                                                ));
                                    } catch (ParseException e) {
                                        throw new RuntimeException(e);
                                    }
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
                                            .filter(entry -> entry.category == Category.valueOf(
                                                    ((String) arguments.get("category"))
                                                            .toUpperCase()
                                                            .replaceAll(" ", "_")))
                                            .filter(entry -> entry.type == Type.valueOf(
                                                    ((String) arguments.get("type"))
                                                            .toUpperCase()
                                                            .replaceAll(" ", "_")))
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

                                case "getLastEntryIndex" :
                                    int lastEntryIndex = -1;
                                    for (int it = 0; it < entries.size(); it++)
                                        if (entries.get(it).account.name.equals(
                                                (String) arguments.get("name"))
                                                || entries.get(it).account2.name.equals(
                                                        (String) arguments.get("name")))
                                            lastEntryIndex = it;
                                    result.success(lastEntryIndex);
                                    break;

                                case "addBudget":
                                    try {
                                        budget_db.budgetDao().InsertAll(new Budget(
                                                (String) arguments.get("title"),
                                                (double) arguments.get("amount"),
                                                Category.valueOf(
                                                        ((String) arguments.get("category"))
                                                                .toUpperCase()
                                                                .replaceAll(" ", "_")
                                                ),
                                                Interval.valueOf(
                                                        ((String) arguments.get("interval"))
                                                                .toUpperCase()
                                                                .replaceAll(" ", "_")
                                                ),
                                                new SimpleDateFormat("yyyy-MM-dd")
                                                        .parse((String) arguments.get("date"))
                                        ));
                                    } catch (ParseException e) {
                                        throw new RuntimeException(e);
                                    }
                                    break;

                                case "getLengthOfBudgets" :
                                    result.success(budgets.size());
                                    break;

                                case "getBudgetTittle" :
                                    result.success(budgets.get((int) arguments.get("index")).title);
                                    break;

                                case "getBudgetCategory" :
                                    result.success(toFirstLetterUpperCase(budgets.get(
                                            (int) arguments.get("index")).category.toString()));
                                    break;

                                case "getBudgetAmount" :
                                    result.success(budgets.get((int) arguments.get("index")).amount);
                                    break;

                                case "getBudgetActualAmount" :
                                    // TODO write it
                                    break;

                                case "getBudgetDate" :
                                    result.success(Converter.dateToTimestamp(
                                            budgets.get((int) arguments.get("index"))
                                                    .date));
                                    break;
                            }
                            reload();
                        }
                );
    }

    private Account accByName(String name) {
        return accounts.stream()
                .filter(ac -> ac.name.equals(name))
                .findFirst()
                .orElse(new Account("!!!", -1));
    }

    private void reload() {
        accounts = account_db.accountDao().getAllAccounts();
        singleton.allAccounts = accounts;

        entries = entry_db.entryDao().getAllEntries();
        Collections.reverse(entries);

        budgets = budget_db.budgetDao().getAllBudgets();
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
        return input == null || input.isEmpty() ? input
                : (input.substring(0, 1).toUpperCase()
                    + input.substring(1).toLowerCase())
                    .replaceAll("_", " ");
    }
}