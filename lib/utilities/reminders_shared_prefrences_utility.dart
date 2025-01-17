import 'package:shared_preferences/shared_preferences.dart';

class RemindersSharedPrefrencesUtility {
  static const String _notificationPermissionAskedKey =
      'notificationPermissionAsked';

  static final List<String> _keys = [
    _notificationPermissionAskedKey,
  ];

  // notificationPermissionAskedKey
  static Future<void> setNotificationPermissionAsked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPermissionAskedKey, true);
  }

  static Future<bool> getNotificationPermissionAsked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPermissionAskedKey) ?? false;
  }

  // clear
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.wait(_keys.map((key) => prefs.remove(key)));
  }
}
