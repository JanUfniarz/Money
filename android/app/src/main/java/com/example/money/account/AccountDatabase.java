package com.example.money.account;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import com.example.money.account.Account;
import com.example.money.account.AccountDao;

@Database(entities = {Account.class}, version = 1)
public abstract class AccountDatabase extends RoomDatabase {
    public abstract AccountDao accountDao();
}