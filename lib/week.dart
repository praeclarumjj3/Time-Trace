import 'dart:async';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/add_task.dart';
import 'package:time_trace/day_card.dart';
import 'package:time_trace/firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:time_trace/home.dart';
import 'package:time_trace/task.dart';
import 'package:intl/intl.dart';
import 'package:time_trace/task_card.dart';
import 'package:time_trace/time_tracked.dart';

class WeekPage extends StatefulWidget {
  WeekPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  Database database = new Database();
  var now = DateTime.now();
  var dateFormat;
  String date1;
  String date2;
  String date3;
  String date4;
  String date5;
  String date6;
  String date7;
  String duration1 = "0:00:00";
  String duration2 = "0:00:00";
  String duration3 = "0:00:00";
  String duration4 = "0:00:00";
  String duration5 = "0:00:00";
  String duration6 = "0:00:00";
  String duration7 = "0:00:00";
  String title;
  List<TimeTracked> data;
  String avg;

  void shared_init() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    // title = (sharedPrefs.getString('name') ?? "");
  }

  void returnAvg() {
    int seconds = 0;
    int minutes = 0;
    int hrs = 0;

    List<String> dur = [
      duration1,
      duration2,
      duration3,
      duration4,
      duration5,
      duration6,
      duration7
    ];

    for (int i = 0; i < 7; i++) {
      String elapsedTime = dur[i];
      String sec = elapsedTime.split(":")[2];
      seconds += int.parse(sec);
      if (seconds > 59) {
        seconds -= 60;
        minutes += 1;
      }
      String min = elapsedTime.split(":")[1];
      minutes += int.parse(min);
      if (minutes > 59) {
        minutes -= 60;
        hrs += 1;
      }
      String hr = elapsedTime.split(":")[0];
      hrs += int.parse(hr);
    }

    hrs = (hrs / 7).round();
    seconds = (seconds / 7).round();
    minutes = (minutes / 7).round();

    String hoursStr = ((hrs) % 24).toString().padLeft(1, '0');
    String minutesStr = ((minutes) % 60).toString().padLeft(2, '0');
    String secondsStr = ((seconds) % 60).toString().padLeft(2, '0');
    setState(() {
      avg = "$hoursStr:$minutesStr:$secondsStr";
    });

  }

  getDurations() async {
    duration1 = await database.getTotalTaskDuration(date1);
    duration2 = await database.getTotalTaskDuration(date2);
    duration3 = await database.getTotalTaskDuration(date3);
    duration4 = await database.getTotalTaskDuration(date4);
    duration5 = await database.getTotalTaskDuration(date5);
    duration6 = await database.getTotalTaskDuration(date6);
    duration7 = await database.getTotalTaskDuration(date7);
  }

  getDates() {
    dateFormat = DateFormat('dd/MM/yyyy');
    date1 = dateFormat.format(now);
    date2 = dateFormat.format(new DateTime(now.year, now.month, now.day - 1));
    date3 = dateFormat.format(new DateTime(now.year, now.month, now.day - 2));
    date4 = dateFormat.format(new DateTime(now.year, now.month, now.day - 3));
    date5 = dateFormat.format(new DateTime(now.year, now.month, now.day - 4));
    date6 = dateFormat.format(new DateTime(now.year, now.month, now.day - 5));
    date7 = dateFormat.format(new DateTime(now.year, now.month, now.day - 6));
  }

//  num getMeasureOfDuration(String totalTrack){
//    String min = totalTrack.split(":")[1];
//    int minutes = int.parse(min);
//    String hr = totalTrack.split(":")[0];
//    int hours = int.parse(hr);
//    int trackMinutes = ((hours*60) + minutes);
//    num measure = trackMinutes/(60*24);
//    measure *= 100;
//    return measure;
//  }

//  init_chart_data() async {
//    data = [
//    TimeTracked(
//      date: date7.split("/")[0] + "/" + date7.split("/")[1],
//    duration: getMeasureOfDuration(duration7),
//    barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//    ),
//      TimeTracked(
//          date: date6.split("/")[0] + "/" + date6.split("/")[1],
//          duration: getMeasureOfDuration(duration6),
//          barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//      ),
//      TimeTracked(
//          date: date5.split("/")[0] + "/" + date5.split("/")[1],
//          duration: getMeasureOfDuration(duration5),
//          barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//      ),
//      TimeTracked(
//          date: date4.split("/")[0] + "/" + date4.split("/")[1],
//          duration: getMeasureOfDuration(duration4),
//          barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//      ),
//      TimeTracked(
//          date: date3.split("/")[0] + "/" + date3.split("/")[1],
//          duration: getMeasureOfDuration(duration3),
//          barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//      ),
//      TimeTracked(
//          date: date2.split("/")[0] + "/" + date2.split("/")[1],
//          duration: getMeasureOfDuration(duration2),
//          barColor: charts.ColorUtil.fromDartColor(Colors.blue)
//      ),
//      TimeTracked(
//          date: "Today",
//          duration: getMeasureOfDuration(duration1),
//          barColor: charts.ColorUtil.fromDartColor(Colors.orange)
//      ),
//    ];
//  }

  @override
  void initState() {
    super.initState();
    //shared_init();
    title = widget.title;
    getDates();
    getDurations();
    returnAvg();
    //init_chart_data();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
//    List<charts.Series<TimeTracked, String>> series = [
//      charts.Series(
//          id: "Time Tracked",
//          data: data,
//          domainFn: (TimeTracked serie, _) => serie.date,
//          measureFn: (TimeTracked serie, _) => serie.duration,
//          colorFn: (TimeTracked serie, _) => serie.barColor)
//    ];
    returnAvg();
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text("Week's Performance",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize:
                          ScreenUtil().setSp(40, allowFontScalingSelf: true),
                      color: Colors.white))),
          backgroundColor: Colors.blue,
          centerTitle: false,
        ),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                        child: new Text("Average Time tracked \n (per day)",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: new TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(35, allowFontScalingSelf: true),
                                    color: Colors.black)))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(30)),
                                child: new Text("$avg",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: new TextStyle(
                                            fontSize: ScreenUtil().setSp(50,
                                                allowFontScalingSelf: true),
                                            color: Colors.black))))))
                  ],
                )),
//            Container(
//        height: ScreenUtil().setHeight(500),
//        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
//        child: Card(
//          child: Padding(
//            padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
//            child: Column(
//              children: <Widget>[
//                Text(
//                 data[6].duration.toString(),
//                  style: Theme.of(context).textTheme.body2,
//                ),
//                Expanded(
//                  child: charts.BarChart(series, animate: true),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
            Expanded(
                child: ListView(
              children: <Widget>[
                DayCard(
                  date: date1,
                ),
                DayCard(
                  date: date2,
                ),
                DayCard(
                  date: date3,
                ),
                DayCard(
                  date: date4,
                ),
                DayCard(
                  date: date5,
                ),
                DayCard(
                  date: date6,
                ),
                DayCard(
                  date: date7,
                )
              ],
            ))
          ],
        ));
  }
}
