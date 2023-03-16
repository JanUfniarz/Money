import 'package:flutter/material.dart';
import 'package:money/my_color.dart';

class AddAccount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(
        backgroundColor: MyColor.main,
        title: Text("Add Account"),
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
                fillColor: MyColor.textField,
              ),
              onChanged: (text) {
                //TODO Handle the text input here
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Balance',
                filled: true,
                fillColor: MyColor.textField,
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                //TODO Handle the text input here
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                color: MyColor.accent,
                thickness: 2,
              ),
            ),
            SizedBox(
              width: 90,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: MyColor.background,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: MyColor.accent,
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
