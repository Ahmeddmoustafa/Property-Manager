import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencess {
  static const String keyAppUpdated = 'appUpdated';
  static const String keyLastUpdateDate = 'lastUpdateDate';

  static Future<void> setAppUpdated(bool updated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAppUpdated, updated);
  }

  static Future<void> setUpdateDate(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastUpdateDate, date.toIso8601String());
  }

  static Future<bool> isUpdated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAppUpdated) ?? true;
  }

  static Future<DateTime?> getUpdateDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(keyLastUpdateDate);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  // Function to update both values
  static Future<void> updateAppStatus(bool updated, DateTime date) async {
    await setAppUpdated(updated);
    await setUpdateDate(date);
  }
}
