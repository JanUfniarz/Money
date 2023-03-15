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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: MyColor.greenDark,
        title: Text(
          "Money",
          style: TextStyle(
            color: MyColor.greenLight,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add
        ),
        backgroundColor: MyColor.orchid,
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