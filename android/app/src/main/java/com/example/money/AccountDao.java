package com.example.money;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface AccountDao {

    @Insert
    public void InsertAll(Account... accounts);

    @Query("SELECT * FROM Account")
    List<Account> getAllAccounts();
}
