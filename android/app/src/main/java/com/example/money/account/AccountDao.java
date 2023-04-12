package com.example.money.account;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import com.example.money.account.Account;

import java.util.List;

@Dao
public interface AccountDao {

    @Insert
    void InsertAll(Account... accounts);

    @Delete
    void delete(Account account);

    @Update
    void updateAccounts(Account... accounts);

    @Query("SELECT * FROM Account")
    List<Account> getAllAccounts();
}