package com.example.money.entry;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

@Dao
public interface EntryDao {

    @Insert
    void InsertAll(Entry... entries);

    @Delete
    void delete(Entry entry);

    @Update
    void updateAccounts(Entry... entries);

    @Query("SELECT * FROM Entry")
    List<Entry> getAllEntries();

    @Query("SELECT * FROM Entry WHERE id = :id")
    Entry getById(int id);
}
