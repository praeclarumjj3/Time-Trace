import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class TimeTracked {
  String date;
  num duration;
  charts.Color barColor;

  TimeTracked({ @required this.date, @required this.duration, @required this.barColor});

}