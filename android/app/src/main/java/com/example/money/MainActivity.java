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
    private  List<Entry> entries = new ArrayList<>();

    private final Singleton singleton = Singleton.getInstance();

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

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
                                    String res = String.valueOf(
                                            accounts.stream()
                                            .map(this::getValue)
                                            .reduce(Double::sum).orElseThrow());
                                    result.success(res);
                                    break;

                                case "getName":
                                    String name = (accounts
                                            .get((int) arguments.get("index")))
                                            .name;
                                    result.success(name);
                                    break;

                                case "getValue":
                                    Account accountToGetValue = accounts
                                            .get((int) arguments.get("index"));
                                    double value = getValue(accountToGetValue);
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
                                    //! Not working
                                    // TODO make reverse getValue
                                    Account toChangeV = accounts.get((int) arguments.get("index"));
                                    toChangeV.value = (double) arguments.get("newValue");
                                    account_db.accountDao().updateAccounts(toChangeV);
                                    break;

                                case "deleteAccount":
                                    account_db.accountDao().delete(
                                            accounts.get((int) arguments.get("index")));
                                    break;

                                case "addEntry":
                                    //* title
                                    String title = (String) arguments.get("title");

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
                                        if (ac.name.equals(arguments.get("account")))
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
                                            new Entry(title, type, amount, date, account, category));

                                    break;

                                case "getLengthOfEntries" :
                                    int len2 = entries.size();
                                    result.success(len2);
                                    break;

                                case "getEntryType" :
                                    String entryType = toFirstLetterUpperCase(
                                            entries.get((int) arguments.get("index"))
                                                    .type.toString());
                                    result.success(entryType);
                                    break;

                                case "getEntryTitle" :
                                    String entryTitle =
                                            entries.get((int) arguments.get("index"))
                                                    .title;
                                    result.success(entryTitle);
                                    break;

                                case "getEntryAmount" :
                                    double entryAmount =
                                            entries.get((int) arguments.get("index"))
                                                    .amount;
                                    result.success(entryAmount);
                                    break;

                                case "getEntryCategory" :
                                    String entryCategory = toFirstLetterUpperCase(
                                            entries.get((int) arguments.get("index"))
                                                    .category.toString());
                                    result.success(entryCategory);
                                    break;

                                case "getEntryAccountName" :
                                    String entryAccountName =
                                            entries.get((int) arguments.get("index"))
                                                    .account.name;
                                    result.success(entryAccountName);
                                    break;

                                case "getEntryDate" :
                                    String entryDate = Converter.dateToTimestamp(
                                            entries.get((int) arguments.get("index"))
                                                    .date);
                                    result.success(entryDate);
                                    break;

                                case "deleteEntry" :
                                    entry_db.entryDao()
                                            .delete(entries.get(
                                                    (int) arguments.get("index")
                                            ));
                                    break;
                            }
                            reload(account_db, entry_db);
                        }
                );
    }

    private void reload(AccountDatabase account_db,
                        EntryDatabase entry_db) {
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
                            value[0] -= entry.amount;
                            break;
                        case TRANSFER:
                            // TODO implement transfer
                            break;
                        default:
                            throw new RuntimeException(
                                    "Unknown entry type: " + entry.type
                            );
                    }
                });
        return value[0];
    }

    private static String toFirstLetterUpperCase(String input) {
        if (input == null || input.isEmpty()) return input;

        String lowerCaseInput = input.toLowerCase();
        String firstLetterUpperCase = lowerCaseInput.substring(0, 1).toUpperCase();
        String restOfString = lowerCaseInput.substring(1);
        String connected = firstLetterUpperCase + restOfString;
        return connected.replaceAll("_", " ");
    }
}