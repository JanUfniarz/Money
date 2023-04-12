package com.example.money.entry;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.example.money.account.Account;

import java.util.Date;

//! import java.time.LocalDateTime;

@Entity(tableName = "entry")
//? @TypeConverters(Converter.class) //# GPT
public class Entry {
    @PrimaryKey(autoGenerate = true)
    public int id;

    @ColumnInfo(name = "tittle")
    public String tittle;

    @ColumnInfo(name = "type")
    public Type type;

    @ColumnInfo(name = "amount")
    public double amount;

    //! @ColumnInfo
    //! public LocalDateTime date;

    //? final String DATE_FORMAT = "yyyy-MM-dd HH:mm";
    @ColumnInfo(name = "date")
    public Date date;

    @ColumnInfo(name = "account")
    public Account account;

    @ColumnInfo(name = "category")
    public Category category;

    public Entry(String tittle,
                 Type type,
                 double amount,
                 Date date,
                 Account account,
                 Category category
    ) {
        this.tittle = tittle;
        this.type = type;
        this.amount = amount;
        this.date = date;
        this.account = account;
        this.category = category;
    }
}
