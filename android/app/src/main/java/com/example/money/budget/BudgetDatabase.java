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

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiresApi(api = Build.VERSION_CODES.O)
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
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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
                LocalDate.parse((String) arguments.get("startDate"), formatter),
                LocalDate.parse((String) arguments.get("endDate"), formatter)
        ));
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
                budget.startDate = (LocalDate) arguments.get("newStartDate");
                break;

            case "endDate" :
                budget.endDate = (LocalDate) arguments.get("newEndDate");
                break;
        }
        budgetDao().updateBudgets(budget);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
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
        if (budget.interval != Interval.NONE && LocalDate.now().isAfter(budget.endDate)) {
            Map<String, Object> arguments = new HashMap<>();

            arguments.put("newStartDate", budget.endDate);

            LocalDate newEndDate;

            switch (budget.interval) {

                case YEAR:
                    newEndDate = budget.endDate.plusYears(1);
                    break;

                case MONTH:
                    newEndDate = budget.endDate.plusMonths(1);
                    break;

                case WEEK:
                    newEndDate = budget.endDate.plusWeeks(1);
                    break;

                default:
                    throw new IllegalStateException("Unexpected value: " + budget.interval);
            }

            arguments.put("newEndDate", newEndDate);

            update("startDate", arguments);
            update("endDate", arguments);
        }
    }

    public static List<Budget> budgetList() {
        return getInstance().budgetDao().getAllBudgets();
    }
}