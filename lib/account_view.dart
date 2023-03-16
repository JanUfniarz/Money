import 'package:flutter/material.dart';
import 'package:money/my_color.dart';

class AccountView extends StatefulWidget {

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  String? name;
  double? value;

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!
        .settings.arguments as Map<String, dynamic>;

    name = arguments['name'];
    value = arguments['value'];

    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        backgroundColor: MyColor.main,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "$name",
                style: TextStyle(
                  color: MyColor.font,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "$value",
                style: TextStyle(
                  color: MyColor.accent,
                  fontSize: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Divider(
                  color: MyColor.accent,
                  thickness: 2,
                ),
              ),
              NameChanger(),
            ],
          ),
        ),
      ),
    );
  }
}

class NameChanger extends StatefulWidget {

  @override
  State<NameChanger> createState() => _NameChangerState();
}

class _NameChangerState extends State<NameChanger> {

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    if (isClicked) {
      return Row();
    } else {
      return SizedBox(
        width: 90,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Text(
              "Change\nName",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColor.font,
                fontSize: 15,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.main,
          ),
        ),
      );
    }
  }
}

