import 'dart:async';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/firestore.dart';
import 'package:time_trace/sharedprefs.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class AddTask extends StatefulWidget {

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  FocusNode myFocusNode;
  TextEditingController controller;
  SharedPrefs sharedPrefs = new SharedPrefs();
  Duration _duration = Duration(hours: 0, minutes: 0);
  String title;
  bool status;
  Database database = new Database();
  var now = DateTime.now();
  var dateFormat;
  String date;

  void shared_init()async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    title = (sharedPrefs.getString('name') ?? "");
  }

  @override
  void initState(){
    super.initState();
    status = false;
    dateFormat = DateFormat('dd/MM/yyyy');
    date = dateFormat.format(now);
    myFocusNode = new FocusNode();
    controller = new TextEditingController();
    shared_init();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text("Add a Task",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ScreenUtil().setSp(50, allowFontScalingSelf: true),
                      color: Colors.black))),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.white,
          centerTitle: false,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ Expanded(child:Container(
                height: ScreenUtil().setHeight(1000),
        child:DurationPicker(
              duration: _duration,
              onChange: (val) {
                this.setState(() => _duration = val);
              },
              snapToMins: 5.0,
            ) )),
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(100), ScreenUtil().setWidth(70),
                    ScreenUtil().setWidth(100), 0),
                child: new TextFormField(
                    controller: controller,
                    focusNode: myFocusNode,
                    onTap: _requestFocus,
                    maxLength: 100,
                   textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                        contentPadding:
                            EdgeInsets.all(ScreenUtil().setWidth(10)),
                        labelText: "Enter description",
                        labelStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(40, allowFontScalingSelf: true),
                                color: myFocusNode.hasFocus
                                    ? Colors.blue
                                    : Colors.grey)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: myFocusNode.hasFocus
                                  ? Colors.blue
                                  : Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: myFocusNode.hasFocus
                                  ? Colors.blue
                                  : Colors.grey),
                        )),)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(100),
                          ScreenUtil().setWidth(70), ScreenUtil().setWidth(100),0),
                      child: new Text("Start watch",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: new TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(40, allowFontScalingSelf: true),
                                  color: Colors.black)))),
             Expanded(child:
                  Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(100),
                                ScreenUtil().setWidth(70),
                                ScreenUtil().setWidth(100),0),
                            child: CustomSwitch(
                              activeColor: Colors.blue,
                              value: status,
                              onChanged: (value) {
                                setState(() {
                                  status = !status;
                                  print("VALUE: $status");
                                });
                              },
                            )))),

                ],
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(70)),
                    child: Container(
                        width: ScreenUtil().setWidth(400),
                        child: FlatButton(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          onPressed: () {
                            if (controller.text != null && controller.text.length > 0) {
                              AddTaskToFirestore(
                                  controller.text, status, _duration.toString());
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage(index:0)),
                                  (Route<dynamic> route) => false);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Description is needed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: ScreenUtil()
                                      .setSp(40, allowFontScalingSelf: true));
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil()
                                    .setSp(50, allowFontScalingSelf: true)),
                          ),
                          color: Colors.blue,
                        )),
                  )),
            ],
          ),
        );
  }


  void AddTaskToFirestore(
    String description,
    bool status,
    String duration,
  ) {
    database.addTask(description, (_duration.toString()).split('.')[0], date, status);
  }
}
