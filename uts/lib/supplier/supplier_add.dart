// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/db_manager.dart';
import 'package:http/http.dart' as http;

class AddSupplier extends StatefulWidget {
  final Function insertCallback;

  AddSupplier({required this.insertCallback});

  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final TextEditingController _SupplierName = TextEditingController();
  final TextEditingController _ContactPerson = TextEditingController();
  final TextEditingController _Email = TextEditingController();
  final TextEditingController _PhoneNumber = TextEditingController();
  final TextEditingController _Address = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool _isMounted = false;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
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
          title: Text("Add Supplier"),
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
                      hintText: 'Phone Number',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter PhoneNumber';
                      }
                      return null;
                    },
                    controller: _PhoneNumber,
                  ),
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
                      hintText: 'Contact Person',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Contact Person';
                      }
                      return null;
                    },
                    controller: _ContactPerson,
                  ),
                  //textformfield en
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
                      hintText: 'Email',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                    controller: _Email,
                  ),
                  //textformfield en
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
                      hintText: 'Address',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Address';
                      }
                      return null;
                    },
                    controller: _Address,
                  ),
                  //textformfield en
                  const SizedBox(
                    height: 20,
                  ),
                  //mulai bikin disini

                  //mulai bikin akhir disini
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
                          _insert();
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

  void _insert() async {
    var requestBody = {
      'supplierName': _SupplierName.text,
      'contactPerson': _ContactPerson.text,
      'email': _Email.text,
      'phoneNumber': _PhoneNumber.text,
      'address': _Address.text,
    };

    print(requestBody);
    var url = 'https://apiuaspml.000webhostapp.com/data_add.php';
    var uri = Uri.parse(url);

    var response = await http.post(uri, body: requestBody);

    var body = response.body;

    var json = jsonDecode(body);

    if (_isMounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(json['message'])));
    }

    if (_isMounted && json['success'] == 1) {
      widget.insertCallback();
      Navigator.of(context).pop();
    }
  }
}
