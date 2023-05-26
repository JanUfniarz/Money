package com.example.money.entry;

import androidx.room.Database;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;
@Database(
        entities = {Entry.class},
        version = 2,
        exportSchema = false)
@TypeConverters({Converter.class})
public abstract class EntryDatabase extends RoomDatabase {
    public abstract EntryDao entryDao();
}
