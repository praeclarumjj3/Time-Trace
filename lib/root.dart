import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/name.dart';
import 'package:time_trace/sharedprefs.dart';
import 'package:time_trace/today.dart';




class RootPage extends StatefulWidget {
  RootPage({Key key }) : super(key : key);


  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {



//  void restore() async{
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    sharedPrefs.setString('name', "123");
//    setState(() {
//      name = (sharedPrefs.getString('name') ?? "");
//    });
//
//  }
//
//
//  @override
//  void initState() {
//    restore();
//  }

  @override
  Widget build(BuildContext context) {
//    print(name);
//    print("X");
//    print(name.toString() == "hss");
//   if (name.toString() == "123") {
      return new MyHomePage(index: 0,);
//  }
//   else {
//    return new MyHomePage(index : 0);
//  }
  }
}

