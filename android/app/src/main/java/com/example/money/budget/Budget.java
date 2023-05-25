package com.example.money.budget;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.example.money.entry.Category;

@Entity(tableName = "budget")
public class Budget {
    @PrimaryKey(autoGenerate = true)
    public int id;

    @ColumnInfo(name = "title")
    public String title;

    @ColumnInfo(name = "amount")
    public double amount;

    @ColumnInfo(name = "category")
    public Category category;

    @ColumnInfo(name = "interval")
    public Interval interval;

    public Budget(String title, double amount,
                  Category category, Interval interval) {
        this.title = title;
        this.amount = amount;
        this.category = category;
        this.interval = interval;
    }
}