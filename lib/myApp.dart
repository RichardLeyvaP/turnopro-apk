// ignore_for_file: depend_on_referenced_packages
//'http://api.simplifies.cl/api/rule'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Components/auth_check.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/customer.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/main.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
// import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
//import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/Code-Qr/CodeQrPage.dart';
import 'package:turnopro_apk/Views/homeResponsiblePage.dart';
import 'package:turnopro_apk/Views/loginFormPage.dart';
import 'package:turnopro_apk/Views/loginNewPage.dart';
import 'package:turnopro_apk/Views/professional/notificationsPage.dart';
import 'package:turnopro_apk/Views/shoppingCartPage.dart';
import 'package:turnopro_apk/providers.dart';

void main() {
  // Inicializa y guarda tu controlador en Get
  ShoppingCartController controllerShoppingCart = ShoppingCartController();
  Get.put(controllerShoppingCart);

  ServiceController controllerService = ServiceController();
  Get.put(controllerService);

  ProductController controllerProduct = ProductController();
  Get.put(controllerProduct);

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

// ignore: must_be_immutable
class Myapp extends StatelessWidget {
  Myapp({super.key});
  final LoginController controllerasas = Get.put(LoginController());
  Color colorPrimario = const Color(0xFFF18254); // Color primario appBar
  Color colorSecundario =
      const Color.fromARGB(155, 231, 232, 234); // Color secundario
  Color colorPrimario2 =
      const Color.fromARGB(255, 26, 50, 82); // Color primario appBar
  Color colorSecundario2 =
      const Color.fromARGB(155, 36, 86, 185); // Color secundario

  @override
  Widget build(Object context) {
    return GetBuilder<LoginController>(builder: (_) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _.pagina == '/home'
            ? ThemeData(
                appBarTheme: AppBarTheme(
                  toolbarHeight: 120, // Cambia este valor según tus necesidades
                  backgroundColor: colorPrimario,
                ),
                primaryColor: colorPrimario, // Color primario
                hintColor: colorSecundario,
                textTheme: GoogleFonts.poppinsTextTheme(
                    /* const TextTheme(
                    displayLarge:
                        TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                    titleMedium: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    titleSmall: TextStyle(
                        fontSize: 12, color: Color.fromARGB(148, 0, 0, 0)),
                    bodyLarge: TextStyle(fontSize: 17.0, fontFamily: 'Hind'),
                  ),*/
                    ),

                // Aplicar Poppins a todo el proyecto
                // Otras configuraciones de tema
              )
            : ThemeData(
                appBarTheme: AppBarTheme(
                  toolbarHeight: 120, // Cambia este valor según tus necesidades
                  backgroundColor: colorPrimario2,
                ),
                primaryColor: colorPrimario2, // Color primario
                hintColor: colorSecundario2,
                textTheme: GoogleFonts
                    .poppinsTextTheme(), // Aplicar Poppins a todo el proyecto

                // Otras configuraciones de tema
              ),
        initialRoute: '/SplashPage',
        unknownRoute: GetPage(
          name: '/Error', // Nombre de la ruta de error
          page: () => const Page404(), // Página de error
        ),
        getPages: [
          GetPage(
            name: '/SplashPage',
            page: () => const SplashPage(),
          ),
          GetPage(
            name: '/home',
            page: () => const HomePages(),
            binding: BindingsBuilder.put(() => LoginController()),
          ),
          GetPage(
            name: '/HomeResponsible',
            page: () => const HomeResponsiblePages(),
            binding: BindingsBuilder.put(() => LoginController()),
          ),
          GetPage(
            name: '/loginNewPage',
            page: () => const LoginNewPage(),
            binding: BindingsBuilder.put(() => LoginController()),
          ),
          GetPage(
            name: '/LoginFormPage',
            page: () => LoginFormPage(),
            binding: BindingsBuilder.put(() => LoginController()),
          ),
          GetPage(
            name: '/login',
            page: () => LoginPage(),
            binding: BindingsBuilder.put(() => LoginController()),
          ),
          GetPage(
            name:
                '/RapiUsers', //*ESTA RUTA ESTA MAL A PROPOSITO LA RUTA REAL ES /apiUsers
            page: () => const UserPage(),
            binding: BindingsBuilder.put(() => MainController()),
          ), //ESTA ESTA CARGANDO UNA API
          GetPage(
            name: '/servicesProductsPage',
            page: () => const ServicesProductsPage(),
          ), //ESTA ESTA CARGANDO UNA API
          GetPage(
            name: '/NotificationsPageNew',
            page: () => NotificationsPageNew(),
            binding: BindingsBuilder.put(() => NotificationController()),
          ),
          GetPage(
            name: '/NotificationsPageProf',
            page: () => NotificationsPageProf(),
            binding: BindingsBuilder.put(() => NotificationController()),
          ),
          GetPage(
            name: '/clients',
            page: () => CustomersPage(),
            binding: BindingsBuilder.put(() => CustomerController()),
          ), //ESTA ESTA CARGANDO UNA API
          GetPage(
            name: '/CoexistencePage',
            page: () => const CoexistencePage(),
            binding: BindingsBuilder.put(() => CoexistenceController()),
          ),
          GetPage(name: '/Error', page: () => const Page404()),
          GetPage(name: '/AuthCheck', page: () => const AuthCheck()),
          // GetPage(name: '/CodeQrPage', page: () => const CodeQrPage()),
          GetPage(name: '/QRViewExample', page: () => const QRViewPage()),
          GetPage(name: '/ShoppingCartPage', page: () => ShoppingCartPage()),
          // GetPage(
          //   name: '/ProductPage',
          //   page: () => const CoexistencePage(),
          //   binding: BindingsBuilder.put(() => ProductController()),
          // ),
        ],
      );
    });
  }
}
