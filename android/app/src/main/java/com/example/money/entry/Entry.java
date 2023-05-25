package com.example.money.entry;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.example.money.account.Account;

import java.util.Date;

@Entity(tableName = "entry")
//? @TypeConverters(Converter.class)
public class Entry {
    @PrimaryKey(autoGenerate = true)
    public int id;

    @ColumnInfo(name = "title")
    public String title;

    @ColumnInfo(name = "type")
    public Type type;

    @ColumnInfo(name = "amount")
    public double amount;

    @ColumnInfo(name = "date")
    public Date date;

    @ColumnInfo(name = "account")
    public Account account;

    @ColumnInfo(name = "account2")
    public Account account2;

    @ColumnInfo(name = "category")
    public Category category;

    public Entry(String title,
                 Type type,
                 double amount,
                 Date date,
                 Account account,
                 Account account2,
                 Category category
    ) {
        this.title = title;
        this.type = type;
        this.amount = amount;
        this.date = date;
        this.account = account;
        this.account2 = account2;
        this.category = category;
    }
}
