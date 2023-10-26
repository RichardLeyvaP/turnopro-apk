// ignore_for_file: depend_on_referenced_packages
//'http://10.0.2.2:8000/api/rule'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/myApp.dart';
import 'package:turnopro_apk/providers.dart';

void main() {
  // Inicializa y guarda tu controlador en Get
  ShoppingCartController controllerShoppingCart = ShoppingCartController();
  Get.put(controllerShoppingCart);

  ServiceController controllerService = ServiceController();
  Get.put(controllerService);

  ProductController controllerProduct = ProductController();
  Get.put(controllerProduct);

  LoginController controllerLogin = LoginController();
  Get.put(controllerLogin);

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
