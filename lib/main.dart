import 'package:flutter/material.dart';
import 'package:money/account_view.dart';
import 'package:money/add_accout.dart';

import 'home.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => Home(),
    "/add_account" : (context) => AddAccount(),
    "/account_view" : (context) => AccountView(),
  },
));