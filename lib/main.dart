import 'package:flutter/material.dart';
import 'package:money/views/account_view.dart';
import 'package:money/views/add_accout.dart';
import 'package:money/views/add_entry.dart';

import 'views/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => Home(),
    "/add_account" : (context) => AddAccount(),
    "/account_view" : (context) => AccountView(),
    "/add_entry" : (context) => AddEntry(),
  },
));