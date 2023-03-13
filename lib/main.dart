import 'package:flutter/material.dart';

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
    );
  }
}