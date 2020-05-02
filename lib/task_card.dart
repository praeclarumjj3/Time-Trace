import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trace/firestore.dart';
import 'package:time_trace/home.dart';
import 'package:time_trace/task.dart';
import 'package:time_trace/today.dart';


class TaskCard extends StatefulWidget {
  TaskCard({this.task});

  Task task;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  Stopwatch watch = new Stopwatch();
  Timer timer;
  AnimationController _animationController;
  bool isPlaying;
  String elapsedTime;
  int seconds;
  int hours;
  int minutes;
  Database database = Database();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    isPlaying = widget.task.status;
    elapsedTime = widget.task.duration;
    String sec = elapsedTime.split(":")[2];
    seconds = int.parse(sec);
    String min = elapsedTime.split(":")[1];
    minutes = int.parse(min);
    String hr = elapsedTime.split(":")[0];
    hours = int.parse(hr);
    isPlaying
        ? startWatch()
        : stopWatch();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }



  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
        });
      database.UpdateTask(widget.task, widget.task.description, elapsedTime, widget.task.date, isPlaying);
    }
  }

  startWatch() {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 1000), updateTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setState(() {
      isPlaying = false;
      stopWatch();
    });
    setState(() {
      elapsedTime = "0:00:00";
      minutes = 0;
      hours = 0;
      seconds = 0;
    });
    database.UpdateTask(widget.task, widget.task.description, elapsedTime, widget.task.date, isPlaying);
  }



  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int sec = (hundreds / 100).truncate();
    int min = (sec / 60).truncate();
    int hr = (min/60).truncate();

    if (sec > 59) {
      setState(() {
        sec = sec - (59 * min);
        sec = sec - min;
      });

    }
    if (min > 59) {
      setState(() {
        min = min - (59 * hr);
        min = min - hr;
      });

    }
    String hoursStr = ((hours+hr) % 24).toString().padLeft(1, '0');
    String minutesStr = ((minutes+min) % 60).toString().padLeft(2, '0');
    String secondsStr = ((seconds+sec) % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }


  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
    });
    isPlaying
        ? startWatch()
        : stopWatch();
    database.UpdateTask(widget.task, widget.task.description, elapsedTime, widget.task.date, isPlaying);

}

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return
      Container(
        child:
      Card(
          child: Row(
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    color: Colors.blueAccent,
                    iconSize: ScreenUtil().setHeight(150),
                    icon: Icon(isPlaying?Icons.pause_circle_filled:Icons.play_circle_filled),
                    onPressed: _handleOnPressed
                )]),
          Expanded(
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Text(
              widget.task.description,
            style: GoogleFonts.poppins(
                textStyle: new TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: ScreenUtil().setSp(45, allowFontScalingSelf: true),
            ))),
          Divider(thickness: ScreenUtil().setWidth(5),),
          Text(
            elapsedTime,
            style: GoogleFonts.poppins(
                textStyle: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(50, allowFontScalingSelf: true),
            )),
          )])),
          Align(
              alignment: Alignment.centerRight,
              child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              color: Colors.red,
              iconSize: ScreenUtil().setHeight(70),
              icon: Icon(Icons.delete),
              onPressed: () {database.deleteTask(widget.task);
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => TodayPage()),
                        (Route<dynamic> route) => false);
              });
              }),
          IconButton(
              color: Colors.blue,
              iconSize: ScreenUtil().setHeight(70),
              icon: Icon(Icons.refresh),
              onPressed: resetWatch
              )]))
        ],
      )));
  }
}
