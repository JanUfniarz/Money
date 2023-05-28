import 'package:flutter/material.dart';

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

  static Future<dynamic> goAllEntries(BuildContext context, {Object? arguments}) =>
      _go(context, _allEntries, arguments: arguments);

  static Future<dynamic> goBudgets(BuildContext context, {Object? arguments}) =>
      _go(context, _budgets, arguments: arguments);

  static Future<dynamic> goHere(BuildContext context) =>
      Navigator.pushReplacementNamed(
      context,
      (ModalRoute.of(context)?.settings)?.name ?? _home
  );

  static Future<dynamic> pushAddEntry(
      BuildContext context, 
      {Object? arguments}
      ) => _push(context, _addEntry, arguments: arguments);
  
  static Future<dynamic> pushAccountView(
      BuildContext context, 
      {Object? arguments}
      ) => _push(context, _accountView, arguments: arguments);

  static Future<dynamic> pushAddAccount(BuildContext context) => 
      _push(context, _addAccount);

  static Future<dynamic> pushAddBudget(BuildContext context) =>
      _push(context, _addBudget);

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
}