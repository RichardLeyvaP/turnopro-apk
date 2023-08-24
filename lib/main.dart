// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnopro_apk/Controllers/main.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  // Llamada para inicializar Flutter y su enlace con la plataforma
  WidgetsFlutterBinding.ensureInitialized();
  // Bloquear la orientación horizontal
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Myapp());
  });
}

// ignore: must_be_immutable
class Myapp extends StatelessWidget {
  Myapp({super.key});
  Color colorPrimario =
      const Color.fromARGB(255, 241, 130, 84); // Color primario appBar
  Color colorSecundario =
      const Color.fromARGB(155, 231, 232, 234); // Color secundario

  @override
  Widget build(Object context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          toolbarHeight: 120, // Cambia este valor según tus necesidades
          backgroundColor: colorPrimario,
        ),
        primaryColor: colorPrimario, // Color primario
        hintColor: colorSecundario,
        textTheme: GoogleFonts
            .poppinsTextTheme(), // Aplicar Poppins a todo el proyecto
        // Otras configuraciones de tema
      ),
      initialRoute: '/home',
      unknownRoute: GetPage(
        name: '/Error', // Nombre de la ruta de error
        page: () => const Page404(), // Página de error
      ),
      getPages: [
        GetPage(name: '/home', page: () => const HomePages()),
        GetPage(name: '/profile', page: () => const BarberProfile()),
        GetPage(
          name: '/RRRRRRRapiUsers',
          page: () => const UserPage(),
          binding: BindingsBuilder.put(() => MainController()),
        ), //ESTA ESTA CARGANDO UNA API
        GetPage(
            name: '/servicesProductsPage',
            page: () => const ServicesProductsPage()),
        GetPage(name: '/Error', page: () => const Page404()),
        GetPage(
          name: '/clients',
          page: () => const ShowCustomers(
              name: 'name',
              clicK: 1,
              typeCut: 'Normal',
              typeWashed: 'Lavado y secado'),
        ),
      ],
    );
  }
}
