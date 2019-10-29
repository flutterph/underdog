import 'package:shared_preferences/shared_preferences.dart';
import 'package:underdog/data/models/user.dart';

import '../pref_keys.dart';

enum PrefType { Bool, Double, Int, String, StringList }

class PrefService {
  SharedPreferences prefs;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<dynamic> getPref(String key, PrefType type) async {
    if (prefs == null) {
      await initializePrefs();
    }

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

  Future<void> setPref(String key, dynamic value, PrefType type) async {
    if (prefs == null) {
      await initializePrefs();
    }

    switch (type) {
      case PrefType.Bool:
        await prefs.setBool(key, value);
        break;
      case PrefType.Double:
        await prefs.setDouble(key, value);
        break;
      case PrefType.Int:
        await prefs.setInt(key, value);
        break;
      case PrefType.String:
        await prefs.setString(key, value);
        break;
      case PrefType.StringList:
        await prefs.setStringList(key, value);
        break;
    }
  }

  Future<User> getUserInPrefs() async {
    return User(
      uid: await getPref(PrefKeys.USER_UID, PrefType.String),
      email: await getPref(PrefKeys.USER_EMAIL, PrefType.String),
      displayPhotoUrl:
          await getPref(PrefKeys.USER_DISPLAY_PHOTO_URL, PrefType.String),
      firstName: await getPref(PrefKeys.USER_FIRST_NAME, PrefType.String),
      lastName: await getPref(PrefKeys.USER_LAST_NAME, PrefType.String),
    );
  }

  Future<void> setUserPrefs(User user) async {
    await setPref(PrefKeys.USER_UID, user.uid, PrefType.String);
    await setPref(PrefKeys.USER_EMAIL, user.email, PrefType.String);
    await setPref(PrefKeys.USER_FIRST_NAME, user.firstName, PrefType.String);
    await setPref(PrefKeys.USER_LAST_NAME, user.lastName, PrefType.String);
    await setPref(PrefKeys.USER_DISPLAY_NAME,
        '${user.firstName} ${user.lastName}', PrefType.String);
  }

  Future<void> clearUserPrefs() async {
    prefs = await SharedPreferences.getInstance();

    prefs.remove(PrefKeys.USER_UID);
    prefs.remove(PrefKeys.USER_EMAIL);
    prefs.remove(PrefKeys.USER_FIRST_NAME);
    prefs.remove(PrefKeys.USER_LAST_NAME);
    prefs.remove(PrefKeys.USER_DISPLAY_NAME);
  }
}
