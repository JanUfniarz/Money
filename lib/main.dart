import 'package:flutter/material.dart';
import 'package:money/views/account_view.dart';
import 'package:money/views/add_accout.dart';
import 'package:money/views/add_entry.dart';
import 'package:money/views/all_entries.dart';

import 'views/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => const Home(),
    "/add_account" : (context) => AddAccount(),
    "/account_view" : (context) => const AccountView(),
    "/add_entry" : (context) => const AddEntry(),
    "/all_entries" : (context) => const AllEntries(),
  },
));