// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';

import '/db_manager.dart';
import 'package:http/http.dart' as http;

class EditStorage extends StatefulWidget {
  final int id;
  final String storageName;
  final Function insertCallback;
  const EditStorage({
    Key? key,
    required this.id,
    required this.storageName,
    required this.insertCallback
  }) : super(key: key);

  @override
  _EditStorageState createState() => _EditStorageState();
}

class _EditStorageState extends State<EditStorage> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>  allStorageData = [];
  bool _isMounted = false;
  TextEditingController _StorageName = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    _query();
    _isMounted = true;
    super.initState();
    _StorageName.text = widget.storageName;
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
          title: Text("Edit Storage"),
        ),
        body: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 250,
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.primaryColor, width: 1.0),
                            ),
                            hintText: 'Edit Storage',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          controller: _StorageName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Storage name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
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
            ],
          ),
        ),
      )
    );
  }

  Future<void> _query() async {
      await dbHelper.ambilData();
      if (_isMounted){
        setState(() {
        allStorageData = dbHelper.getStorages();
      });
      }
      
    }
  void _update() async{
    String idStorage = widget.id.toString();
    var requestBody = {'storageName': _StorageName.text,'storageId': idStorage};

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
  //     DatabaseHelper.columnId: widget.id,
  //     DatabaseHelper.columnName: _StorageName.text
  //   };
  //   print('insert stRT');

  //   final rowsUpdated = await dbHelper.updateStorage(row);
  //   print('updated row id: $rowsUpdated');
  //   _StorageName.text = "";
  //   Navigator.of(context).pop();
  //   _query();

    
  // }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsStorage();
  //   print('query all rows:');
  //   allRows.forEach(print);
  //   allStorageData = allRows;
  //   setState(() {});
  // }

}


