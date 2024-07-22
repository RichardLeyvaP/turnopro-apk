import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;
  /*static final StreamController<bool> _stateStreamController =
      StreamController<bool>.broadcast();*/

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /* static Stream<bool> get stateStream => _stateStreamController.stream;

  static Future<void> setStatePlano(bool value) async {
    await prefs.setBool('state_S_plano', value);
    _stateStreamController.add(value);
  }

  static bool getStatePlano() {
    return prefs.getBool('state_S_plano') ?? false;
  }*/
}
