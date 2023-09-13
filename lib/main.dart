// ignore_for_file: depend_on_referenced_packages
//'http://10.0.2.2:8000/api/rule'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/Components/auth_check.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/customer.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/main.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/homeResponsiblePage.dart';
import 'package:turnopro_apk/providers.dart';

void main() {
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
  final LoginController controller = Get.put(LoginController());
  Color colorPrimario =
      const Color.fromARGB(255, 241, 130, 84); // Color primario appBar
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
                textTheme: GoogleFonts
                    .poppinsTextTheme(), // Aplicar Poppins a todo el proyecto
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
        // initialRoute: '/login',
        // initialRoute: '/AuthCheck',
        initialRoute: '/login',
        unknownRoute: GetPage(
          name: '/Error', // Nombre de la ruta de error
          page: () => const Page404(), // Página de error
        ),
        getPages: [
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
            binding: BindingsBuilder.put(() => ServiceController()),
          ), //ESTA ESTA CARGANDO UNA API
          GetPage(
            name: '/NotificationsPageNew',
            page: () => const NotificationsPageNew(),
            binding: BindingsBuilder.put(() => NotificationController()),
          ),
          GetPage(
            name: '/clients',
            page: () => const CustomersPage(),
            binding: BindingsBuilder.put(() => CustomerController()),
          ), //ESTA ESTA CARGANDO UNA API
          GetPage(
            name: '/CoexistencePage',
            page: () => const CoexistencePage(),
            binding: BindingsBuilder.put(() => CoexistenceController()),
          ),
          GetPage(name: '/Error', page: () => const Page404()),
          GetPage(name: '/AuthCheck', page: () => const AuthCheck()),
        ],
      );
    });
  }
}
