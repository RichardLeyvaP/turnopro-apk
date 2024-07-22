import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:turnopro_apk/dependency_injection.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    DependencyInjection.registerDependencies();
    await initializeDateFormatting('es', null);

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
