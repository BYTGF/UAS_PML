// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';
import 'package:uts/storage/storage_edit.dart';

import '/db_manager.dart';
import 'package:http/http.dart' as http;

class StorageList extends StatefulWidget {
  const StorageList({Key? key}) : super(key: key);

  @override
  _StorageListState createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>  allStorageData = [];
  TextEditingController _StorageName = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: formGlobalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Text('Storage'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              hintText: 'Add Storage',
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
                      ],
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
                            _insert();
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: allStorageData
                            .length, // Number of ListTile items (each repeated twice)
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(); // Divider widget between ListTile items
                        },
                        itemBuilder: (_, index) {
                          var item = allStorageData[index];
                          return ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text("${item['name']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_note,
                                    size: 20.0,
                                    color: Colors.brown[900],
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                            child: Container(
                                                height: 400,
                                                child: Center(
                                                  child: EditStorage(
                                                    id: item['storage_id'],
                                                    name: item['name'],
                                                  ),
                                                )));
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20.0,
                                    color: Colors.brown[900],
                                  ),
                                  onPressed: () {
                                    _delete(item['storage_id']);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // Add your onTap logic here
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _query() async {
    await dbHelper.ambilData();
    setState(() {
      allStorageData = dbHelper.getStorages();
    });
  }
  void _insert() async{
    var storageName = _StorageName.text;
    var requestBody = {'storageName': storageName};

    var url = 'https://apiuaspml.000webhostapp.com/data_add.php';
    var uri = Uri.parse(url);
    var response = await http.post(uri, body: requestBody);
    var body = response.body;
    var json = jsonDecode(body);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(json['message'])));
    if (json['success'] == 1) {
      _query();
    }
  }

  void _delete(int id) async{
    var requestBody = {'storageId': id};

    var url = 'https://apiuaspml.000webhostapp.com/data_add.php';
    var uri = Uri.parse(url);
    var response = await http.post(uri, body: requestBody);
    var body = response.body;
    var json = jsonDecode(body);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(json['message'])));
    if (json['success'] == 1) {
      _query();
    }
  }
  // void _insert() async {
  //   // row to insert
  //   Map<String, dynamic> row = {DatabaseHelper.columnName: _StorageName.text};
  //   print('insert stRT');

  //   final id = await dbHelper.insertStorage(row);
  //   print('inserted row id: $id');
  //   _StorageName.text = "";
  //   _query();
  // }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsStorage();
  //   print('query all rows:');
  //   allRows.forEach(print);
  //   allStorageData = allRows;
  //   setState(() {});
  // }

  // void _delete(int id) async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final rowsDeleted = await dbHelper.deleteStorage(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  //   _query();
  // }
}
