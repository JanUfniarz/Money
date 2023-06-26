package com.example.money.budget;

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
import com.example.money.entry.EntryDatabase;
import com.example.money.enums.Category;
import com.example.money.enums.Interval;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("ConstantConditions")
@Database(
        entities = {Budget.class},
        version = 2,
        exportSchema = false)
@TypeConverters({Converter.class})
public abstract class BudgetDatabase extends RoomDatabase implements Storable {
    public abstract BudgetDao budgetDao();

    private static BudgetDatabase instance;

    public static BudgetDatabase getInstance(Context context) {
        if (instance == null)
            instance = Room.databaseBuilder(
                            context, BudgetDatabase.class, "Budget_database")
                    .allowMainThreadQueries().build();
        return instance;
    }

    public static BudgetDatabase getInstance() {
        if (instance == null)
            throw new RuntimeException("No instance, provide context!");
        return instance;
    }

    @SuppressLint("SimpleDateFormat")
    @Override
    public void add(Map<String, Object> arguments) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            budgetDao().InsertAll(new Budget(
                    (String) arguments.get("title"),
                    (double) arguments.get("amount"),
                    Category.valueOf(
                            ((String) arguments.get("category"))
                                    .toUpperCase()
                                    .replaceAll(" ", "_")
                    ),
                    Interval.valueOf(
                            ((String) arguments.get("interval"))
                                    .toUpperCase()
                                    .replaceAll(" ", "_")
                    ),
                    dateFormat.parse((String) arguments.get("startDate")),
                    dateFormat.parse((String) arguments.get("endDate"))
            ));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(Map<String, Object> arguments) {
        budgetDao().delete(
                budgetList().get((int) arguments.get("index")));
    }

    @Override
    public void update(String details, Map<String, Object> arguments) {
        Budget budget = budgetList().get((int) arguments.get("index"));

        switch (details) {

            case "pin":
                budget.pin();
                break;

            case "startDate" :
                budget.startDate = (Date) arguments.get("newStartDate");
                break;

            case "endDate" :
                budget.endDate = (Date) arguments.get("newEndDate");
                break;
        }
        budgetDao().updateBudgets(budget);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public Object get(String details, Map<String, Object> arguments) {

        Budget budget = new Budget(null, 0, null,
                null, null, null);

        if (arguments != null) if (arguments.get("index") != null) {
            budget = budgetList().get((int) arguments.get("index"));
            cycleDate(budget);
        }

        switch (details) {
            default: return null;

            case "length" : return budgetList().size();

            case "title" : return budget.title;

            case "category" : return MainActivity.toFirstLetterUpperCase(
                    budget.category.toString());

            case "amount" : return budget.amount;

            case "actualAmount" :
                Budget[] temp = {budget};
                EntryDatabase.entryList().stream()
                        .filter(e -> e.date.compareTo(temp[0].startDate) >= 0)
                        .filter(e -> e.category == temp[0].category)
                        .forEach(e -> temp[0].amount -= e.amount);
                return temp[0].amount;

            case "endDate" : return Converter.dateToTimestamp(budget.endDate);

            case "pinned" : return budget.pinned;
        }
    }

    void cycleDate(Budget budget) {
        if (budget.interval != Interval.NONE && new Date().after(budget.endDate)) {
            Map<String, Object> arguments = new HashMap<>();

            arguments.put("newStartDate", budget.endDate);

            Calendar calendar = Calendar.getInstance();
            calendar.setTime(budget.endDate);

            switch (budget.interval) {

                case YEAR:
                    calendar.add(Calendar.YEAR, 1);
                    break;

                case MONTH:
                    calendar.add(Calendar.MONTH, 1);
                    break;

                case WEEK:
                    calendar.add(Calendar.WEEK_OF_YEAR, 1);
                    break;
            }
            arguments.put("newEndDate", calendar.getTime());

            update("startDate", arguments);
            update("endDate", arguments);
        }
    }

    public static List<Budget> budgetList() {
        return getInstance().budgetDao().getAllBudgets();
    }
}