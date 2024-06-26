import 'package:shared_preferences/shared_preferences.dart';

class DataStorageSP {
  Future<String> getData(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? data = sp.getString(key);
    if (data != null) {
      return data;
    }
    return '';
  }

  Future<void> saveData(String value, String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  Future<void> saveCountdown(int value, String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, value);
  }

   Future<int> getCountdown(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final int? data = sp.getInt(key);
    if (data != null) {
      return data;
    }
    return 0;
  }

  Future<bool> getDataBool(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool? data = sp.getBool(key);
    if (data != null) {
      return data;
    }
    return false;
  }

  Future<void> saveDataBool(bool value, String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
  }
}
