import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money/widgets/entry_card.dart';

import '../widgets/balance_card.dart';
import '../palette.dart';

class Home extends StatefulWidget {

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
    // TODO: implement initState
    super.initState();

    _count();
    _upList();
    //! setState(() {
    //!    entryCards = _upList() as List<Widget>;
    //! });
  }

  @override
  Widget build(BuildContext context) {
    _count();
    _upList();

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BalanceCard(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
          // EntryCard(
          //   type: 'Expense',
          //   tittle: 'tytuł',
          //   amount: 43.99,
          //   category: 'Travelling',
          //   accountName: 'konto',
          //   date: RestorableDateTime(DateTime.now()),
          // ),
          Card(
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
                backgroundColor: Palette.main2,
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

  void _count() async
      => setState(() async
        => entriesCount = await channel.invokeMethod("getLengthOfEntries"));

  void _upList() async {

    int numberOfWidgets = entriesCount >= 5 ? 5 : entriesCount;
    List<Widget> res = [];

    int index = 0;
    while (index < numberOfWidgets) {

      Map<String, dynamic> arguments = {
        "index" : index,
      };

      Map<String, dynamic> data = await channel
          .invokeMethod("getEntryData", arguments);

      res.add(EntryCard(
        type: data["type"],
        tittle: data["tittle"],
        amount: data["amount"],
        category: data["category"],
        accountName: data["accountName"],
        date: _convertStringToDate(data["date"]),
      ));

      index++;
    }
    setState(() => entryCards = res);
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
    RestorableDateTime restorableDateTime = RestorableDateTime(DateTime(year, month, day));

    return restorableDateTime;
  }
}

class NewEntryButton extends StatelessWidget {
  NewEntryButton({Key? key, required this.type}) : super(key: key);

  String type;

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
        child: Text(
          "$type",
          style: TextStyle(
            color: Palette.background,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.main2,
        ),
      ),
    );
  }
}