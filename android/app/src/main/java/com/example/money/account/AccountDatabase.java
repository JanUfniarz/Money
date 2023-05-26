package com.example.money.account;

import androidx.room.Database;
import androidx.room.RoomDatabase;

@Database(
        entities = {Account.class},
        version = 2,
        exportSchema = false)
public abstract class AccountDatabase extends RoomDatabase {
    public abstract AccountDao accountDao();
}