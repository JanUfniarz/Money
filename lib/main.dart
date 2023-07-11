import 'package:flutter/material.dart';
import 'package:money/views/account_view.dart';
import 'package:money/views/add_accout.dart';
import 'package:money/views/add_budget.dart';
import 'package:money/views/add_entry.dart';
import 'package:money/widgets/my_scaffold.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => const MyScaffold.full(picked: 0),
    "/add_account" : (context) => const AddAccount(),
    "/account_view" : (context) => const AccountView(),
    "/add_entry" : (context) => const AddEntry(),
    "/all_entries" : (context) => const MyScaffold.full(picked: 2),
    "/all_accounts" : (context) => const MyScaffold.full(picked: 1),
    "/budgets" : (context) => const MyScaffold.full(picked: 3),
    "/add_budget" : (context) => const AddBudget(),
  },
));