import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String? selectedAccount;
  String? selectedCategory;
  String? type;
  String? tittle;
  double? amount;

  //! List<String> accountNames = [];
  List<DropdownMenuItem<dynamic>> accountNames = [];

  List<String> categories = [
    "Basic expenditure",
    "Enterprise",
    "Travelling",
    "House",
    "Health and beauty",
    "Transport",
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
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text("Add $type"),
        centerTitle: true,
        backgroundColor: Palette.main2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Tittle',
                filled: true,
                fillColor: Palette.textField,
              ),
              onChanged: (text) => tittle = text,
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
              value: selectedCategory,
              items: categoriesDMI,
              onChanged: (item) => setState(() => selectedCategory = item),
              isExpanded: true,
              style: TextStyle(
                  color: Palette.textField,
                  fontSize: 25
              ),
            ),
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
}