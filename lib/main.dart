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
      appBar: AppBar(
        title: Text("Money"),
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
          BalanceCard(
              accountsValues: [1040.20, 2000.00]
          ),
        ],
      ),
    );
  }
}