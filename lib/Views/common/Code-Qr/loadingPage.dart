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
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controllerLogin.usserMssQr == 1) {
        Timer(Duration(seconds: 3), () async {
          Get.snackbar(
            '',
            'Hola, ${controllerLogin.userNameQR} puede prestar servicios,hora de entrada: ${controllerLogin.horaQR}',
            colorText: const Color.fromARGB(255, 43, 44, 49),
            titleText: const Text('Mensaje'),
            duration: const Duration(seconds: 4),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 81, 93, 117),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 130, 84)),
            overlayBlur: 3,
          );
          controllerLogin.setUsserMssQr(-99);
        });
      } else if (controllerLogin.usserMssQr == 0) {
        Timer(Duration(seconds: 3), () async {
          Get.snackbar(
            '',
            'Hola, ${controllerLogin.userNameQR} No coincide el código Qr con la Sucursal que entraste en la aplicación',
            colorText: const Color.fromARGB(255, 43, 44, 49),
            titleText: const Text('Error'),
            duration: const Duration(seconds: 3),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 81, 93, 117),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 11, 3)),
            overlayBlur: 3,
          );
        });
        controllerLogin.setUsserMssQr(-99);
      }
      // Iniciar un temporizador de 2 segundos
      Timer(Duration(seconds: 2), () async {
//VERIFICAR QUE ESTE TODO BIEN

        print(
            'esto es lo que object-professionalsQR:${controllerLogin.professionalsQR}');
        print('esto es lo que object-placesQR:${controllerLogin.placesQR}');
        print(
            'esto es lo que object-workplaceidQR:${controllerLogin.workplaceidQR}');

        if (controllerLogin.chargeUserLoggedIn == "Barbero") {
          // Navegar a la nueva página
          //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
          await controllerLogin.insertPuesto(controllerLogin.professionalsQR,
              controllerLogin.workplaceidQR, 0);
          Get.offAllNamed('/Professional');
        } else if (controllerLogin.chargeUserLoggedIn == "Encargado") {
          Get.offAllNamed('/HomeResponsible');
        } else if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
          //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
          await controllerLogin.insertPuesto(controllerLogin.professionalsQR,
              controllerLogin.workplaceidQR, controllerLogin.placesQR);
          Get.offAllNamed('/HomeTecnico');
        } else if (controllerLogin.chargeUserLoggedIn == "Coordinador") {
          Get.offAllNamed('/HomeCordinador');
        } else {
          Get.offAllNamed('/LoginFormPage');
        }
      });
    });
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //

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
