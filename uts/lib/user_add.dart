// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'db_manager.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userDate = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  int currentuser = 0;
  List<int> alluserID = [];
  List<String> alluserName = [];
  Map<int, String> categoryMap = {};
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _queryuser();
    currentuser = 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Add User"),
        ),
        body: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: MyColors.primaryColor, width: 1.0),
                      ),
                      hintText: 'User Name',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    controller: _userName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lo Lupa Nama Lo Bang?';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: MyColors.primaryColor, width: 1.0),
                      ),
                      hintText: ' Tanggal Lahir',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    controller: _userDate,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi Tanggal Lahir';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButtonTheme(
                    data: TextButtonThemeData(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MyColors.primaryColor),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formGlobalKey.currentState!.validate()) {
                          _insert();
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnUsername: _userName.text,
      DatabaseHelper.columnDate: _userDate.text,

      // DatabaseHelper.columnProfile: base64image,
    };
    print('insert stRT');
    if (alluserID.isNotEmpty) {
      currentuser = alluserID[0];
    }

    final id = await dbHelper.insertUsers(row);
    if (kDebugMode) {
      print('inserted row id: $id');
    }
    Navigator.of(context).pop();
    _queryuser();
  }

  void _queryuser() async {
    final allRows = await dbHelper.queryAllRowsUser();
    if (kDebugMode) {
      print('query all rows:');
    }
    for (var element in allRows) {
      alluserID.add(element["_id"]);
      alluserName.add(element["name"]);

      categoryMap[element["_id"]] = element["name"];
    }

    print(alluserID);
    print(alluserName);
    setState(() {});
  }
}