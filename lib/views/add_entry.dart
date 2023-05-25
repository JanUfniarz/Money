import 'package:flutter/material.dart';

import 'package:money/widgets/date_picker.dart';
import '../invoker.dart';
import '../palette.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {

  // values to send
  String? title;
  String? type;
  double? amount;
  RestorableDateTime selectedDate = RestorableDateTime(DateTime.now());
  String? selectedAccount;
  String? selectedCategory;

  String? accountToTransfer;

  List<DropdownMenuItem<dynamic>> accountNames = [];

  List<String> exCategories = [
    "Basic expenditure",
    "Enterprise",
    "Travelling",
    "House",
    "Health and beauty",
    "Transport",
    "Other",
  ];

  List<String> inCategories = [
    "Full time job",
    "Part time job",
    "Exploitation",
    "Passive income",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _loadData().then((res) {
      setState(() {
        accountNames = res;
      });
    });
  }

  Future<List<DropdownMenuItem<dynamic>>> _loadData() async {
    int length = await Invoker.length();
    List<String> temp = [];

    int index = 0;
    while (index < length) {
      String name = await Invoker.name(index);

      temp.add(name);
      index++;
    }

    return temp.map((String item) {
      return DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  String _dateToString(RestorableDateTime date) {
    String res = date.value.toString();
    return res.substring(0, res.length - 13);
  }

  List<DropdownMenuItem<dynamic>> _dmi(List<String> list) {
    return list.map((String item) {
      return DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    if (accountNames.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    type = ModalRoute.of(context)!
        .settings.arguments as String;

    List<DropdownMenuItem<dynamic>> categoriesDMI = type == "Expense"
                      ? _dmi(exCategories)
                      : _dmi(inCategories);

    selectedAccount ??= accountNames.first.value;
    selectedCategory ??= categoriesDMI.first.value;
    if (type == "transfer") {
      accountToTransfer ??= accountNames.elementAt(1).value;
    }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  type == "Transfer" ? "From:" : "Account:",
                  style: TextStyle(
                    color: Palette.accent
                  ),
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
              ],
            ),
            type == "Transfer"
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "to:",
                      style: TextStyle(
                          color: Palette.accent
                      ),
                    ),
                    DropdownButton(
                      dropdownColor: Palette.background,
                      value: accountToTransfer,
                      items: accountNames,
                      onChanged: (item) => setState(() => accountToTransfer = item),
                      isExpanded: true,
                      style: TextStyle(
                          color: Palette.textField,
                          fontSize: 25
                      ),
                    ),
                  ],
                )
                : const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Category:",
                  style: TextStyle(
                      color: Palette.accent
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
              ],
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
                  Invoker.addEntry(type, title, amount,
                      selectedAccount, selectedCategory,
                      _dateToString(selectedDate),
                      type == "Transfer" ? accountToTransfer : "#");

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
}