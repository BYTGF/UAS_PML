// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uts/colors.dart';
import 'package:uts/history/history_list.dart';
import 'package:uts/item/item_list.dart';
import 'package:uts/statvar.dart';
import 'package:uts/storage/storage_list.dart';
import 'package:uts/supplier/supplier_list.dart';
import 'db_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper.instance;
  final formGlobalKey = GlobalKey<FormState>();
  late TabController _tabController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    StatVar.accessUserData(); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: [
            HistoryList(),
            ItemList(),
            StorageList(),
            SupplierList(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
          ),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: 'History',
                icon: Icon(Icons.access_alarm_rounded),
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
                text: 'Supplier',
                icon: Icon(Icons.account_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.primaryColor,
      centerTitle: true,
      title: Text("Welcome, ${StatVar.userName}"),
      automaticallyImplyLeading: false, // Removes the back button
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Reset user data and navigate to the login page
            StatVar.userData = null;
            StatVar.userName = null.toString();
            StatVar.access = 0;

            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
        ),
      ],
    );
  }
}

