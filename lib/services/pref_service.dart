import 'package:shared_preferences/shared_preferences.dart';

enum PrefType { Bool, Double, Int, String, StringList }

class PrefService {
  SharedPreferences prefs;

  void initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<dynamic> getPref(String key, PrefType type) async {
    if (prefs == null) initializePrefs();

    switch (type) {
      case PrefType.Bool:
        return prefs.getBool(key);
        break;
      case PrefType.Double:
        return prefs.getDouble(key);
        break;
      case PrefType.Int:
        return prefs.getInt(key);
        break;
      case PrefType.String:
        return prefs.getString(key);
        break;
      case PrefType.StringList:
        return prefs.getStringList(key);
        break;
    }
  }

  void setPref(String key, dynamic value, PrefType type) async {
    if (prefs == null) initializePrefs();

    switch (type) {
      case PrefType.Bool:
        prefs.setBool(key, value);
        break;
      case PrefType.Double:
        prefs.setDouble(key, value);
        break;
      case PrefType.Int:
        prefs.setInt(key, value);
        break;
      case PrefType.String:
        prefs.setString(key, value);
        break;
      case PrefType.StringList:
        prefs.setStringList(key, value);
        break;
    }
  }
}
