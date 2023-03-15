import 'package:flutter/material.dart';
import 'package:money/my_color.dart';
import 'balance_card.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.green,
  ),
  home: View() ,
));

class View extends StatefulWidget {

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(
        backgroundColor: MyColor.main,
        title: Text(
          "Money",
          style: TextStyle(
            color: MyColor.font,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add
        ),
        backgroundColor: MyColor.accent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BalanceCard(),
        ],
      ),
    );
  }
}