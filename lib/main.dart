import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnopro_apk/routes/index.dart';
import 'package:flutter/services.dart';

void main() {
  // Llamada para inicializar Flutter y su enlace con la plataforma
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquear la orientación horizontal
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Myapp());
  });
}

class Myapp extends StatelessWidget {
  Myapp({super.key});
  // rutas disponibles en la app.
  // cada widget es una página diferente.
  final _routes = {
    '/': (context) => const HomePages(),
    '/profile': (context) => const BarberProfile(),
    '/servicesPage': (context) => const ServicesProductsPage(),
    '/productsPage': (context) => const ProductsPage(),
    '/servicesProductsPage': (context) => const ServicesProductsPage(),
    '/clients': (context) => const ShowCustomers(
        name: 'name',
        clicK: 1,
        typeCut: 'Normal',
        typeWashed: 'Lavado y secado'),
    //'/profile': (context) => const OtraPage(),
    // '/services': (context) => const ServiciosPage(),
  };

  @override
  Widget build(Object context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 241, 130, 84), // Color primario
        hintColor: const Color.fromARGB(155, 231, 232, 234), // Color secundario
        textTheme: GoogleFonts
            .poppinsTextTheme(), // Aplicar Poppins a todo el proyecto
        // Otras configuraciones de tema
      ),

      debugShowCheckedModeBanner: false,
      //home: const BarberProfile(),
      initialRoute: '/',
      routes: _routes,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Page404(),
        );
      },

      /* theme: ThemeData(
            useMaterial3: false,
            colorSchemeSeed: const Color.fromARGB(
                255, 241, 212, 74)),*/ //al cambiar a true cambia el estilo
    );
  }
}
