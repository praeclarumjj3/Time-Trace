import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:time_trace/firestore.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/task.dart';
import 'package:time_trace/today.dart';

class DayCard extends StatefulWidget {
  DayCard({this.date});

  String date;

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  Database database = Database();
  int percent = 0;
  String trackedTime = "Calculating";

  @override
  void initState() {
    super.initState();
    PercentageTrack();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void PercentageTrack() async {
    final totalTrack1 = await database.getTotalTaskDuration(widget.date);
    String totalTrack = totalTrack1.toString();
    String sec = totalTrack.split(":")[2];
    int seconds = int.parse(sec);
    String min = totalTrack.split(":")[1];
    int minutes = int.parse(min);
    String hr = totalTrack.split(":")[0];
    int hours = int.parse(hr);
    int trackSeconds = ((hours * 3600) + (minutes * 60) + seconds);
    setState(() {
      percent = (trackSeconds / 864).round();
      trackedTime = totalTrack;
    });
  }

  @override
  Widget build(BuildContext context) {
    String per = (percent).toString().padLeft(2, '0');
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(10),
            ScreenUtil().setWidth(10)),
        child: Container(
            height: ScreenUtil().setHeight(300),
            child: Card(
                child: Row(
              children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          child: new CircularPercentIndicator(
                            radius: ScreenUtil().setWidth(200),
                            animation: true,
                            animationDuration: 2000,
                            lineWidth: ScreenUtil().setWidth(10),
                            percent: (percent * 0.01),
                            center: new Text(
                              "$per%",
                              style: new TextStyle(
                                  color: Colors.green ,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.orange,
                            progressColor: Colors.blue,
                          )))
                ]),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Text(widget.date,
                          style: GoogleFonts.poppins(
                              textStyle: new TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: ScreenUtil()
                                .setSp(45, allowFontScalingSelf: true),
                          ))),
                      Divider(
                        thickness: ScreenUtil().setWidth(5),
                      ),
                      Text(
                        trackedTime,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(50, allowFontScalingSelf: true),
                        )),
                      )
                    ]))),
//                Align(
//                    alignment: Alignment.centerRight,
//                    child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.storage,
//                            color: Colors.orange,
//                            size: ScreenUtil().setHeight(100),
//                          )
//                        ]))
              ],
            ))));
  }
}
