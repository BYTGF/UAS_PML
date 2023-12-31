import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uts/statvar.dart';
import 'package:uts/supplier/supplier_add.dart';
import 'package:uts/supplier/supplier_edit.dart';

import '/db_manager.dart';
import '/colors.dart';
import 'package:http/http.dart' as http;

class SupplierList extends StatefulWidget {
  const SupplierList({Key? key}) : super(key: key);

  @override
  _SupplierListState createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  final dbHelper = DatabaseHelper.instance;
  List<dynamic> allSupplierData = [];

  void _insertCallback() {
    _query(); // Refresh the list after insertion
  }

  @override
  void initState() {
    super.initState();
    StatVar.accessUserData();
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
                child: Text('Supplier List'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: allSupplierData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (_, index) {
                    var supplier = allSupplierData[index];
                    return
                    Card(
        elevation: 4.0, // Adjust the elevation as needed
        margin: EdgeInsets.all(8.0), // Adjust the margin as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
        ),
        child: ListTile(
                      leading: Icon(Icons.account_box),
                      title: Text("${supplier['supplier_name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${supplier['contact_person']} | ${supplier['phone_number']}"),
                          Text("${supplier['address']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (StatVar.access == 1)
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
                                          child: EditSupplier(
                                            insertCallback: _insertCallback,
                                            id: supplier['supplier_id'],
                                            supplierName: supplier['supplier_name'],
                                            contactPerson:
                                            supplier['contact_person'],
                                            email:
                                            supplier['email'],
                                            phoneNumber:
                                            supplier['phone_number'],
                                            address:
                                            supplier['address'],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          if (StatVar.access == 1)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20.0,
                                color: Colors.brown[900],
                              ),
                              onPressed: () {
                                _delete(supplier['supplier_id']);
                              },
                            ),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email : ${supplier['email']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    )
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
                    height: 650,
                    child: Center(
                      child: AddSupplier(insertCallback: _insertCallback),
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
      allSupplierData = dbHelper.getSuppliers();
    });
    ;
  }

  void _delete(int id) async {
    String idSupplier = id.toString();
    var requestBody = {'supplierId': idSupplier};

    var url = 'https://apiuaspml.000webhostapp.com/data_delete.php';
    var uri = Uri.parse(url);
    print("1");
    var response = await http.post(uri, body: requestBody);
    print("2");
    var body = response.body;
    print("3");
    var json = jsonDecode(body);
    print("4");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json['message'])));
    if (json['success'] == 1) {
      _query();
    }
  }
}
