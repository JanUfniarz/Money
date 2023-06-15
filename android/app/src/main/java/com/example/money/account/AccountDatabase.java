package com.example.money.account;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.example.money.Storable;
import com.example.money.entry.Entry;
import com.example.money.entry.EntryDatabase;

import java.util.List;
import java.util.Map;

@Database(
        entities = {Account.class},
        version = 2,
        exportSchema = false)
public abstract class AccountDatabase extends RoomDatabase implements Storable {
    public abstract AccountDao accountDao();

    private static AccountDatabase instance;

    public static AccountDatabase getInstance(Context context) {
        if (instance == null)
            instance = Room.databaseBuilder(
                context, AccountDatabase.class, "Account_database")
                .allowMainThreadQueries().build();
        return instance;
    }

    public static AccountDatabase getInstance() {
        if (instance == null)
            throw new RuntimeException("No instance, provide context!");
        return instance;
    }

    @Override
    public void add(Map<String, Object> arguments) {
        accountDao().InsertAll(new Account(
                (String) arguments.get("name"),
                (double) arguments.get("value")
        ));
    }

    @Override
    public void delete(Map<String, Object> arguments) {
        accountDao().delete(
                accountList().get((int) arguments.get("index")));
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void update(String details, Map<String, Object> arguments) {

        Account account = new Account(null, 0);

        if (accountList().get((int) arguments.get("index")) != null)
            account = accountList().get((int) arguments.get("index"));

        switch (details) {

            case "name" :
                account.name = (String) arguments.get("newName");
                accountDao().updateAccounts(account);
                break;

            case "value" :
                setValue(account,
                        (double) arguments.get("newValue"));
                accountDao().updateAccounts(account);
                break;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public Object get(String details, Map<String, Object> arguments) {

        Account account = new Account(null, 0);

        if (accountList().get((int) arguments.get("index")) != null)
            account = accountList().get((int) arguments.get("index"));

        if (arguments.get("name") != null)
            account = accByName((String) arguments.get("name"));

        switch (details) {

            default: return null;

            case "balanceSum" :
                return String.valueOf(
                        accountList().stream()
                                .map(this::getValue)
                                .reduce(Double::sum)
                                .orElseThrow());

            case "name" : return account.name;

            case "value" : return getValue(account);

            case "length" : return accountList().size();

            case "initialValueSum" :
                return accountList().stream()
                        .map(a -> a.value)
                        .reduce(Double::sum)
                        .orElse(0.0);

            case "initialValue" : return account.value;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private double getValue(Account account) {

        final double[] value = {account.value};

        entries().stream()
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
        entries().stream()
                .filter(entry -> entry.account2 == account)
                .forEach(entry -> value[0] += entry.amount);
        return value[0];
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void setValue(Account account, double finalValue) {
        final double[] value = {finalValue};

        entries().stream()
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
        entries().stream()
                .filter(entry -> entry.account2 == account)
                .forEach(entry -> value[0] -= entry.amount);
        account.value = value[0];
    }

    private List<Entry> entries() {
        return EntryDatabase.getInstance().entryDao().getAllEntries();
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static Account accByName(String name) {
        return getInstance().accountDao()
                .getAllAccounts().stream()
                .filter(ac -> ac.name.equals(name))
                .findFirst()
                .orElse(new Account("!!!", -1));
    }

    private List<Account> accountList() {
        return accountDao().getAllAccounts();
    }

}