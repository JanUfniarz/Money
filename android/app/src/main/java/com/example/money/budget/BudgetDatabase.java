package com.example.money.budget;

import androidx.room.Database;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;

import com.example.money.Converter;

@Database(
        entities = {Budget.class},
        version = 2,
        exportSchema = false)
@TypeConverters({Converter.class})
public abstract class BudgetDatabase extends RoomDatabase {
    public abstract BudgetDao budgetDao();
}