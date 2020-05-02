import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/root.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
      title: 'Time Trace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage()
    );
  }



}

