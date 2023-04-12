package com.example.money.account;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

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

    @Query("SELECT * FROM Account WHERE id = :id")
    Account getById(int id);
}