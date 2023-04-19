import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class AddAccount extends StatelessWidget {

  String? name;
  double? value;

  AddAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        title: const Text("Add Account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Name',
                filled: true,
                fillColor: Palette.textField,
              ),
              onChanged: (text) => name = text,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Balance',
                filled: true,
                fillColor: Palette.textField,
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) => value = double.parse(text),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                color: Palette.accent,
                thickness: 2,
              ),
            ),
            SizedBox(
              width: 90,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, <String, dynamic>{
                    "name": name,
                    "value": value,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.accent,
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Palette.background,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
