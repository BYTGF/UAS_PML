// import 'dart:convert';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uts/history/history_add.dart';

import '/db_manager.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allHistoryData = [];

  Icon _getLeadingIcon(String status) {
    if (status == "In") {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.warning); // Replace with another icon for negative quantity
    }
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
              ElevatedButton(
                onPressed: () {
                  // Show the dialog when the button is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 400,
                          child: Center(
                            child: AddHistory(),
                          )              
                        ),
                        
                      );
                    },
                  );
                },
                child: Text('Update Stock'),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount:  allHistoryData.length, // Number of ListTile items (each repeated twice)
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(); // Divider widget between ListTile items
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
                              IconButton(
                                icon: Icon(
                                  Icons.edit_note,
                                  size: 20.0,
                                  color: Colors.brown[900],
                                ),
                                onPressed: () {
                                  //   _onDeleteItemPressed(index);
                                },
                              ),
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
                                content: Text('Quantity : ${item['itemQty']}'),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        );
                  },
                ),
              ),
            ],
          ),
        )
      )
      
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRowsHistory();
    print('query all rows:');
    allRows.forEach(print);
    allHistoryData = allRows;
    setState(() {});
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.deleteItem(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}
