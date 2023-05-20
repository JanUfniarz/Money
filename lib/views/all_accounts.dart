import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money/views/all_entries.dart';
import 'package:money/widgets/entry_card.dart';

import '../palette.dart';
import '../widgets/graph_linear.dart';
import '../widgets/navigation_bar.dart';
import 'home.dart';

class AllAccounts extends StatefulWidget {
  const AllAccounts({Key? key}) : super(key: key);

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  List<BigAccountCard> cards = [];

  @override
  void initState() {
    super.initState();
    _loadData().then((data) {
      setState(() {
        cards = data;
      });
    });
  }

  Future<List<BigAccountCard>> _loadData() async {
    List<BigAccountCard> data = [];

    int length = await channel.invokeMethod("getLength");

    for (int it = 0; it < length; it++) {
      String name = await channel.invokeMethod("getName", {"index" : it});
      data.add(BigAccountCard(name: name));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {

    if (this.cards.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Widget> cards = [];
    int index = 0;
    for (BigAccountCard card in this.cards) {
      cards.add(GestureDetector(
        onTap: () async {

          double value = await channel.invokeMethod("getValue", {"name" : card.name});

          var arguments = <String, dynamic>{
            "name" : card.name,
            "value" : value,
            "index" : index,
          };
          await Navigator.pushNamed(
            context,
            "/account_view",
            arguments: arguments,
          );
          Navigator.pushReplacementNamed(context, "/all_accounts");
        },
        child: card,
      ));
      index++;
    }

    cards.add(GestureDetector(
      onTap: () async {
        dynamic result = await Navigator
            .pushNamed(context, "/add_account");
        Map<String, dynamic> arguments = result;
        channel.invokeMethod("addAccount", arguments);
        _loadData().then((data) {
          setState(() {
            cards = data;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Palette.main2,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Palette.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Palette.accent,
                    size: 100,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        centerTitle: true,
        title: const Text("All Accounts"),
      ),
      bottomNavigationBar: const MyNavigationBar(
        picked: 1,
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}

class BigAccountCard extends StatefulWidget {

  final String name;

  const BigAccountCard({required this.name, Key? key}) : super(key: key);

  @override
  State<BigAccountCard> createState() => _BigAccountCardState();
}

class _BigAccountCardState extends State<BigAccountCard> {
  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  Map<String, dynamic> dataMap = {};

  @override
  void initState() {
    super.initState();
    _loadData().then((data) {
      setState(() {
        dataMap = data;
      });
    });
  }

  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> data = {};

    String name = widget.name;
    double value = await channel.invokeMethod("getValue", {"name" : name});

    int index = await channel
        .invokeMethod("getLastEntryIndex", {"name" : name});

    if (index < 0) {
      data.addAll({
        "name" : name,
        "value" : value,
      });
      return data;
    }

    String type = await channel
        .invokeMethod("getEntryType", {"index" : index});
    String title = await channel
        .invokeMethod("getEntryTitle", {"index" : index});
    double amount = await channel
        .invokeMethod("getEntryAmount", {"index" : index});
    String category = await channel
        .invokeMethod("getEntryCategory", {"index" : index});
    String accountName = await channel
        .invokeMethod("getEntryAccountName", {"index" : index});
    String date = await channel
        .invokeMethod("getEntryDate", {"index" : index});
    String account2Name = await channel
        .invokeMethod("getEntryAccount2Name", {"index" : index});

    date = date.replaceAll("-", ".");
    if (account2Name != "#") accountName = "$accountName -> $account2Name";

    data.addAll({
      "name" : name,
      "value" : value,
      "type" : type,
      "title" : title,
      "amount" : amount,
      "category" : category,
      "accountName" : accountName,
      "date" : date,
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {

    if (dataMap.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dataMap.length <= 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Palette.main2,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Palette.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 const SizedBox(height: 10),
                  Text(
                    dataMap["name"],
                    style: TextStyle(
                      color: Palette.font,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dataMap["value"].toString(),
                    style: TextStyle(
                      color: Palette.accent,
                      fontSize: 50,
                    ),
                  ),
                  const MyDivider(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Palette.main2,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Card(
            color: Palette.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  dataMap["name"],
                  style: TextStyle(
                    color: Palette.font,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dataMap["value"].toString(),
                  style: TextStyle(
                    color: Palette.accent,
                    fontSize: 50,
                  ),
                ),
                const MyDivider(),
                LinearGraph(account: dataMap["name"]),
                Text(
                  "Last Entry",
                  style: TextStyle(
                    color: Palette.font,
                    fontSize: 20,
                  ),
                ),
                DateBar(date: dataMap["date"]),
                EntryCard(
                  type: dataMap["type"],
                  title: dataMap["title"],
                  amount: dataMap["amount"],
                  category: dataMap["category"],
                  accountName: dataMap["accountName"],
                  date: dataMap["date"],
                  index: -1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}