import 'package:flutter/material.dart';
import 'package:uts/history/history_add.dart';

import '/db_manager.dart';
import '/colors.dart';
import 'package:http/http.dart' as http;

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>  allHistoryData = [];

  Icon _getLeadingIcon(int status) {
    if (status == 1) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(
          Icons.warning); // Replace with another icon for negative quantity
    }
  }

  void _insertCallback() {
    _query(); // Refresh the list after insertion
  }

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
                child: Text('History'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: allHistoryData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (_, index) {
                    var item = allHistoryData[index];
                    return ListTile(
                      leading: _getLeadingIcon(item['historyStatus']),
                      title: Text("${item['itemName']}"),
                      subtitle: Text("${item['historyQty']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.edit_note,
                          //     size: 20.0,
                          //     color: Colors.brown[900],
                          //   ),
                          //   onPressed: () {
                          //     // _onDeleteItemPressed(index);
                          //   },
                          // ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.delete_outline,
                          //     size: 20.0,
                          //     color: Colors.brown[900],
                          //   ),
                          //   onPressed: () {
                          //     _delete(item['historyId']);
                          //   },
                          // ),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quantity : ${item['historyQty']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    height: 400,
                    child: Center(
                      child: AddHistory(insertCallback: _insertCallback),
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

Future<void> _query() async {
    await dbHelper.ambilData();
    setState(() {
      allHistoryData = dbHelper.getHistories();
    });
  }
  void _insert() async{

  }

  void _delete() async{
    
  }
  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsHistory();
  //   print('query all rows:');
  //   allRows.forEach(print);
  //   setState(() {
  //     allHistoryData = allRows;
  //   });
  // }

  // void _delete(int id) async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final rowsDeleted = await dbHelper.deleteItem(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  //   _query();
  // }
}
