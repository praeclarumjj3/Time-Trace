import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/home.dart';


class NamePage extends StatefulWidget {


  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {

  FocusNode myFocusNode;
  TextEditingController controller;
//  SharedPrefs sharedPrefs = new SharedPrefs();
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @override
  void initState() {
    super.initState();
    myFocusNode = new FocusNode();
    controller = new TextEditingController();
    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print(controller.text);
        });
      },
    );
  }


  @override
  void dispose() {
    myFocusNode.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
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
          title: new Text("Time Trace",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize:
                      ScreenUtil().setSp(50, allowFontScalingSelf: true),
                      color: Colors.white))),
          backgroundColor: Colors.blue,
          centerTitle: false,
        ),
        body: new Container(
          color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: new LayoutBuilder(builder: (context, constraint) {
              return new Icon(Icons.watch_later,
                  color: Colors.blue,
                  size: _keyboardState?ScreenUtil().setWidth(500):ScreenUtil().setWidth(800));
            }),
          ),
          showNameInput(),
          Align(alignment: Alignment.bottomCenter,
              child: btn())
        ],
      ),
    ));
  }


  Widget showNameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(100), 0, ScreenUtil().setWidth(100), 0.0),
      child: new TextFormField(
        controller: controller,
        focusNode: myFocusNode,
        onTap: _requestFocus,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.black,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(ScreenUtil().setWidth(10)),
            labelText: "Enter Name",
            labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize:
                    ScreenUtil().setSp(40, allowFontScalingSelf: true),
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
            )),
    ));
  }

  void save() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('name', "123");
  }


    Widget btn(){
    return ButtonTheme(
          height: ScreenUtil().setHeight(45),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(70), ScreenUtil().setWidth(20), ScreenUtil().setWidth(70),
                ScreenUtil().setWidth(20)),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              if(controller.text !=null && controller.text.length>0){
                save();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => MyHomePage(index: 0,)),
                        (Route<dynamic> route) => false);
              }
              else{
                Fluttertoast.showToast(
                    msg: "Name is needed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: ScreenUtil().setSp(40, allowFontScalingSelf: true)
                );
              }
            },
            elevation: ScreenUtil().setWidth(5),
            color: Colors.blue,
            shape: new RoundedRectangleBorder(
              borderRadius:
              new BorderRadius.circular(ScreenUtil().setWidth(30)),
            ),
            child: new Text("Start tracking",
                style: GoogleFonts.poppins(
                    textStyle: new TextStyle(
                        fontSize: ScreenUtil()
                            .setSp(50, allowFontScalingSelf: true),
                        color: Colors.white))),
          ),
    );

  }



}
