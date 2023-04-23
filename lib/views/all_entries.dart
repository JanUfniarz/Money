import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../palette.dart';
import '../widgets/entry_card.dart';
//? import 'home.dart';

class AllEntries extends StatefulWidget {
  const AllEntries({Key? key}) : super(key: key);

  @override
  State<AllEntries> createState() => _AllEntriesState();
}

class _AllEntriesState extends State<AllEntries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        centerTitle: true,
        title: const Text("All Entries"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: EntriesTable(),
            ),
          ],
        ),
      ),
    );
  }
}

class EntriesTable extends StatefulWidget {

  int? numberOfEntries;
  EntriesTable({Key? key, this.numberOfEntries})
      : super(key: key);

  @override
  State<EntriesTable> createState() => _EntriesTableState();
}

class _EntriesTableState extends State<EntriesTable> {

  int entriesCount = 0;
  List<Widget> entryCards = [];

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final count = await channel.invokeMethod<int>("getLengthOfEntries");
    final cards = <Widget>[];

    cards.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        LabelBox(label: "Amount"),
        LabelBox(label: "Date"),
        LabelBox(label: "Title"),
        LabelBox(label: "Account"),
        LabelBox(label: "Category"),
      ],
    ));

    for (
    int index = 0;
    index < count! && index < (widget.numberOfEntries ?? count);
    index++) {
      final arguments = {"index": index};
      final type = await channel.invokeMethod("getEntryType", arguments);
      final title = await channel.invokeMethod("getEntryTitle", arguments);
      final amount = await channel.invokeMethod("getEntryAmount", arguments);
      final category = await channel.invokeMethod("getEntryCategory", arguments);
      final accountName = await channel.invokeMethod("getEntryAccountName", arguments);
      final date = await channel.invokeMethod("getEntryDate", arguments);

      cards.add(EntryCard(
        type: type,
        title: title,
        amount: amount,
        category: category,
        accountName: accountName,
        date: _convertStringToDate(date),
      ));
    }

    setState(() {
      entriesCount = count;
      entryCards = cards;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Palette.background,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: entryCards,
        ),
    );
  }

  RestorableDateTime _convertStringToDate(String dateString) {
    // Split the date string by "-" to get year, month, and day
    List<String> dateParts = dateString.split("-");

    // Extract year, month, and day from dateParts
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Create a RestorableDateTime object with the parsed year, month, and day
    RestorableDateTime restorableDateTime = RestorableDateTime(
        DateTime(year, month, day)
    );

    return restorableDateTime;
  }
}

class LabelBox extends StatelessWidget {
  const LabelBox({
    super.key, required this.label
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ItemBox(
      color: Palette.main,
      child: Text(
        label,
        style: TextStyle(
            color: Palette.accent
        ),
      ),
    );
  }
}