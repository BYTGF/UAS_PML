import 'package:flutter/material.dart';
import 'package:uts/user/user_add.dart';
import '/colors.dart';

import '/db_manager.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allUserData = [];

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
          ElevatedButton(
            onPressed: () {
              // Show the dialog when the button is pressed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      child: Container(
                    height: 350,
                    child: AddUser(),
                  ));
                },
              );
            },
            child: Text('Add User'),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: allUserData
                  .length, // Number of ListTile items (each repeated twice)
              separatorBuilder: (BuildContext context, int index) {
                return Divider(); // Divider widget between ListTile items
              },
              itemBuilder: (_, index) {
                var item = allUserData[index];
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("${item['username']}"),
                  subtitle: Text("${item['date']}"),
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
                          //   _onDeleteUserPressed(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20.0,
                          color: Colors.brown[900],
                        ),
                        onPressed: () {
                          _delete(item['_id']);
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
    )));
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRowsUser();
    print('query all rows:');
    allRows.forEach(print);
    allUserData = allRows;
    setState(() {});
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.deleteUser(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}