import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Async func to handle Futures easier; or use Future.then
  static late SharedPreferences prefs;
  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
