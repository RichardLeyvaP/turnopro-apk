// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/myApp.dart';
import 'package:turnopro_apk/providers.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  LoginController controllerLogin = LoginController();
  Get.put(controllerLogin);
  ShoppingCartController controllerShoppingCart = ShoppingCartController();
  Get.put(controllerShoppingCart);
  ClientsScheduledController controllerClient = ClientsScheduledController();
  Get.put(controllerClient);
  // Inicializa y guarda tu controlador en Get
  await initializeDateFormatting('es',
      null); //esto es para el paquete de el calendario que cargue el idioma español

  // Llamada para inicializar Flutter y su enlace con la plataforma
  WidgetsFlutterBinding.ensureInitialized();
  // Bloquear la orientación horizontal
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: providers,
        child: Myapp(),
      ),
    );
  });
}
