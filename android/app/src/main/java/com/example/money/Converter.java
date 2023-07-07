package com.example.money;

import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.room.TypeConverter;

import com.example.money.account.Account;
import com.example.money.account.AccountDatabase;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@RequiresApi(api = Build.VERSION_CODES.O)
public class Converter {

    private static final DateTimeFormatter formatter =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    //* Date
    @TypeConverter
    public static LocalDate fromTimestamp(String value) {
        if (value != null) return LocalDate.parse(value, formatter);
        return null;
    }

    @TypeConverter
    public static String dateToTimestamp(LocalDate date) {
        return date.format(formatter);
    }

    //* Account
    @TypeConverter
    public static Account fromId(int id) {
        if (id == -1) return new Account("#", -1);

        for (Account it : AccountDatabase.accountList())
            if (it.id == id) return it;

        return new Account("Deleted", -1);
    }

    @TypeConverter
    public static int accountToId(Account account) {
        if (account.name.equals("#")) return -1;
        return account.id;
    }
}
