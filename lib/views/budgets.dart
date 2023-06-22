import 'package:flutter/material.dart';

import '../invoker.dart';
import '../widgets/budget_card.dart';

class Budgets extends StatefulWidget {
  const Budgets({Key? key}) : super(key: key);

  @override
  State<Budgets> createState() => BudgetsState();
}

class BudgetsState extends State<Budgets> {

  List<BudgetCard> budgetCards = [];

  @override
  void initState() {
    loadData().then((data) {
      setState(() {
        budgetCards = data;
      });
    });
    super.initState();
  }

  static Future<List<BudgetCard>> loadData() async =>
      List.generate(
          await Invoker.lengthOfBudgets(),
              (index) => BudgetCard(index: index));

  @override
  Widget build(BuildContext context) {
    return budgetCards.isEmpty
          ?  const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: budgetCards,
    );
  }
}