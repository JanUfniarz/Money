import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:money/widgets/date_picker.dart';
import '../palette.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  // values to send
  String? title;
  String? type;
  double? amount;
  RestorableDateTime selectedDate = RestorableDateTime(DateTime.now());
  String? selectedAccount;
  String? selectedCategory;

  List<DropdownMenuItem<dynamic>> accountNames = [];

  List<String> categories = [
    "Basic expenditure",
    "Enterprise",
    "Travelling",
    "House",
    "Health and beauty",
    "Transport",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _getAccNames();
  }

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem<dynamic>> categoriesDMI = categories
        .map((String item) {
      return DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      );
    }).toList();

    selectedAccount ??= accountNames.first.value;
    selectedCategory ??= categoriesDMI.first.value;
    type = ModalRoute.of(context)!
        .settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text(
          "Add $type",
          style: TextStyle(
            color: Palette.background,
          ),
        ),
        centerTitle: true,
        backgroundColor: Palette.main2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'title',
                filled: true,
                fillColor: Palette.textField,
              ),
              onChanged: (text) => title = text,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Amount',
                filled: true,
                fillColor: Palette.textField,
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) => amount = double.parse(text),
            ),
            DropdownButton(
              dropdownColor: Palette.background,
              value: selectedAccount,
              items: accountNames,
              onChanged: (item) => setState(() => selectedAccount = item),
              isExpanded: true,
              style: TextStyle(
                color: Palette.textField,
                fontSize: 25
              ),
            ),
            DropdownButton(
              dropdownColor: Palette.background,
              value: selectedCategory,
              items: categoriesDMI,
              onChanged: (item) => setState(() => selectedCategory = item),
              isExpanded: true,
              style: TextStyle(
                color: Palette.textField,
                fontSize: 25
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Date:",
                  style: TextStyle(
                    color: Palette.textField,
                    fontSize: 25
                  ),
                ),
                const SizedBox(width: 10),
                DatePicker(
                  restorationId: "main",
                  selectedDate: selectedDate,
                ),
              ],
            ),
            const SizedBox(),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> arguments = {
                    "type" : type,
                    "title" : title,
                    "amount" : amount,
                    "account" : selectedAccount,
                    "category" : selectedCategory,
                    "date" : _dateToString(selectedDate),
                  };

                  channel.invokeMethod("addEntry", arguments);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.accent,
                ),
                child: Text(
                  "Add $type",
                  style: TextStyle(
                    color: Palette.background,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _getAccNames() async {
    int length = await channel.invokeMethod("getLength");
    List<String> temp = [];

    int index = 0;
    while (index < length) {
      var arguments = <String, dynamic>{
        "index" : index
      };

      String name = await channel.invokeMethod(
          "getName",
          arguments
      );

      temp.add(name);
      index++;
    }

    //# GPT
    setState(() {
      accountNames = temp.map((String item) {
        return DropdownMenuItem<dynamic>(
          value: item,
          child: Text(item),
        );
      }).toList();
    });
  }

  String _dateToString(RestorableDateTime date) {
    String res = date.value.toString();
    return res.substring(0, res.length - 13);
  }
}