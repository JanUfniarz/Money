import 'package:flutter/material.dart';
import 'package:money/views/account_view.dart';
import 'package:money/views/add_accout.dart';
import 'package:money/views/add_budget.dart';
import 'package:money/views/add_entry.dart';
import 'package:money/views/all_accounts.dart';
import 'package:money/views/all_entries.dart';
import 'package:money/views/budgets.dart';

import 'views/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => const Home(),
    "/add_account" : (context) => const AddAccount(),
    "/account_view" : (context) => const AccountView(),
    "/add_entry" : (context) => const AddEntry(),
    "/all_entries" : (context) => const AllEntries(),
    "/all_accounts" : (context) => const AllAccounts(),
    "/budgets" : (context) => const Budgets(),
    "/add_budget" : (context) => const AddBudget(),
  },
));