package com.example.money.budget;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.example.money.enums.Category;
import com.example.money.enums.Interval;

import java.time.LocalDate;

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

    @ColumnInfo(name = "startDate")
    public LocalDate startDate;

    @ColumnInfo(name = "endDate")
    public LocalDate endDate;

    @ColumnInfo(name = "pinned")
    public boolean pinned = false;

    public Budget(String title, double amount,
                  Category category, Interval interval,
                  LocalDate startDate, LocalDate endDate) {
        this.title = title;
        this.amount = amount;
        this.category = category;
        this.interval = interval;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public void pin() {
        pinned = !pinned;
    }
}