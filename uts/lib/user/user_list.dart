import 'package:flutter/material.dart';
import 'package:uts/user/user_add.dart';
import '/colors.dart';

import '/db_manager.dart';
import 'package:http/http.dart' as http;

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>  allUserData = [];

  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: Text('User'),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: allUserData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (_, index) {
                    var item = allUserData[index];
                    return ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text("${item['name']}"),
                      subtitle: Text("${item['username']}"),
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
                              // _onDeleteUserPressed(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 20.0,
                              color: Colors.brown[900],
                            ),
                            onPressed: () {
                              _delete();
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
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show the dialog when the button is pressed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    height: 350,
                    child: AddUser(),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.pink,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

Future<void> _query() async {
    await dbHelper.ambilData();
    setState(() {
      allUserData = dbHelper.getUsers();
    });
  }
  void _insert() async{

  }

  void _delete() async{
    
  }
  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsUser();
  //   print('query all rows:');
  //   allRows.forEach(print);
  //   setState(() {
  //     allUserData = allRows;
  //   });
  // }

  // void _delete(int id) async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final rowsDeleted = await dbHelper.deleteUser(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  //   _query();
  // }
}
