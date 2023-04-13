import 'package:flutter/material.dart';
import 'package:money/palette.dart';

import 'package:flutter/services.dart';

class AccountView extends StatefulWidget {

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  String? name;
  double? value;
  int? index;

  String? newName;
  double? newValue;

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!
        .settings.arguments as Map<String, dynamic>;

    name ??= arguments['name'];
    value ??= arguments['value'];
    index = arguments['index'];

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        backgroundColor: Palette.main,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
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
                    color: Palette.font,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "$value",
                  style: TextStyle(
                    color: Palette.accent,
                    fontSize: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Divider(
                    color: Palette.accent,
                    thickness: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //* Change Name
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Palette.main,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom
                                ),
                                child: SizedBox(
                                  height: 300,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          "Change Name",
                                          style: TextStyle(
                                            color: Palette.font,
                                            fontSize: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 30,
                                          ),
                                          child: Divider(
                                            color: Palette.accent,
                                            thickness: 2,
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'New Name',
                                            filled: true,
                                            fillColor: Palette.textField,
                                          ),
                                          onChanged: (text) => newName = text
                                        ),
                                        SizedBox(height: 30),
                                        SizedBox(
                                          width: 90,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              var argumentsToJava = <String, dynamic>{
                                              "index" : index,
                                              "newName" : newName,
                                              };

                                              channel.invokeMethod(
                                                "changeName",
                                                argumentsToJava,
                                              );

                                              setState(() => name = newName);
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Palette.background,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Palette.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                        },
                        child: Center(
                          child: Text(
                            "Change\nName",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.font,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.main,
                        ),
                      ),
                    ),
                    //* Change Balance
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Palette.main,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom
                                  ),
                                  child: SizedBox(
                                    height: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Text(
                                            "Change Balance",
                                            style: TextStyle(
                                              color: Palette.font,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 30,
                                            ),
                                            child: Divider(
                                              color: Palette.accent,
                                              thickness: 2,
                                            ),
                                          ),
                                          TextField(
                                              decoration: InputDecoration(
                                                hintText: 'New Balance',
                                                filled: true,
                                                fillColor: Palette.textField,
                                              ),
                                              keyboardType: TextInputType.number,
                                              onChanged: (text) => newValue = double.parse(text)
                                          ),
                                          SizedBox(height: 30),
                                          SizedBox(
                                            width: 90,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                var argumentsToJava = <String, dynamic>{
                                                  "index" : index,
                                                  "newValue" : newValue,
                                                };

                                                channel.invokeMethod(
                                                  "changeValue",
                                                  argumentsToJava,
                                                );

                                                setState(() => value = newValue);
                                                Navigator.pop(context);
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Save",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Palette.background,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Palette.accent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        child: Center(
                          child: Text(
                            "Change\nBalance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.font,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.main,
                        ),
                      ),
                    ),
                    //* Delete Account
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Palette.main,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                ),
                              ),
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          "Delete Account",
                                          style: TextStyle(
                                            color: Palette.font,
                                            fontSize: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 30,
                                          ),
                                          child: Divider(
                                            color: Palette.accent,
                                            thickness: 2,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 90,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {

                                                    var argumentsToJava = <String, dynamic>{
                                                      "index" : index,
                                                    };

                                                    channel.invokeMethod(
                                                      "deleteAccount",
                                                      argumentsToJava
                                                    );

                                                    Navigator.popUntil(context, (route) => route.isFirst);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Delete",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Palette.font,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Palette.delete,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Center(
                                                    child: Text(
                                                      "Cancel",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Palette.background,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Palette.accent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: Palette.font,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.delete,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}