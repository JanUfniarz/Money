// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:money/palette.dart';
import 'package:money/views/all_accounts.dart';
import 'package:money/views/all_entries.dart';
import 'package:money/views/budgets.dart';
import 'package:money/views/home.dart';

class NavDirector {
  static const String _home = "/home";
  static const String _addAccount = "/add_account";
  static const String _accountView = "/account_view";
  static const String _addEntry = "/add_entry";
  static const String _allEntries = "/all_entries";
  static const String _allAccounts = "/all_accounts";
  static const String _budgets = "/budgets";
  static const String _addBudget = "/add_budget";

  static dynamic back(BuildContext context, {Object? arguments}) =>
      arguments != null ? Navigator.pop(context, arguments) : Navigator.pop(context);

  static dynamic backToBottom(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  static Future<dynamic> goHome(BuildContext context) =>
      _go(context, _home);

  static Future<dynamic> goAllAccounts(BuildContext context) =>
      _go(context, _allAccounts);

  static Future<dynamic> goAllEntries(BuildContext context,
      {int? filter, String? filterKey}
      ) =>
      _go(context, _allEntries, arguments: {
        "filter" : filter,
        "filterKey" : filterKey,
      });

  static Future<dynamic> goBudgets(BuildContext context) =>
      _go(context, _budgets);
  
  static void goHere(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<Home>() != null) goHome(context);
    else if (context.findAncestorWidgetOfExactType<AllAccounts>() != null) goAllAccounts(context);
    else if (context.findAncestorWidgetOfExactType<AllEntries>() != null) goAllEntries(context);
    else if (context.findAncestorWidgetOfExactType<Budgets>() != null) goBudgets(context);
  }

  static Future<dynamic> pushAddEntry(
      BuildContext context, 
      {required String type}
      ) => _push(context, _addEntry, arguments: {"type": type});
  
  static Future<dynamic> pushAccountView(
      BuildContext context, 
      {required String name, required double value, required int index}
      ) =>
      _push(context, _accountView, arguments: {
        "name": name,
        "value": value,
        "index": index
      });

  static Future<dynamic> pushAddAccount(BuildContext context) => 
      _push(context, _addAccount);

  static Future<dynamic> pushAddBudget(
      BuildContext context,
      {bool? isPeriodic}
      ) =>
      _push(context, _addBudget, arguments: {"isPeriodic" : isPeriodic});

  static Future<dynamic> _go(
      BuildContext context,
      String route,
      {Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
    context,
    route,
        (Route<dynamic> route) => false,
    arguments: arguments,
  );

  static Future<dynamic> _push(
      BuildContext context,
      String route,
      {Object? arguments}) => Navigator.pushNamed(
    context,
    route,
    arguments: arguments,
  );

  static Map<String, dynamic> fromRoute(BuildContext context) =>
      ModalRoute.of(context)!
          .settings.arguments as Map<String, dynamic>;

  static bool argumentsAreAvailable(BuildContext context) {
    /// This line protects from back() error
    if (ModalRoute.of(context)!
        .settings.arguments == null) return false;
    return fromRoute(context).values.any((val) => val != null);
  }

  static Future<dynamic> bottomSheet(
      BuildContext context,
      Widget? child,
      ) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Palette.main,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets.bottom
        ),
        child: SizedBox(
            height: 300,
            child: child,
        ),
      ),
  );
}