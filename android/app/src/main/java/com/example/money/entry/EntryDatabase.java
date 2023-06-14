package com.example.money.entry;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;

import com.example.money.Converter;
import com.example.money.Storable;

import java.util.Map;

@Database(
        entities = {Entry.class},
        version = 2,
        exportSchema = false)
@TypeConverters({Converter.class})
public abstract class EntryDatabase extends RoomDatabase implements Storable {
    public abstract EntryDao entryDao();

    private static EntryDatabase instance;

    public static EntryDatabase getInstance(Context context) {
        if (instance == null)
            instance = Room.databaseBuilder(
                            context, EntryDatabase.class, "Entry_database")
                    .allowMainThreadQueries().build();
        return instance;
    }

    public static EntryDatabase getInstance() {
        if (instance == null)
            throw new RuntimeException("No instance, provide context!");
        return instance;
    }

    @Override
    public void add(Map<String, Object> arguments) {

    }

    @Override
    public void delete(Map<String, Object> arguments) {

    }

    @Override
    public void update(String details, Map<String, Object> arguments) {

    }

    @Override
    public Object get(String details, Map<String, Object> arguments) {
        return null;
    }
}