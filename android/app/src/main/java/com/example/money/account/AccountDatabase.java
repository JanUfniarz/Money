package com.example.money.account;

import static com.example.money.enums.Type.*;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.example.money.Storable;

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
                accountDao().getAllAccounts()
                        .get((int) arguments.get("index")));
    }

    @Override
    public void update(String details, Map<String, Object> arguments) {

    }

    @Override
    public Object get(String details, Map<String, Object> arguments) {

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
}