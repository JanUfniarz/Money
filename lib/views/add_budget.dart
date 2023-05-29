import 'package:flutter/material.dart';
import 'package:money/nav_director.dart';
import 'package:money/palette.dart';

import '../invoker.dart';
import '../widgets/date_picker.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {

  bool periodic = true;

  // Values to be send
  String? title;
  double? amount;
  String? category;
  String? interval;
  RestorableDateTime? endDate;
  RestorableDateTime? startDate;

  List<String> categories = [
    "Basic expenditure",
    "Enterprise",
    "Travelling",
    "House",
    "Health and beauty",
    "Transport",
    "Other",
  ];

  List<String> intervals = [
    //"None",
    "Week",
    "Month",
    "Year",
  ];

  List<DropdownMenuItem<dynamic>> _dmi(List<String> list) =>
      list.map((String item) =>
        DropdownMenuItem<dynamic>(
          value: item,
          child: Text(item),
      )).toList();

  @override
  Widget build(BuildContext context) {

    periodic = NavDirector.fromRoute(context)["periodic"];

    category ??= _dmi(categories).first.value;

    if (!periodic) interval = "None";
    interval ??= _dmi(intervals).first.value;

    endDate ??= RestorableDateTime(DateTime.now());
    startDate ??= RestorableDateTime(DateTime.now());

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main2,
        title: Text(
          "Add Budget",
          style: TextStyle(
            color: Palette.background,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'title',
                filled: true,
                fillColor: Palette.textField,
              ),
              onChanged: (text) => title = text,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Amount',
                filled: true,
                fillColor: Palette.textField,
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) => amount = double.parse(text),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Category:",
                  style: TextStyle(
                      color: Palette.accent
                  ),
                ),
                DropdownButton(
                  dropdownColor: Palette.background,
                  value: category,
                  items: _dmi(categories),
                  onChanged: (item) => setState(() => category = item),
                  isExpanded: true,
                  style: TextStyle(
                      color: Palette.textField,
                      fontSize: 25
                  ),
                ),
              ],
            ),
            periodic
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Interval:",
                  style: TextStyle(
                      color: Palette.accent
                  ),
                ),
                DropdownButton(
                  dropdownColor: Palette.background,
                  value: interval,
                  items: _dmi(intervals),
                  onChanged: (item) => setState(() => interval = item),
                  isExpanded: true,
                  style: TextStyle(
                      color: Palette.textField,
                      fontSize: 25
                  ),
                ),
              ],
            )
                :  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Final date:",
                  style: TextStyle(
                      color: Palette.textField,
                      fontSize: 25
                  ),
                ),
                const SizedBox(width: 10),
                DatePicker(
                  restorationId: "main",
                  selectedDate: endDate!,
                  toBudget: true,
                ),
              ],
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print(
                    "title: $title\namount: $amount\ncategory: "
                        "$category\ninterval: $interval\ndate: $endDate"
                  );
                  //Invoker.addBudget(title, amount, category, interval,startDate, endDate);
                  NavDirector.back(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.accent,
                ),
                child: Text(
                  "Add Budget",
                  style: TextStyle(
                    color: Palette.background,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}