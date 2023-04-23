import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../palette.dart';
import '../widgets/balance_card.dart';
import 'all_entries.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(
                  context,
                  "/all_entries",
              );
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: EntriesTable(
              numberOfEntries: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class NewEntryButton extends StatelessWidget {
  const NewEntryButton({Key? key, required this.type}) : super(key: key);

  final String type;

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {

          int accountCount =
            await channel.invokeMethod("getLength");

          if (accountCount != 0) {
            await Navigator.pushNamed(
              context,
              "/add_entry",
              arguments: type,
            );
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Add an account first"),
            ));
          }

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