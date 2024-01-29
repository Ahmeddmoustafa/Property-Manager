import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String keyLastUpdateDate = 'lastUpdateDate';

  // Function to update the date
  static Future<void> updateAppStatus() async {
    await _setUpdateDate(DateTime.now());
  }

  static Future<void> _setUpdateDate(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastUpdateDate, date.toIso8601String());
  }

  static Future<bool> isLocalUpdated() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastUpdateDate = await getUpdateDate();

    if (lastUpdateDate == null) {
      return false; // If no update date is set, consider it that the user opens from new device
    } else {
      // Check if the time difference is more than 30 minutes
      final Duration difference = DateTime.now().difference(lastUpdateDate);
      return difference.inMinutes < 30;
    }
  }

  static Future<DateTime?> getUpdateDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(keyLastUpdateDate);
    return dateString != null ? DateTime.parse(dateString) : null;
  }
}

// class AppPreferencess {
//   static const String keyAppUpdated = 'appUpdated';
//   static const String keyLastUpdateDate = 'lastUpdateDate';

//   static Future<void> setAppUpdated(bool updated) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(keyAppUpdated, updated);
//   }

//   static Future<void> setUpdateDate(DateTime date) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(keyLastUpdateDate, date.toIso8601String());
//   }

//   static Future<bool> isUpdated() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(keyAppUpdated) ?? true;
//   }

//   static Future<DateTime?> getUpdateDate() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final dateString = prefs.getString(keyLastUpdateDate);
//     return dateString != null ? DateTime.parse(dateString) : null;
//   }

//   // Function to update both values
//   static Future<void> updateAppStatus(bool updated, DateTime date) async {
//     await setAppUpdated(updated);
//     await setUpdateDate(date);
//   }
// }
