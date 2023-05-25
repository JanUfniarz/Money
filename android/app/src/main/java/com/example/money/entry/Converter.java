package com.example.money.entry;

import androidx.room.TypeConverter;

import com.example.money.Singleton;
import com.example.money.account.Account;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
        Singleton singleton = Singleton.getInstance();

        List<Account> allAccounts = singleton.allAccounts;

        for (Account it : allAccounts) if (it.id == id) return it;

        return new Account(
                "Deleted",
                -1);
    }

    @TypeConverter
    public static int accountToId(Account account) {
        if (account.name == "#") return -1;
        return account.id;
    }
}
