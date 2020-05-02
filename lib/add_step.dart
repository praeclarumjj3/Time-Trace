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
import 'package:time_trace/optimizer.dart';
import 'package:time_trace/sharedprefs.dart';
import 'package:time_trace/task.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class AddStep extends StatefulWidget {

  @override
  AddStepState createState() => AddStepState();
}

class AddStepState extends State<AddStep> {
  FocusNode myFocusNode;
  TextEditingController controller;
  SharedPrefs sharedPrefs = new SharedPrefs();
  String title;
  Database database = new Database();

  void shared_init()async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    title = (sharedPrefs.getString('name') ?? "");
  }

  @override
  void initState(){
    super.initState();
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
        title: new Text("Add a Step",
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
        children: [Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(100), ScreenUtil().setWidth(70),
                  ScreenUtil().setWidth(100), 0),
              child: new TextFormField(
                controller: controller,
                focusNode: myFocusNode,
                onTap: _requestFocus,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                autofocus: false,
                cursorColor: Colors.black,
                decoration: new InputDecoration(
                    contentPadding:
                    EdgeInsets.all(ScreenUtil().setWidth(10)),
                    labelText: "Enter step",
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
                          AddStepToFirestore(
                              controller.text);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyHomePage(index: 2)),
                                  (Route<dynamic> route) => false);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Step is needed",
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


  void AddStepToFirestore(
      String description,
      ) {
    database.addOptimizer(description);
  }
}
