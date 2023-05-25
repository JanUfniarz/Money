package com.example.money.budget;

import androidx.room.Database;
import androidx.room.RoomDatabase;

@Database(entities = {Budget.class}, version = 2)
public abstract class BudgetDatabase extends RoomDatabase {
    public abstract BudgetDao budgetDao();
}
