import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/firestore.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/optimizer.dart';
import 'package:time_trace/task.dart';
import 'package:time_trace/today.dart';

class StepCard extends StatefulWidget {
  StepCard({this.string, this.position});

  String string;
  int position;

  @override
  _StepCardState createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  Database database = Database();


  @override
  Widget build(BuildContext context) {
    String pos = widget.position.toString();
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return Container(
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(30), 0,ScreenUtil().setWidth(30), 0),
                              child: Text("$pos.",
                                  style: GoogleFonts.poppins(
                                      textStyle: new TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil()
                                        .setSp(70, allowFontScalingSelf: true),
                                  ))))
                        ]),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(widget.string,
                              style: GoogleFonts.poppins(
                                  textStyle: new TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil()
                                    .setSp(40, allowFontScalingSelf: true),
                              )))
                        ])),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          color: Colors.red,
                          iconSize: ScreenUtil().setHeight(70),
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            database.deleteOptimizer(widget.string);
                            Future.delayed(Duration(milliseconds: 500), () {
                              Navigator.of(context).pop();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage(
                                            index: 2
                                          )),
                                  (Route<dynamic> route) => false);
                            });
                          }),
                    )
                  ],
                ))));
  }
}
