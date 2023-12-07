// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';

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
  List<int> allStorageID = [];
  List<String> allStorageName = [];
  Map<int, String> categoryMap = {};
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
                          items: categoryMap.entries.map((entry) {
                            int id = entry.key;
                            String name = entry.value;
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (selectedID) {
                            setState(() {
                              currentStorage = selectedID!;
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

  }
  void _insert() async{

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
