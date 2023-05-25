import 'package:flutter/services.dart';

class Invoker {
  static const _channel = MethodChannel(
      "com.flutter.Invoker/MainActivity"
  );

  static Future<dynamic> addAccount(String? name, double? value) =>
      _channel.invokeMethod("addAccount", {
        "name" : name,
        "value" : value,
      });

  static Future<dynamic> balanceSum() =>
      _channel.invokeMethod("balanceSum");

  static Future<dynamic> name(int? index) =>
      _channel.invokeMethod("getName", {
        "index": index
      });

  static Future<dynamic> value({int? index, String? name}) =>
      _channel.invokeMethod("getValue", {
        "index" : index,
        "name" : name,
      });

  static Future<dynamic> length() =>
      _channel.invokeMethod("getLength");

  static Future<dynamic> changeName(int? index, String? name) =>
      _channel.invokeMethod("changeName", {
        "index" : index,
        "newName" : name,
      });

  static Future<dynamic> changeValue(int? index, double? value) =>
      _channel.invokeMethod("changeValue", {
        "index" : index,
        "newValue" : value,
      });

  static Future<dynamic> deleteAccount(int? index) =>
      _channel.invokeMethod("deleteAccount", {
        "index" : index,
      });
  static Future<dynamic> addEntry(
      String? type,
      String? title,
      double? amount,
      String? account,
      String? category,
      String? date,
      String? account2,
      ) => _channel.invokeMethod("addEntry", {
    "type" : type,
    "title" : title,
    "amount" : amount,
    "account" : account,
    "category" : category,
    "date" : date,
    "account2" : account2,
  });

  static Future<dynamic> lastEntryIndex(String? name) =>
      _channel.invokeMethod("getLastEntryIndex", {
        "name" : name,
      });

  static Future<dynamic> entryType(int? index) =>
      _channel.invokeMethod("getEntryType", {
        "index" : index,
      });

  static Future<dynamic> entryTitle(int? index) =>
      _channel.invokeMethod("getEntryTitle", {
        "index" : index,
      });

  static Future<dynamic> entryAmount(int? index) =>
      _channel.invokeMethod("getEntryAmount", {
        "index" : index,
      });

  static Future<dynamic> entryCategory(int? index) =>
      _channel.invokeMethod("getEntryCategory", {
        "index" : index,
      });


  static Future<dynamic> entryAccountName(int? index) =>
      _channel.invokeMethod("getEntryAccountName", {
        "index" : index,
      });

  static Future<dynamic> entryAccount2Name(int? index) =>
      _channel.invokeMethod("getEntryAccount2Name", {
        "index" : index,
      });// as Future<String>;

  static Future<dynamic> entryDate(int? index) =>
      _channel.invokeMethod("getEntryDate", {
        "index" : index,
      });

  static Future<dynamic> deleteEntry(int? index) =>
      _channel.invokeMethod("deleteEntry", {
        "index" : index,
      });

  static Future<dynamic> categorySum(String? category, String? type) =>
      _channel.invokeMethod("categorySum", {
        "category" : category,
        "type" : type,
      });

  static Future<dynamic> initValueSum() =>
      _channel.invokeMethod("getInitValueSum");

  static Future<dynamic> initValue(String? account) =>
      _channel.invokeMethod("getInitialValue", {
        "account": account,
      });

  static Future<dynamic> lengthOfEntries() =>
      _channel.invokeMethod("getLengthOfEntries");

  static Future<dynamic> addBudget(
      String title, double amount,
      String category, String interval) =>
      _channel.invokeMethod("addBudget", {
        "title" : title,
        "amount" : amount,
        "category" : category,
        "interval" : interval,
      });
}