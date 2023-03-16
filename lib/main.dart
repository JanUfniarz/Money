import 'package:flutter/material.dart';
import 'package:money/add_accout.dart';
import 'package:money/my_color.dart';
import 'balance_card.dart';
import 'home.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/home",
  routes: {
    "/home" : (context) => Home(),
    "/add_account" : (context) => AddAccount(),
  },
));