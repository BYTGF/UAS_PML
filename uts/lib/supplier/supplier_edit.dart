// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;


class EditSupplier extends StatefulWidget {
  final int id;
  final String SupplierName;
  final Function insertCallback;
  

  EditSupplier({required this.id, required this.SupplierName,required this.insertCallback, Key? key,}) : super(key: key);

  @override
  _EditSupplierState createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {
  final TextEditingController _SupplierName = TextEditingController();
  final TextEditingController _PhoneNumber = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool _isMounted = false;
  final dbHelper = DatabaseHelper.instance;
  
  
  @override
  void initState() {
    super.initState();
    _SupplierName.text = widget.SupplierName;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Update Supplier"),
        ),
        body: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //textformfield start
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: MyColors.primaryColor, width: 1.0),
                      ),
                      enabled: false,
                      hintText: 'Supplier Name',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Supplier Name';
                      }
                      return null;
                    },
                    controller: _SupplierName,
                  ),
                  //textformfield end
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: MyColors.primaryColor, width: 1.0),
                      ),
                      hintText: 'Supplier Quantity',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    enabled: false,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Quantity';
                      }
                      return null;
                    },
                    controller: _PhoneNumber,
                  ),
                  //mulai bikin disini
                  
                  //mulai bikin akhir disini
                  const SizedBox(
                    height: 20,
                  ),
                  TextButtonTheme(
                    data: TextButtonThemeData(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MyColors.primaryColor),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formGlobalKey.currentState!.validate()) {
                          _update();
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _update() async{

    var requestBody = {
      'SupplierId': widget.id.toString(),
      'SupplierName': _SupplierName.text,
      'PhoneNumber': _PhoneNumber.text,
    };


    print(requestBody);
    var url = 'https://apiuaspml.000webhostapp.com/data_update.php';
    var uri = Uri.parse(url);

    var response = await http.post(uri, body: requestBody);

    var body = response.body;

    var json = jsonDecode(body);

    if (_isMounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json['message'])));
    }

    if (_isMounted && json['success'] == 1) {
      widget.insertCallback();
      Navigator.of(context).pop();
    }
  }
}
