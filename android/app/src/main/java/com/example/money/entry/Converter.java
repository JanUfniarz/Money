package com.example.money.entry;
import android.content.Context;

import androidx.room.Room;
import androidx.room.TypeConverter;

import com.example.money.AppContextSingleton;
import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Converter {
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm";

    //* Date
    //# GPT
    @TypeConverter
    public static Date fromTimestamp(String value) {
        if (value != null) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                return sdf.parse(value);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    //# GPT
    @TypeConverter
    public static String dateToTimestamp(Date date) {
        if (date != null) {
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
            return sdf.format(date);
        }
        return null;
    }

    //* Account
    @TypeConverter
    public static Account fromId(int id) {

        Context context = AppContextSingleton.getContext();

        AccountDatabase db = Room.databaseBuilder(
                        context,
                        AccountDatabase.class,
                        "Account_database")
                .allowMainThreadQueries().build();

        return db.accountDao().getById(id);
    }

    @TypeConverter
    public static int accountToId(Account account) {
        return account.id;
    }
}
