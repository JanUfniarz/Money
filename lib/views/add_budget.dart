import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {

  // Values to be send
  String? title;
  double? amount;
  String? category;
  String? interval;

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
    "None",
    "Week",
    "Month",
    "Year",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
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

            ),
          ],
        ),
      ),
    );
  }
}