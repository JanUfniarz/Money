import 'package:flutter/material.dart';
import 'package:money/widgets/my_scaffold.dart';

import '../widgets/budget_card.dart';

class Budgets extends StatefulWidget {
  const Budgets({Key? key}) : super(key: key);

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "Budgets",
      picked: 3,
      body: ListView(
        children: <Widget>[
          BudgetCard(

          ),
        ],
      )
    );
  }
}