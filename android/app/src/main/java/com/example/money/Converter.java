package com.example.money;

import androidx.room.TypeConverter;

import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Converter {
    private static final String DATE_FORMAT = "yyyy-MM-dd";

    //* Date
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
        if (id == -1) return new Account("#", -1);

        for (Account it : AccountDatabase.getInstance().accountDao().getAllAccounts())
            if (it.id == id) return it;

        return new Account(
                "Deleted",
                -1);
    }

    @TypeConverter
    public static int accountToId(Account account) {
        if (account.name.equals("#")) return -1;
        return account.id;
    }
}
