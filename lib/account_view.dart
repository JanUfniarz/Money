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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: MyColor.main,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                            color: MyColor.font,
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
                                            color: MyColor.accent,
                                            thickness: 2,
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'New Name',
                                            filled: true,
                                            fillColor: MyColor.textField,
                                          ),
                                          onChanged: (text) {}
                                        ),
                                        SizedBox(height: 30),
                                        SizedBox(
                                          width: 90,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: MyColor.background,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColor.accent,
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
                              color: MyColor.font,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.main,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Change\nBallance",
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
                    ),
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: MyColor.font,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.delete,
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

