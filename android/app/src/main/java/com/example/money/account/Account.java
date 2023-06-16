package com.example.money.account;

import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.example.money.entry.EntryDatabase;

@Entity(tableName = "account")
public class Account {
    @PrimaryKey(autoGenerate = true)
    public int id;

    @ColumnInfo(name = "name")
    public String name;

    @ColumnInfo(name = "value")
    public double value;

    public Account(String name, double value) {
        this.name = name;
        this.value = value;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public double getValue() {
        Log.d("FUN", "getValue");
            //! to się dzieje

        final double[] value = {this.value};

        EntryDatabase.entryList().stream() //! jest pusta
                .filter(entry -> entry.account.equals(this))
                .forEach(entry -> {
                    Log.d("Entry", entry.title);
                        //! to już nie
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
        EntryDatabase.entryList().stream()
                .filter(entry -> entry.account2.equals(this))
                .forEach(entry -> value[0] += entry.amount);
        return value[0];
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void setValue(double finalValue) {
        final double[] value = {finalValue};

        EntryDatabase.entryList().stream()
                .filter(entry -> entry.account.equals(this))
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
                                    "Unknown entry type: " + entry.type);
                    }
                });
        EntryDatabase.entryList().stream()
                .filter(entry -> entry.account2.equals(this))
                .forEach(entry -> value[0] -= entry.amount);
        this.value = value[0];
    }
}