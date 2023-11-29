// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';
import 'package:uts/history_list.dart';
import 'package:uts/item_list.dart';
import 'package:uts/storage_list.dart';
import 'package:uts/user_list.dart';
// import 'package:utskel1/models/Storage.dart';
// import 'package:sqflite/sqflite.dart';
// import 'mydrawal.dart';
import 'db_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
          length: 4, 
          child:  Scaffold(
            // drawer: MyDrawal(),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'History',
                    icon: Icon(Icons.list_outlined
                  )),
                  Tab(
                    text: 'Item List',
                    icon: Icon(Icons.dashboard
                  )),
                  Tab(
                    text: 'Storage',
                    icon: Icon(Icons.storage
                  )),
                  Tab(
                    text: 'User',
                    icon: Icon(Icons.account_circle
                  )),
                ],
              ),
              backgroundColor: MyColors.primaryColor,
              centerTitle: true,
              title: Text("Office Stationary Stock Monitoring"),
            ),
            body:TabBarView(
              children: [
                HistoryList(),
                ItemList(),
                StorageList(),
                UserList(),
              ],
            ),
          )
    ) 
  );
  }

  // void _insert() async {
  //   // row to insert
  //   Map<String, dynamic> row = {DatabaseHelper.columnName: _StorageName.text};
  //   print('insert stRT');

  //   final id = await dbHelper.insertUser(row);
  //   print('inserted row id: $id');
  //   _StorageName.text = "";
  //   _query();
  // }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRows();
  //   print('query all rows:');
  //   allRows.forEach(print);
  //   allStorageData = allRows;
  //   setState(() {});
  // }

  // void _delete(int id) async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final rowsDeleted = await dbHelper.delete(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  //   _query();
  // }
}
