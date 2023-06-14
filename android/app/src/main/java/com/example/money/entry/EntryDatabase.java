package com.example.money.entry;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;

import com.example.money.Converter;
import com.example.money.MainActivity;
import com.example.money.Storable;
import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;
import com.example.money.enums.Category;
import com.example.money.enums.Type;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
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

    @SuppressLint("SimpleDateFormat")
    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void add(Map<String, Object> arguments) {
        try {
            entryDao().InsertAll(
                    new Entry(
                            (String) arguments.get("title"),
                            Type.valueOf(
                                    ((String) arguments.get("type"))
                                            .toUpperCase()
                                            .replaceAll(" ", "_")),
                            (double) arguments.get("amount"),
                            new SimpleDateFormat("yyyy-MM-dd").parse(
                                    (String) arguments.get("date")),
                            AccountDatabase.accByName((String) arguments.get("account")),
                            arguments.get("account2").equals("#")
                                    ? new Account("#", -1)
                                    : AccountDatabase.accByName(
                                            (String) arguments.get("account2")),
                            Category.valueOf(
                                    ((String) arguments.get("category"))
                                            .toUpperCase()
                                            .replaceAll(" ", "_"))
                    ));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(Map<String, Object> arguments) {
        entryDao().delete(
                entryDao().getAllEntries()
                        .get((int) arguments.get("index")));
    }

    @Override
    public void update(String details, Map<String, Object> arguments) {

    }

    @Override
    public Object get(String details, Map<String, Object> arguments) {
        List<Entry> entries = entryDao().getAllEntries();
        Entry entry = new Entry(null, null,  0, null,
                null, null, null);
        if (arguments.get("index") != null)
            entry = entries.get((int) arguments.get("index"));

        switch (details) {
            default:
                return null;

            case "length" :
                return entries.size();

            case "type" :
                return MainActivity.toFirstLetterUpperCase(
                        entry.type.toString());

            case "title" :
                return entry.title;

            case "amount" :
                return entry.amount;
                
        }
    }
}