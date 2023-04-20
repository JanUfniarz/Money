import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money/widgets/entry_card.dart';

import '../widgets/balance_card.dart';
import '../palette.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

    for (int index = 0; index < count! && index < 5; index++) {
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
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        title: Text(
          "Money",
          style: TextStyle(
            color: Palette.font,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const BalanceCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Divider(
              color: Palette.accent,
              thickness: 2,
            ),
          ),
          Center(
            child: Text(
              "Add new:",
              style: TextStyle(
                color: Palette.font,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                NewEntryButton(type: "Income"),
                NewEntryButton(type: "Expense"),
                NewEntryButton(type: "Transfer")
              ],
            ),
          ),
          Center(
            child: Text(
              "Entries:",
              style: TextStyle(
                color: Palette.font,
                fontSize: 25,
              ),
            ),
          ),
          Card(
            color: Palette.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: entryCards
            ),
          ),
          SizedBox(
            width: 90,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.accent,
              ),
              child: Text(
                "See all",
                style: TextStyle(
                  color: Palette.background,
                  fontSize: 15,
                ),
             ),
            ),
          ),
        ],
      ),
    );
  }

  //# GTP
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

class NewEntryButton extends StatelessWidget {
  const NewEntryButton({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {

          await Navigator.pushNamed(
            context,
            "/add_entry",
            arguments: type,
          );

          Navigator.pushReplacementNamed(context, "/home");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.main2,
        ),
        child: Text(
          type,
          style: TextStyle(
            color: Palette.background,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}