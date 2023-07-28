import 'package:flutter/material.dart';
import 'package:fl_map_app/pages/root_app.dart';
//import 'package:sqflite/sqflite.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: RootApp(),
    ),
  );
}
