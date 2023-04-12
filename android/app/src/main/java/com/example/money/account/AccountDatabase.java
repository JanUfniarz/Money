package com.example.money.account;

import androidx.room.Database;
import androidx.room.RoomDatabase;

//# YT
@Database(entities = {Account.class}, version = 2)
public abstract class AccountDatabase extends RoomDatabase {
    public abstract AccountDao accountDao();
}