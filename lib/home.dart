import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trace/destination.dart';
import 'package:time_trace/optimizer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:time_trace/root.dart';
import 'package:time_trace/today.dart';
import 'package:time_trace/week.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({this.index});

  int index;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin<MyHomePage> {
  int _currentIndex = 0;
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectionSubscription;
  String _connectionStatus;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    checkConnection();
    isLoading = false;
  }

  void checkConnection(){
    _connectionSubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      setState(() {
        _connectionStatus = result.toString();
         isLoading = false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return Scaffold(
      body:_connectionStatus=="ConnectivityResult.none"?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Checking for internet",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: ScreenUtil()
                          .setSp(40, allowFontScalingSelf: true),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey)),
            ),
            Center(
              child: CircularProgressIndicator(
                  value: null,
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.blue)),
            )
          ],
        ),
      )
      :SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            TodayPage(),
            WeekPage(),
            MyListPage()
          ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              title: Text(destination.title)
          );
        }).toList(),
      ),
    );
  }
}
