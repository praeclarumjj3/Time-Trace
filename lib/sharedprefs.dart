import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  Future<void> save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }


  Future SaveName(String name) async{
    await save("name", name);
  }




  Future<String> getNameOfUser() async{
    String name;
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    name= (sharedPrefs.getString("name") ?? "");
    return name;

  }


}