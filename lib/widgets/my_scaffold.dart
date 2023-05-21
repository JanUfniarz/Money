import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class MyScaffold extends StatefulWidget {

  final String title;
  final int picked;
  final Widget body;

  const MyScaffold({Key? key, title, picked, required this.body})
      : title = title ?? "Money",
        picked = picked ?? 0,
        super(key: key);

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Palette.font,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: MyNavigationBar(
        picked: widget.picked,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MyFAB(),
      body: widget.body,
    );
  }
}


class MyFAB extends StatelessWidget {
  const MyFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO implement
      },
      backgroundColor: Palette.accent,
      child: Icon(
        Icons.add,
        color: Palette.background,
      ),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  final int picked;

  const MyNavigationBar({Key? key, required this.picked}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  final List<IconData> _icons = [
    Icons.home,
    Icons.account_balance,
    Icons.exposure,
    Icons.savings,
  ];

  final List<String> _labels = [
    "Home",
    "Accounts",
    "Entries",
    "Budgets",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.main, // Set your desired background color here
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
              (index) => InkWell(
            onTap: () {
              String route = "";

              switch (index) {
                case 0: route = "/home"; break;
                case 1: route = "/all_accounts"; break;
                case 2: route = "/all_entries"; break;
                case 3: /* TODO connect budgets route */ break;
              }

              Navigator.pushNamedAndRemoveUntil(
                context,
                route,
                    (Route<dynamic> route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[index],
                    color: index == widget.picked
                        ? Palette.main2
                        : Palette.font,
                  ),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: index == widget.picked
                          ? Palette.main2
                          : Palette.font,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}