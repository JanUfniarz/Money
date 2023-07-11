import 'package:flutter/material.dart';
import 'package:money/nav_director.dart';
import 'package:money/palette.dart';

import '../invoker.dart';
import '../widgets/my_scaffold.dart';

class AddAccount extends StatefulWidget {


  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  String? name;

  double? value;

  String alert = "";

  @override
  Widget build(BuildContext context) {
    return MyScaffold.basic(
      title: "Add Account",
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
                onPressed: () async {
                  if (name == null || value == null) {
                    setState(() => alert = "Fields cannot be empty");
                  } else {
                    int accountCount = await Invoker.length();
                    bool isNameTaken = false;

                    for(int index = 0; index < accountCount; index++) {
                      String accName = await Invoker.name(index);
                      if (accName == name) isNameTaken = true;
                    }
                    if (isNameTaken) {
                      setState(() => alert = "This name is already used");
                    } else {
                      NavDirector.back(context, arguments: <String, dynamic>{
                        "name": name,
                        "value": value,
                      });
                    }
                  }
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
            SizedBox(
              height: 80,
              child: Text(
                alert,
                style: TextStyle(
                  color: Palette.delete,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
