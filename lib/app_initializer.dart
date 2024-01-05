import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    await initializeDateFormatting('es', null);

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _registerControllers();
  }

  static void _registerControllers() {
    Get.put(LoginController());
    Get.put(ShoppingCartController());
    Get.put(ClientsScheduledController());
    Get.put(ClientsTechnicalController());
    Get.put(StatisticController());
    Get.put(PagesConfigController());
    Get.put(PagesConfigResponController());
  }
}
