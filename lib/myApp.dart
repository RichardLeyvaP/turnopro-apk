// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:turnopro_apk/Views/common/auth_check.dart';
import 'package:turnopro_apk/Routes/index.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnopro_apk/Views/coordinator/assign/assignProfessional.dart';
import 'package:turnopro_apk/Views/coordinator/homeCoordinator/homeCoordinatorPage.dart';
import 'package:turnopro_apk/Views/coordinator/product/productClient.dart';
import 'package:turnopro_apk/Views/coordinator/profile/profileClient.dart';
import 'package:turnopro_apk/Views/coordinator/services/servicesClient.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/clientsScheduled(NO%20UTILIZADA).dart';
import 'package:turnopro_apk/Views/professional/statistic/statisticPage.dart';
import 'package:turnopro_apk/Views/responsible/coexistencePageResponsible.dart';
import 'package:turnopro_apk/Views/responsible/homeResponsiblePage.dart';
import 'package:turnopro_apk/Views/professional/shoppingCartPage.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/statisticPage_R.dart';
import 'package:turnopro_apk/Views/tecnico/homeTecnico/homePageTecnico.dart';

//todo este es el que me falta optimizar
class Myapp extends StatelessWidget {
  Myapp({super.key});
  final LoginController controllerasas = Get.put(LoginController());
  final Color colorPrimario = const Color(0xFFF18254); // Color primario appBar
  final Color colorSecundario =
      const Color.fromARGB(155, 231, 232, 234); // Color secundario
  final Color colorPrimario2 =
      const Color.fromARGB(255, 26, 50, 82); // Color primario appBar
  final Color colorSecundario2 =
      const Color.fromARGB(155, 36, 86, 185); // Color secundario

  @override
  Widget build(Object context) {
    return GetBuilder<LoginController>(builder: (_) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _.pagina == '/Professional'
            ? themeDataProfessional()
            : (_.pagina == '/HomeResponsible' || _.pagina == '/HomeCordinador')
                ? themeDataResponsible()
                : themeDataProfessional(), //themeDataTecnico(), //es tecnico
        initialRoute: '/SplashPage',
        //initialRoute: '/SplashPage',
        unknownRoute: GetPage(
          name: '/Error', // Nombre de la ruta de error
          page: () => const Page404(), // Página de error
        ),
        getPages: routes,
      );
    });
  }

  List<GetPage<dynamic>> get routes {
    return [
      GetPage(
        name: '/SplashPage',
        page: () => const SplashPage(),
      ),
      GetPage(
        name: '/StatisticPage',
        page: () => const StatisticPage(),
        binding: BindingsBuilder.put(() => StatisticController()),
      ),
      GetPage(
        name: '/Professional',
        page: () => const HomePages(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/HomeResponsible',
        page: () => const HomeResponsiblePages(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/HomeTecnico',
        page: () => const HomePagesTecnico(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/HomeCordinador', //todo cordinador
        //page: () => const ServicesClient(),
        //page: () => const ProductClient(),
        // page: () => const AssignProfessional(),//ya asignado
        //page: () => const ProfileClient(),
        page: () => const HomeCoordinatorPages(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/coexistencePageResponsible',
        page: () => ProfileClient(),
        binding: BindingsBuilder.put(() => CoexistenceController()),
      ),
      GetPage(
        name: '/StatisticPageRespon',
        page: () => const StatisticPageRespon(),
        binding: BindingsBuilder.put(() => StatisticController()),
      ),
      GetPage(
        name: '/loginNewPage',
        page: () => LoginNewPage(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/LoginFormPage',
        page: () => LoginFormPage(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),

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
        page: () => const ClientsScheduled(),
        binding: BindingsBuilder.put(() => ClientsScheduledController()),
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
    ];
  }

  ThemeData themeDataProfessional() {
    print('themeDataProfessional');
    return ThemeData(
      appBarTheme: AppBarTheme(
        toolbarHeight: 120, // Cambia este valor según tus necesidades
        backgroundColor: colorPrimario,
      ),
      primaryColor: colorPrimario, // Color primario
      hintColor: colorSecundario,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }

  ThemeData themeDataResponsible() {
    print('themeDataResponsible');
    return ThemeData(
      appBarTheme: AppBarTheme(
        toolbarHeight: 120, // Cambia este valor según tus necesidades
        backgroundColor: colorPrimario2,
      ),
      primaryColor: colorPrimario2, // Color primario
      hintColor: colorSecundario2,
      textTheme:
          GoogleFonts.poppinsTextTheme(), // Aplicar Poppins a todo el proyecto

      // Otras configuraciones de tema
    );
  }

  ThemeData themeDataTecnico() {
    print('themeDataTecnico');
    return ThemeData(
      appBarTheme: const AppBarTheme(
        toolbarHeight: 120, // Cambia este valor según tus necesidades
        backgroundColor: Colors.brown,
      ),
      primaryColor: Colors.deepPurpleAccent, // Color primario
      hintColor: Colors.brown,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
