// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
// import 'dart:typed_data';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;


class AddHistory extends StatefulWidget {
  final Function insertCallback;

  AddHistory({required this.insertCallback});

  @override
  _AddHistoryState createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  int? selectedStatus;
  late int currentSupplier;
  bool _isMounted = false;
  final TextEditingController _historyQty = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  late int currentItem;
  late int currentItemQty;
  late int totalQty;
  int getFirstItemId() {
    if (allItemData.isNotEmpty) {
      // Access the first item and get its 'id'
      dynamic firstItem = allItemData[0];
      int firstItemId = firstItem['item_id'];
      return firstItemId;
    } else {
      // Handle the case when the list is empty
      return 0; // or any default value
    }
  }
  List<dynamic> allItemData = [];
  List<dynamic> allSupplierData = [];
  int getFirstSupplierId() {
    if (allSupplierData.isNotEmpty) {
      // Access the first item and get its 'id'
      dynamic firstSupplier = allSupplierData[0];
      int firstSupplierId = firstSupplier['supplier_id'];
      return firstSupplierId;
    } else {
      // Handle the case when the list is empty
      return 0; // or any default value
    }
  }
  final dbHelper = DatabaseHelper.instance;

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _query();
    currentItem = getFirstItemId();
    currentSupplier = getFirstSupplierId();
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
                          items: allItemData.map((data) {
                            int id = data["itemId"];
                            String name = data["itemName"];
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (selectedID) {
                            setState(() {
                              // Find the selected item's data in allItemData
                              Map<String, dynamic> selectedData = allItemData.firstWhere((data) => data["itemId"] == currentItem);

                              // Extract itemQty and assign it to currentItemQty
                              currentItemQty = selectedData["itemQty"];
                              currentItem = int.parse(selectedID.toString());
                            });
                          },
                            hint: Text("Select Item"),
                            value: currentItem != null && allItemData.any((data) => data["Item_id"] == currentItem) ? currentItem : null,
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
                          Radio<int>(
                            value: 1,
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          Text('In'),
                          Radio<int>(
                            value: 0,
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
                      if (selectedStatus == 1)
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
                          value: currentSupplier != null && allSupplierData.any((data) => data["supplier_id"] == currentSupplier) ? currentSupplier : 0,
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
    await dbHelper.ambilData();
    if (_isMounted) {
    setState(() {
      allItemData = dbHelper.getItems();
      allSupplierData = dbHelper.getSuppliers();
    });
  }
  }
  void _insert() async{

    if (selectedStatus == 1) {
      totalQty = currentItemQty + int.parse(_historyQty.text);
    }else{
      totalQty = currentItemQty - int.parse(_historyQty.text);
      currentSupplier = 0;
    }

    var requestBody = {
      'itemId': currentItem.toString(),
      'historyStatus': selectedStatus.toString(), // Keep it as an int
      'historyQty': _historyQty.text.toString(),
      'supplierId': currentSupplier.toString(),
      'updateItemQty' : totalQty.toString()
    };

    print(requestBody);
    var url = 'https://apiuaspml.000webhostapp.com/data_add.php';
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
