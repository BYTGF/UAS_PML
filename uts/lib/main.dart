import 'package:flutter/material.dart';
import 'package:uts/homepage.dart';
import 'package:uts/loginpage.dart';
import 'package:uts/storage/storage_edit.dart';
import 'package:uts/storage/storage_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock of Goods Monitoring',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) { 
          return LoginPage(); 
        },
        '/home': (context) { 
          return HomePage(); 
        },
      },
    );
  }
}
