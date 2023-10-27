import 'package:turnopro_apk/Routes/index.dart';

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
