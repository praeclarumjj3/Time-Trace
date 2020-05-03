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
import 'package:time_trace/firestore.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/task.dart';
import 'package:intl/intl.dart';
import 'package:time_trace/task_card.dart';

class TodayPage extends StatefulWidget {

  TodayPage({Key key, this.title}) : super(key: key);
  String title;
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {

  Database database = new Database();
  Future<List<Task>> tasks;
  var now = DateTime.now();
  var dateFormat;
  String date;
  String title;
  int percent = 0;
  String trackedTime = "Calculating";


  void shared_init()async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
   // title = (sharedPrefs.getString('name') ?? "");
  }

  @override
  void initState() {
    super.initState();
    //shared_init();
    title = widget.title;
    dateFormat = DateFormat('dd/MM/yyyy');
    date = dateFormat.format(now);
    tasks = database.determineDatedTasks(date);
    PercentageTrack();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void PercentageTrack()async {
    final totalTrack1 = await database.getTotalTaskDuration(date);
    String totalTrack = totalTrack1.toString();
    String sec = totalTrack.split(":")[2];
    int seconds = int.parse(sec);
    String min = totalTrack.split(":")[1];
    int minutes = int.parse(min);
    String hr = totalTrack.split(":")[0];
    int hours = int.parse(hr);
    int trackSeconds = ((hours*3600) + (minutes*60) + seconds);
    setState(() {
      percent = (trackSeconds/864).round();
      trackedTime = totalTrack;
    });


  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return MaterialApp(
      home: Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: true,
            title: new Text("Time Performance",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize:
                        ScreenUtil().setSp(40, allowFontScalingSelf: true),
                        color: Colors.white))),
            backgroundColor: Colors.blue,
            centerTitle: false,
          ),
          body: Track()),
    );
  }


  Widget PercentTrack() {
    String per = (percent).toString().padLeft(2, '0');
    return Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: new CircularPercentIndicator(
              radius: ScreenUtil().setWidth(400),
              animation: true,
              animationDuration: 1200,
              lineWidth: ScreenUtil().setWidth(20),
              percent: (percent*0.01),
              center: new Text(
                "$per%",
                style: new TextStyle(
                  color:Colors.green,
                    fontSize: ScreenUtil().setSp(50)),
              ),
              circularStrokeCap: CircularStrokeCap.butt,
              backgroundColor: Colors.orange,
              progressColor: Colors.blue,
            )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),ScreenUtil().setWidth(20),ScreenUtil().setWidth(20),0),
                    child: new Text("Total Tracked Time",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(40, allowFontScalingSelf: true),
                                color: Colors.black.withOpacity(0.8))))),
                Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(0)),
                    child: new Text("(till last addition of a task)",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(25, allowFontScalingSelf: true),
                                color: Colors.black)))),
                Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    child: new Text("$trackedTime",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(50, allowFontScalingSelf: true),
                                color: Colors.black)))),
                Divider(thickness: 2,),
                Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    child: new Text("Performance level",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(40, allowFontScalingSelf: true),
                                color: Colors.black.withOpacity(0.8))))),
                Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    child: new Text(percent>=50?"Great!":"Let's Improve!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: new TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(50, allowFontScalingSelf: true),
                                color: percent>=50?Colors.green:Colors.orange))))
              ],
            ))
          ],
        ));
  }

  Widget Track() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PercentTrack(),
        Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                        child: new Text("Today",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: new TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(50, allowFontScalingSelf: true),
                                    color: Colors.black)))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                color: Colors.blue,
                                iconSize: ScreenUtil().setHeight(100),
                                icon: Icon(Icons.add_circle),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        AddTask()),
                                  );
                                })))
                  ],
                ))),
        new Expanded(
            child: FutureBuilder<List>(
              future: tasks,
              builder: (context, snapshot) {
                print(snapshot.hasData);
                return snapshot.hasData
                    ? snapshot.data.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Add Tasks to better track your time!",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(40, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, position) {
                    return TaskCard(
                        task: snapshot.data[position],
                    );
                  },
                )
                    : Center(
                  child: CircularProgressIndicator(
                      value: null,
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.blue)),
                );
              },
            )),
      ],
    );
  }
}



