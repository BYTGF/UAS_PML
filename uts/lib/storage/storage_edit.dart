// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';

import '/db_manager.dart';

class EditStorage extends StatefulWidget {
  final int id;
  final String name;
  const EditStorage({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  _EditStorageState createState() => _EditStorageState();
}

class _EditStorageState extends State<EditStorage> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allStorageData = [];
  TextEditingController _StorageName = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    _query();
    super.initState();
    _StorageName.text = widget.name;
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
    ));
  }

  void _update() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: widget.id,
      DatabaseHelper.columnName: _StorageName.text
    };
    print('insert stRT');

    final rowsUpdated = await dbHelper.updateStorage(row);
    print('updated row id: $rowsUpdated');
    _StorageName.text = "";
    Navigator.of(context).pop();
    _query();

    
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRowsStorage();
    print('query all rows:');
    allRows.forEach(print);
    allStorageData = allRows;
    setState(() {});
  }

}
