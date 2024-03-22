import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoadingPage(),
    );
  }
}

class MyLoadingPage extends StatefulWidget {
  @override
  _MyLoadingPageState createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {
  final LoginController controllerLogin = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    // Iniciar un temporizador de 2 segundos
    Timer(Duration(seconds: 2), () async {
//VERIFICAR QUE ESTE TODO BIEN
      //     int professionalsQR = -99;
      // int workplaceidQR = -99;
      // List<int>? placesQR = [];
      print(
          'esto es lo que object-professionalsQR:${controllerLogin.professionalsQR}');
      print('esto es lo que object-placesQR:${controllerLogin.placesQR}');
      print(
          'esto es lo que object-workplaceidQR:${controllerLogin.workplaceidQR}');

      if (controllerLogin.chargeUserLoggedIn == "Barbero") {
        // Navegar a la nueva página
        //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
        await controllerLogin.insertPuesto(
            controllerLogin.professionalsQR, controllerLogin.workplaceidQR, 0);
        Get.offAllNamed('/Professional');
      } else if (controllerLogin.chargeUserLoggedIn == "Encargado") {
        Get.offAllNamed('/HomeResponsible');
      } else if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
        //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
        await controllerLogin.insertPuesto(controllerLogin.professionalsQR,
            controllerLogin.workplaceidQR, controllerLogin.placesQR);
        Get.offAllNamed('/HomeTecnico');
      } else if (controllerLogin.chargeUserLoggedIn == "Cordinador") {
        Get.offAllNamed('/HomeCordinador');
      } else {
        print('esto es lo que viene:${controllerLogin.chargeUserLoggedIn}');
        print('esto es lo que branchIdQR:${controllerLogin.branchIdQR}');
        print('esto es lo que branchIdQR:${controllerLogin.idQR}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF18254)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFF18254),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
