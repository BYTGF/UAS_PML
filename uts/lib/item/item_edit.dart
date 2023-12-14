// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;


class EditItem extends StatefulWidget {
  final int id;
  final String itemName;
  final int storageId;
  final int itemQty;
  final int supplierId;
  final Function insertCallback;
  

  EditItem({required this.id, required this.itemName, required this.supplierId,required this.storageId,required this.itemQty,required this.insertCallback, Key? key,}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemQty = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  late int currentStorage;
  late int currentSupplier;
  List<dynamic> allStorageData = [];
  List<dynamic> allSupplierData = [];
  bool _isMounted = false;
  final dbHelper = DatabaseHelper.instance;
  
  
  @override
  void initState() {
    super.initState();
    _queryStorage();
    _itemName.text = widget.itemName;
    _itemQty.text = widget.itemQty.toString();
    currentStorage = widget.storageId;
    currentSupplier = widget.supplierId;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Update Item"),
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
                      enabled: false,
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
                          value: currentStorage != null && allStorageData.any((data) => data["storage_id"] == currentStorage) ? currentStorage : null,
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
                    enabled: false,
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
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: MyColors.primaryColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          items: allSupplierData.map((data) {
                            int id = data["supplier_id"];
                            String name = data["supplier_name"];
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (selectedID) {
                            setState(() {
                              currentSupplier = int.parse(selectedID.toString());
                            });
                          },
                          hint: Text("Select Supplier"),
                          value: currentSupplier != null && allSupplierData.any((data) => data["supplier_id"] == currentSupplier) ? currentSupplier : null,
                        ),
                      )),
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

  Future<void> _queryStorage() async {
    await dbHelper.ambilData();
    setState(() {
      allStorageData = dbHelper.getStorages();
      allSupplierData = dbHelper.getSuppliers();
    });
    
  }
  void _update() async{

    var requestBody = {
      'itemId': widget.id.toString(),
      'storageId': currentStorage.toString(),
      'supplierId': currentSupplier.toString(), // Keep it as an int
    };

    print(currentStorage.toString());

    print(requestBody);
    var url = 'https://apiuaspml.000webhostapp.com/data_update.php';
    var uri = Uri.parse(url);

    var response = await http.post(uri, body: requestBody);

    var body = response.body;

    var json = jsonDecode(body);

    if (_isMounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json['message'])));
    }

    if (_isMounted && json['success'] == 1) {
      widget.insertCallback();
      Navigator.of(context).pop();
    }
  }

  // void _update() async {

  //   // row to insert
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.columnName: _itemName.text,
  //     DatabaseHelper.columnStorage: _storageName.text,
  //     DatabaseHelper.columnQty: _itemQty.text,
  //     // DatabaseHelper.columnProfile: base64image,
  //   };
  //   print('insert stRT');
  //   currentStorage = 0;

  //   final id = await dbHelper.updateItem(row);
  //   if (kDebugMode) {
  //     print('updated row id: $id');
  //   }
  //   Navigator.of(context).pop();
  //   _query();
  // }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsStorage();
  //   if (kDebugMode) {
  //     print('query all rows:');
  //   }
  //   for (var element in allRows) {
  //     allStorageID.add(element["_id"]);
  //     allStorageName.add(element["name"]);
  //   }
  //   setState(() {});
  // }
}
