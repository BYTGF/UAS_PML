// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatefulWidget {
  final Function insertCallback;

  AddItem({required this.insertCallback});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemQty = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  int currentStorage = 0;
  List<dynamic> allStorageData = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _queryStorage();
    currentStorage = 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Add Item"),
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
                      hintText: 'Item Name',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    controller: _itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Item Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: MyColors.primaryColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          items: allStorageData.map((data) {
                            int id = data["storage_id"];
                            String name = data["name"];
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (selectedID) {
                            setState(() {
                              currentStorage = int.parse(selectedID.toString());
                            });
                          },
                          hint: Text("Select Storage"),
                          value: currentStorage,
                        ),
                      )),
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
                      hintText: 'Item Quantity',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    controller: _itemQty,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Quantity';
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

  Future<void> _queryStorage() async {
    await dbHelper.ambilData();
    setState(() {
      allStorageData = dbHelper.getStorages();
    });
  }
  void _insert() async{
    String itemName = _itemName.text;
    String itemQty = _itemQty.text;

    var requestBody = {
      'itemName': itemName,
      'storageId': currentStorage.toString(), // Keep it as an int
      'itemQty': itemQty,
    };

    print(currentStorage.toString());

    print(requestBody);
    var url = 'https://apiuaspml.000webhostapp.com/data_add.php';
    var uri = Uri.parse(url);

    var response = await http.post(uri, body: requestBody);

    var body = response.body;

    var json = jsonDecode(body);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(json['message'])));
        print("1");
    if (json['success'] == 1) {
      widget.insertCallback(); // Call the callback function from ItemList
      Navigator.of(context).pop();
    }
  }
  // void _insert() async {
  //   try {
  //     int quantity = int.parse(_itemQty.text);

  //     Map<String, dynamic> row = {
  //       DatabaseHelper.columnName: _itemName.text,
  //       DatabaseHelper.columnStorage: currentStorage,
  //       DatabaseHelper.columnQty: quantity,
  //     };

  //     if (allStorageID.isNotEmpty) {
  //       currentStorage = allStorageID[0];
  //     }

  //     final id = await dbHelper.insertItem(row);
  //     if (kDebugMode) {
  //       print('inserted row id: $id');
  //     }

  //     widget.insertCallback(); // Call the callback function from ItemList
  //     Navigator.of(context).pop();
  //     _queryStorage();
  //   } catch (e) {
  //     print('Error inserting item: $e');
  //     // Handle the error as needed
  //   }
  // }

  // void _queryStorage() async {
  //   final allRows = await dbHelper.queryAllRowsStorage();
  //   if (kDebugMode) {
  //     print('query all rows:');
  //   }
  //   for (var element in allRows) {
  //     allStorageID.add(element["_id"]);
  //     allStorageName.add(element["name"]);

  //     categoryMap[element["_id"]] = element["name"];
  //   }
  //   setState(() {});
  // }
}
