import 'package:flutter/material.dart';

import '../palette.dart';

class BudgetCard extends StatefulWidget {



  const BudgetCard({Key? key}) : super(key: key);

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {

  final List<String> _list = [
    "You have left:", "To be used until:",
    "150.50", "23.05.2023", // TODO
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Palette.accent,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Card(
            color: Palette.background,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // TODO
                      },
                      child: Icon(
                        Icons.pin_end,
                        size: 40,
                        color: Palette.accent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Tittle", //TODO
                        style: TextStyle(
                          color: Palette.font,
                          fontSize: 35
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // TODO
                      },
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Palette.delete,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Category", //TODO
                  style: TextStyle(
                    color: Palette.main2,
                    fontSize: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Divider(
                    color: Palette.main2,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(2, (index) =>
                      Column(
                        children: <Widget>[
                          Text(
                            _list[index],
                            style: TextStyle(
                              color: Palette.accent,
                              fontSize: 17
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _list[index + 2],
                            style: TextStyle(
                                color: Palette.font,
                                fontSize: 30
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SizedBox(
                      width: 260,
                      height: 30,
                      child: LinearProgressIndicator(
                        value: 0.75, // Wartość procentowa (0.0 - 1.0) TODO
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Palette.main),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}