import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uts/item/item_add.dart';
import 'package:uts/item/item_edit.dart';

import '/db_manager.dart';
import '/colors.dart';
import 'package:http/http.dart' as http;

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>  allItemData = [];

  Icon _getLeadingIcon(int qty) {
    if (qty > 5) {
      return Icon(Icons.checklist_rounded);
    } else if (qty == 0) {
      return Icon(Icons.error); // Replace with your desired icon
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
                child: Text('Item List'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: allItemData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (_, index) {
                    var item = allItemData[index];
                    return ListTile(
                      leading: _getLeadingIcon(item['itemQty']),
                      title: Text("${item['itemName']}"),
                      subtitle: Text("${item['storageName']}"),
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
                                      height: 500,
                                      child: Center(
                                        child: EditItem(
                                          insertCallback: _insertCallback,
                                          id: item['itemId'],
                                          itemName: item['itemName'],
                                          storageId: item['storageId'],
                                          itemQty: item['itemQty'],
                                          supplierId: item['supplierId'],
                                        ),
                                      ),
                                    ),
                                  );
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
                              _delete(item['itemId']);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quantity : ${item['itemQty']}'),
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
                    height: 500,
                    child: Center(
                      child: AddItem(insertCallback: _insertCallback),
                    ),
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
      allItemData = dbHelper.getItems();
      
    });
    ;
  }

  void _delete(int id) async{
    String idItem = id.toString();
    var requestBody = {'itemId': idItem};

    var url = 'https://apiuaspml.000webhostapp.com/data_delete.php';
    var uri = Uri.parse(url);
    var response = await http.post(uri, body: requestBody);
    var body = response.body;
    var json = jsonDecode(body);
    if (json['success'] == 1) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(json['message'])));
      _query();
    }
  }
  // void _query() async {
  //   final allRows = await dbHelper.queryAllRowsItem();
  //   print('query all rows:');
  //   // allRows.forEach(print);
  //   setState(() {
  //     allItemData = allRows;
  //   });
  // }

  // void _delete(int id) async {
  //   final rowsDeleted = await dbHelper.deleteItem(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  //   _query();
  // }
}
