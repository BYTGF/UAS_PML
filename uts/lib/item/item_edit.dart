// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';


class EditItem extends StatefulWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _storageName = TextEditingController();
  final TextEditingController _itemQty = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  int currentStorage = 0;
  List<int> allStorageID = [];
  List<String> allStorageName = [];
  final dbHelper = DatabaseHelper.instance;


  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Edit Item"),
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
                            items: allStorageID.asMap().entries.map((entry) {
                              int index = entry.key;
                              int id = entry.value;
                              String name = allStorageName[index];
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
                        )
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
                              _update();
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

  void _update() async {

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _itemName.text,
      DatabaseHelper.columnStorage: _storageName.text,
      DatabaseHelper.columnQty: _itemQty.text,
      // DatabaseHelper.columnProfile: base64image,
    };
    print('insert stRT');
    currentStorage = 0;

    final id = await dbHelper.updateItem(row);
    if (kDebugMode) {
      print('updated row id: $id');
    }
    Navigator.of(context).pop();
    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRowsStorage();
    if (kDebugMode) {
      print('query all rows:');
    }
    for (var element in allRows) {
      allStorageID.add(element["_id"]);
      allStorageName.add(element["name"]);
    }
    setState(() {});
  }
}
