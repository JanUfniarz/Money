import 'package:flutter/material.dart';

import '../widgets/balance_card.dart';
import '../palette.dart';

class Home extends StatefulWidget {

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                SizedBox(
                  width: 90,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {

                      String type = "Income";

                      await Navigator.pushNamed(
                        context,
                        "/add_entry",
                        arguments: type,
                      );
                    },
                    child: Text(
                      "Income",
                      style: TextStyle(
                        color: Palette.font,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.main2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {

                      String type = "Expense";

                      await Navigator.pushNamed(
                        context,
                        "/add_entry",
                        arguments: type,
                      );
                    },
                    child: Text(
                      "Expense",
                      style: TextStyle(
                        color: Palette.font,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.main2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {

                      String type = "Transfer";

                      await Navigator.pushNamed(
                        context,
                        "/add_entry",
                        arguments: type,
                      );
                    },
                    child: Text(
                      "Transfer",
                      style: TextStyle(
                        color: Palette.font,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.main2,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}