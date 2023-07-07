package com.example.money.entry;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
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

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RequiresApi(api = Build.VERSION_CODES.O)
@SuppressWarnings("ConstantConditions")
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

    @RequiresApi(api = Build.VERSION_CODES.O)
    @SuppressLint("SimpleDateFormat")
//?    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void add(Map<String, Object> arguments) {
//?        try {
            entryDao().InsertAll(
                    new Entry(
                            (String) arguments.get("title"),
                            Type.valueOf(
                                    ((String) arguments.get("type"))
                                            .toUpperCase()
                                            .replaceAll(" ", "_")),
                            (double) arguments.get("amount"),
//?                            new SimpleDateFormat("yyyy-MM-dd").parse(
//?                                    (String) arguments.get("date")),
                            LocalDate.parse((String) arguments.get("date"),
                                    DateTimeFormatter.ofPattern("yyyy-MM-dd")),
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
//?        } catch (ParseException e) {
//?            throw new RuntimeException(e);
//?        }
    }

    @Override
    public void delete(Map<String, Object> arguments) {
        entryDao().delete(entryList().get((int) arguments.get("index")));
    }

    @Override
    public void update(String details, Map<String, Object> arguments) {}

//?    @RequiresApi(api = Build.VERSION_CODES.N)
    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public Object get(String details, Map<String, Object> arguments) {
        Entry entry = new Entry(null, null,  0, null,
                null, null, null);
        String name = "";

        if (arguments != null) {
            if (arguments.get("index") != null)
                entry = entryList().get((int) arguments.get("index"));

            if (arguments.get("name") != null)
                name = (String) arguments.get("name");
        }

        switch (details) {
            default : return null;

            case "length" : return entryList().size();

            case "type" : return MainActivity.toFirstLetterUpperCase(
                        entry.type.toString());

            case "title" : return entry.title;

            case "amount" : return entry.amount;

            case "category" : return MainActivity.toFirstLetterUpperCase(
                        entry.category.toString());

            case "account" : return entry.account.name;

            case "account2" : return entry.account2.name;

            case "date" : return Converter.dateToTimestamp(entry.date);

            case "categorySum" : return entryList().stream()
                    .filter(e -> e.category == Category.valueOf(
                            ((String) arguments.get("category"))
                                    .toUpperCase()
                                    .replaceAll(" ", "_")))
                    .filter(e -> e.type == Type.valueOf(
                            ((String) arguments.get("type"))
                                    .toUpperCase()
                                    .replaceAll(" ", "_")))
                    .map(e -> e.amount)
                    .reduce(Double::sum)
                    .orElse(0.0);

            case "lastIndex" :
                int lastEntryIndex = -1;
                for (int it = 0; it < entryList().size(); it++)
                    if (entryList().get(it).account.name.equals(name)
                            || entryList().get(it).account2.name.equals(name))
                        lastEntryIndex = it;
                return lastEntryIndex;
        }
    }

    public static List<Entry> entryList() {
        List<Entry> list = getInstance().entryDao().getAllEntries();
        Collections.reverse(list);
        return list;
    }

    @NonNull
    @Override
    public String toString() {

        String[] str = {"EntryDatabase:\n============"};

        entryList().forEach(entry -> str[0] = str[0].concat(
                "\nEntry: " + entry.title
                + "\n\ttype: " + entry.type + "\n\tamount: "
                + entry.amount + "\n\taccount: " + entry.account.name));

        return str[0];
    }
}