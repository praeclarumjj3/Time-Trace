

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trace/sharedprefs.dart';
import 'package:time_trace/task.dart';

class Database {

  final databaseReference = Firestore.instance;


  Future<void> addTask(String description, String duration, String date,
      bool status) async {
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
//    name = "jj";

    DocumentReference ref = await databaseReference.collection("jj")
        .add({
      'description': description,
      'duration': duration,
      'date': date,
      'status': status
    });
    print(ref.documentID);
  }



  Future UpdateTask(Task task, String description, String duration, String date,
      bool status) async {
    final id = await GetTaskID(task);
    await databaseReference
        .collection('jj')
        .document(id)
        .updateData({
      'description': description,
      'duration': duration,
      'date': date,
      'status': status
    });
  }


  Future<String> GetTaskID(Task task) async {
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
    var id;
    List<DocumentSnapshot> templist;
    List<Task> _ = new List();
    QuerySnapshot taskSnapshot = await databaseReference.collection("jj")
        .getDocuments();
    templist = taskSnapshot.documents;
    _ = templist.map((DocumentSnapshot docSnapshot) {
      var taskFetched = docSnapshot.data;
      if (taskFetched['date'] == task.date &&
          taskFetched['description'] == task.description) {
        id = docSnapshot.documentID;
      }
    }).toList();
    return id;
  }

  Future<void> deleteTask(Task task) async {
    try {
//        final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//        String name = sharedPrefs.getString('name');
//        name = "jj";
      final id = await GetTaskID(task);
      await databaseReference.collection("jj")
          .document(id)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future <List<Task>> getTasks() async {
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
//    name = "jj";
    List<DocumentSnapshot> templist;
    List<Task> tasksList = new List();
    QuerySnapshot tasksSnapshot = await databaseReference.collection("jj")
        .getDocuments();
    templist = tasksSnapshot.documents;
    tasksList = templist.map((DocumentSnapshot docSnapshot) {
      var task = docSnapshot.data;
      Task taskObj = new Task(
          task['description'], task['duration'], task['date'], task['status']);
      return taskObj;
    }).toList();
    return tasksList;
  }

  Future<List<Task>> determineDatedTasks(String Date) async {
    var datedTasks = new List<Task>();
    //TODO: Find optimization solution.
    var tasks = await getTasks();

    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].date == Date) {
        datedTasks.add(tasks[i]);
      }
    }
    return datedTasks;
  }


  Future <String> getTotalTaskDuration(String Date) async {
    var tasks = await determineDatedTasks(Date);
    int seconds = 0;
    int minutes = 0;
    int hrs = 0;

    if (tasks != null && tasks.length > 0) {
      for (int i = 0; i < tasks.length; i++) {
        String elapsedTime = tasks[i].duration;
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


    }
    String hoursStr = ((hrs) % 24).toString().padLeft(1, '0');
    String minutesStr = ((minutes) % 60).toString().padLeft(2, '0');
    String secondsStr = ((seconds) % 60).toString().padLeft(2, '0');
    return "$hoursStr:$minutesStr:$secondsStr";
  }


  Future<void> addOptimizer(String string) async{
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
//    name = "jj";

    await databaseReference.collection('jj').document("optimizers").collection('steps to improve').add({
      'step': string,
    });

  }

  Future<List<String>> getSteps() async{
    //    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
//    name = "jj";
    List<DocumentSnapshot> templist;
    List<String> stepsList = new List();
    QuerySnapshot stepsSnapshot = await databaseReference.collection("jj").document("optimizers").collection("steps to improve")
        .getDocuments();
    templist = stepsSnapshot.documents;
    stepsList = templist.map((DocumentSnapshot docSnapshot) {
      var step = docSnapshot.data['step'];
      String optimizer = step.toString();
      return optimizer;
    }).toList();
    return stepsList;
  }

  Future<String> GetOptimizerID(String string) async {
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    String name = sharedPrefs.getString('name');
    var id;
    List<DocumentSnapshot> templist;
    List<Task> _ = new List();
    QuerySnapshot taskSnapshot = await databaseReference.collection("jj").document("optimizers").collection("steps to improve")
        .getDocuments();
    templist = taskSnapshot.documents;
    _ = templist.map((DocumentSnapshot docSnapshot) {
      var taskFetched = docSnapshot.data;
      if (taskFetched['step'] == string) {
        id = docSnapshot.documentID;
      }
    }).toList();
    return id;
  }

  Future<void> deleteOptimizer(String string) async{

    try {
//        final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//        String name = sharedPrefs.getString('name');
//        name = "jj";
      final id = await GetOptimizerID(string);
      await databaseReference.collection('jj').document("optimizers").collection('steps to improve')
          .document(id)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

}
