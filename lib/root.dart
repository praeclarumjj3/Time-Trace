import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/name.dart';
import 'package:time_trace/sharedprefs.dart';
import 'package:time_trace/today.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String name = "null";
  SharedPrefs sharedPrefs = new SharedPrefs();



  void restore() {
    SharedPreferences sharedPreferences;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      setState(() {
        name = sharedPreferences.get('name');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    restore();
    if (name.toString() == "null") {
      return new NamePage();
    } else {
      return new MyHomePage(index: 0);
    }
  }
}
