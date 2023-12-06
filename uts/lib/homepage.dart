// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';
import 'package:uts/history/history_list.dart';
import 'package:uts/item/item_list.dart';
import 'package:uts/storage/storage_list.dart';
import 'package:uts/user_list.dart';
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Office Stationary Stock Monitoring"),
        ),
        body: TabBarView(
          children: [
            HistoryList(),
            ItemList(),
            StorageList(),
            UserList(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
          ),
          child: TabBar(
            tabs: [
              Tab(
                text: 'History',
                icon: Icon(Icons.list_outlined),
              ),
              Tab(
                text: 'Item List',
                icon: Icon(Icons.dashboard),
              ),
              Tab(
                text: 'Storage',
                icon: Icon(Icons.storage),
              ),
              Tab(
                text: 'User',
                icon: Icon(Icons.account_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
