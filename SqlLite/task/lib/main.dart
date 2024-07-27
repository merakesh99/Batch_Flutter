import 'package:flutter/material.dart';
import 'package:task/home_screen.dart';
import 'package:task/item_form_screen.dart';
import 'database_helper.dart';
import 'item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Example',
      home: HomeScreen(),
    );
  }
}

