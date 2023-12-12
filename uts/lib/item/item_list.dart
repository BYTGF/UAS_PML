import 'package:flutter/material.dart';
import 'package:uts/item/item_add.dart';
import 'package:uts/item/item_edit.dart';

import '/db_manager.dart';
import '/colors.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allItemData = [];

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
                                      height: 400,
                                      child: Center(
                                        child: EditItem(),
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

  void _query() async {
    final allRows = await dbHelper.queryAllRowsItem();
    print('query all rows:');
    // allRows.forEach(print);
    setState(() {
      allItemData = allRows;
    });
  }

  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteItem(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}
