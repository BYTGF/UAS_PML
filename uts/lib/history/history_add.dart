// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;


class AddHistory extends StatefulWidget {
  const AddHistory({Key? key}) : super(key: key);

  @override
  _AddHistoryState createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  String? selectedStatus;
  final TextEditingController _historyQty = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  int currentItem = 0;
  List<int> allItemID = [];
  List<String> allItemName = [];
  Map<int, String> itemMap = {};
  final dbHelper = DatabaseHelper.instance;

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD

  @override
  void initState() {
    super.initState();
    _query();
    currentItem = 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Add History"),
        ),
        body: 
            SizedBox(
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MyColors.primaryColor),
                        ),
                        child:DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            items: itemMap.entries.map((entry) {
                              int id = entry.key;
                              String name = entry.value;
                              return DropdownMenuItem<int>(
                                value: id,
                                child: Text(name),
                              );
                            }).toList(),
                            onChanged: (selectedID) {
                              setState(() {
                                currentItem = selectedID!;
                              });
                            },
                            hint: Text("Select Item"),
                            value: currentItem,
                          ),
                        )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Status: '),
                          Radio<String>(
                            value: 'In',
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          Text('In'),
                          Radio<String>(
                            value: 'Out',
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          Text('Out'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
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
                        controller: _historyQty,
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

  Future<void> _query() async {

  }
  void _insert() async{

  }

  // void _insert() async {
    
  //   int quantity = int.parse(_historyQty.text);

  //   Map<String, dynamic> row = {
  //     DatabaseHelper.columnItem: currentItem,
  //     DatabaseHelper.columnStatus: selectedStatus,
  //     DatabaseHelper.columnQty: quantity,
  //     // DatabaseHelper.columnProfile: base64image,
  //   };
  //   print('insert stRT');
  //   if (allItemID.isNotEmpty) {
  //     currentItem = allItemID[0];
  //   }

  //   final id = await dbHelper.insertHistory(row);
  //   if (kDebugMode) {
  //     print('inserted row id: $id');
  //   }
  //   _query();
  //   Navigator.of(context).pop();
  // }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsItem();
  //   if (kDebugMode) {
  //     print('query all rows:');
  //   }
  //   for (var element in allRows) {
  //     allItemID.add(element["itemId"]);
  //     allItemName.add(element["itemName"]);

  //     itemMap[element["itemId"]] = element["itemName"];
  //   }
  //   setState(() {});
  // }
}
