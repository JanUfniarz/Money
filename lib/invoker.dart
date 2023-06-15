import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Invoker {
  static const _channel = MethodChannel(
      "com.flutter.Invoker/MainActivity"
  );

  static String? _fromDate(RestorableDateTime? date) {

    //? final restorableDateTime = RestorableDateTime(DateTime.now());
    //? restorableDateTime.registerRestoreInformation('main');


    return date?.value
        .toString()
        .substring(0, date.value
        .toString()
        .length - 13);
  }

  static Future<dynamic> addAccount(String? name, double? value) =>
      _channel.invokeMethod("account/add/#", {
        "name" : name,
        "value" : value,
      });

  static Future<dynamic> balanceSum() =>
      _channel.invokeMethod("account/get/balanceSum");

  static Future<dynamic> name(int? index) =>
      _channel.invokeMethod("account/get/name", {
        "index": index
      });

  static Future<dynamic> value({int? index, String? name}) =>
      _channel.invokeMethod("account/get/value", {
        "index" : index,
        "name" : name,
      });

  static Future<dynamic> length() =>
      _channel.invokeMethod("account/get/length");

  static Future<dynamic> changeName(int? index, String? name) =>
      _channel.invokeMethod("account/update/name", {
        "index" : index,
        "newName" : name,
      });

  static Future<dynamic> changeValue(int? index, double? value) =>
      _channel.invokeMethod("account/update/value", {
        "index" : index,
        "newValue" : value,
      });

  static Future<dynamic> deleteAccount(int? index) =>
      _channel.invokeMethod("account/delete/#", {
        "index" : index,
      });
  static Future<dynamic> addEntry(
      String? type,
      String? title,
      double? amount,
      String? account,
      String? category,
      RestorableDateTime? date,
      String? account2,
      ) => _channel.invokeMethod("entry/add/#", {
    "type" : type,
    "title" : title,
    "amount" : amount,
    "account" : account,
    "category" : category,
    "date" : _fromDate(date),
    "account2" : account2,
  });

  static Future<dynamic> lastEntryIndex(String? name) =>
      _channel.invokeMethod("entry/get/lastEntryIndex", {
        "name" : name,
      });

  static Future<dynamic> entryType(int? index) =>
      _channel.invokeMethod("entry/get/type", {
        "index" : index,
      });

  static Future<dynamic> entryTitle(int? index) =>
      _channel.invokeMethod("entry/get/title", {
        "index" : index,
      });

  static Future<dynamic> entryAmount(int? index) =>
      _channel.invokeMethod("entry/get/amount", {
        "index" : index,
      });

  static Future<dynamic> entryCategory(int? index) =>
      _channel.invokeMethod("entry/get/category", {
        "index" : index,
      });


  static Future<dynamic> entryAccountName(int? index) =>
      _channel.invokeMethod("entry/get/account", {
        "index" : index,
      });

  static Future<dynamic> entryAccount2Name(int? index) =>
      _channel.invokeMethod("entry/get/account2", {
        "index" : index,
      });// as Future<String>;

  static Future<dynamic> entryDate(int? index) =>
      _channel.invokeMethod("entry/get/date", {
        "index" : index,
      });

  static Future<dynamic> deleteEntry(int? index) =>
      _channel.invokeMethod("entry/delete/#", {
        "index" : index,
      });

  static Future<dynamic> categorySum(String? category, String? type) =>
      _channel.invokeMethod("entry/get/categorySum", {
        "category" : category,
        "type" : type,
      });

  static Future<dynamic> initValueSum() =>
      _channel.invokeMethod("account/get/initValueSum");

  static Future<dynamic> initValue(String? name) =>
      _channel.invokeMethod("account/get/initialValue", {
        "name" : name,
      });

  static Future<dynamic> lengthOfEntries() =>
      _channel.invokeMethod("entry/get/length");

  static Future<dynamic> addBudget(
      String? title, double? amount,
      String? category, String? interval,
      String? startDate,
      String? endDate,) =>
      _channel.invokeMethod("budget/add/#", {
        "title" : title,
        "amount" : amount,
        "category" : category,
        "interval" : interval,
        "startDate" : startDate,
        "endDate" : endDate,
      });

  static Future<dynamic> lengthOfBudgets() =>
      _channel.invokeMethod("budget/get/length");

  static Future<dynamic> budgetTittle(int? index) =>
      _channel.invokeMethod("budget/get/title", {
        "index" : index,
      });

  static Future<dynamic> budgetCategory(int? index) =>
      _channel.invokeMethod("budget/get/category", {
        "index" : index,
      });

  static Future<dynamic> budgetAmount(int index) =>
      _channel.invokeMethod("budget/get/amount", {
        "index" : index,
      });

  static Future<dynamic> budgetActualAmount(int index) =>
      _channel.invokeMethod("budget/get/actualAmount", {
        "index" : index,
      });

  static Future<dynamic> budgetDate(int index) =>
      _channel.invokeMethod("budget/get/endDate", {
        "index" : index,
      });

  static Future<dynamic> pin(int index) =>
      _channel.invokeMethod("budget/update/pin", {
        "index" : index,
      });

  static Future<dynamic> pinned(int index) =>
      _channel.invokeMethod("budget/get/pinned", {
        "index" : index,
      });

  static Future<dynamic> deleteBudget(int? index) =>
      _channel.invokeMethod("budget/delete/#", {
        "index" : index,
      });
}