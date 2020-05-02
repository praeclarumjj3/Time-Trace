import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/add_step.dart';
import 'package:time_trace/step_card.dart';
import 'package:time_trace/today.dart';

import 'firestore.dart';

class MyListPage extends StatefulWidget {

  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  Database database = new Database();
  Future<List<String>> steps;
  String title;


  void shared_init()async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    // title = (sharedPrefs.getString('name') ?? "");
  }

  @override
  void initState() {
    super.initState();
    //shared_init();
    title = "JJ";
    steps = database.getSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340, allowFontScaling: true);
    return Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: true,
            title: new Text("$title's Steps to Success",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize:
                        ScreenUtil().setSp(40, allowFontScalingSelf: true),
                        color: Colors.white))),
            backgroundColor: Colors.blue,
            centerTitle: false,
          ),
          body: Steps(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        mini: true,
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              AddStep()),
        ); },
      ),
    );
  }


  Widget Steps() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            child: FutureBuilder<List>(
              future: steps,
              builder: (context, snapshot) {
                print(snapshot.hasData);
                return snapshot.hasData
                    ? snapshot.data.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Add Steps to better utilize your time $title!",
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
                    return StepCard(
                      string: snapshot.data[position],
                      position: position+1,
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