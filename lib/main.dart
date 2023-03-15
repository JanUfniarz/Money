import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xff162b16),
        title: Text(
          "Money",
          style: TextStyle(
            color: Color(0xff86f786),
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add
        ),
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