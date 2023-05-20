import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class MyNavigationBar extends StatefulWidget {

  final int picked;

  const MyNavigationBar({Key? key, required this.picked}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.picked,
      backgroundColor: Palette.main,
      selectedItemColor: Palette.main2,
      unselectedItemColor: Palette.font,
      onTap: (int index) {

        String route = "";

        switch (index) {
          case 0 : route = "/home"; break;
          case 1 : route = "/all_accounts"; break;
          case 2 : route = "/all_entries"; break;
        }

        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
              (Route<dynamic> route) => false,
        );

      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: "Accounts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exposure),
          label: "Entries",
        ),
      ],
    );
  }
}