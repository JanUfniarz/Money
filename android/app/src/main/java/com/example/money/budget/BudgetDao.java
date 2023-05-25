package com.example.money.budget;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

@Dao
public interface BudgetDao {

    @Insert
    void InsertAll(Budget... budgets);

    @Delete
    void delete(Budget budget);

    @Update
    void updateBudgets(Budget... budgets);

    @Query("SELECT * FROM budget")
    List<Budget> getAllBudgets();

    @Query("SELECT * FROM budget WHERE id = :id")
    Budget getById(int id);
}
