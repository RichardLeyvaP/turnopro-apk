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
            progressIndicatorBackgroundColor: const Color(0xFF4470F3),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
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
            duration: const Duration(seconds: 4),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: const Color(0xFF4470F3),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 11, 3)),
            overlayBlur: 3,
          );
        });
        controllerLogin.setUsserMssQr(-99);
      }
      // Iniciar un temporizador de 2 segundos
      Timer(Duration(seconds: 2), () async {



        if (controllerLogin.chargeUserLoggedIn == "Barbero" ||
            (controllerLogin.chargeUserLoggedIn == "Barbero y Encargado" &&
                controllerLogin.switchValue == false)) {
          // Navegar a la nueva página
          //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
          //     usserPermissionQr = 1; //SE CREO CORRECTAMENTE EL QR
          // usserMssQr = 1; //SE CREO CORRECTAMENTE EL QR
          if (controllerLogin.usserMssQr == 1) {
            int resultP = await controllerLogin.insertPuesto(
                controllerLogin.professionalsQR,
                controllerLogin.workplaceidQR,
                0);
            int resultH = await controllerLogin.insertHoraEntrada(
                controllerLogin.professionalsQR,
                controllerLogin.branchIdLoggedIn);

            if (resultP == 1 &&
                resultH == 1) //td inserto correctamente la entrada
            {
              //mandar mensaje que td esta bien
            } else {
              //hubo problema al registrar la entrada
              controllerLogin.inputError();
            }
          }

          Get.offAllNamed('/Professional');
        } else if (controllerLogin.chargeUserLoggedIn == "Encargado") {
          int resultH = await controllerLogin.insertHoraEntrada(
              controllerLogin.professionalsQR,
              controllerLogin.branchIdLoggedIn);

          if (resultH == 1) //td inserto correctamente la entrada
          {
            //mandar mensaje que td esta bien
          } else {
            //hubo problema al registrar la entrada
            controllerLogin.inputError();
          }
          Get.offAllNamed('/HomeResponsible');
        } else if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
          //LLAMAR AL CONTROLADOR PARA INSERTARLO EN EL PUESTO DE TRABAJO
          if (controllerLogin.usserMssQr == 1) {
            int resultP = await controllerLogin.insertPuesto(
                controllerLogin.professionalsQR,
                controllerLogin.workplaceidQR,
                controllerLogin.placesQR);
            int resultH = await controllerLogin.insertHoraEntrada(
                controllerLogin.professionalsQR,
                controllerLogin.branchIdLoggedIn);
            if (resultP == 1 &&
                resultH == 1) //td inserto correctamente la entrada
            {
              //mandar mensaje que td esta bien
            } else {
              //hubo problema al registrar la entrada
              controllerLogin.inputError();
            }
          }
          Get.offAllNamed('/HomeTecnico');
        } else if (controllerLogin.chargeUserLoggedIn == "Coordinador") {
          int resultH = await controllerLogin.insertHoraEntrada(
              controllerLogin.professionalsQR,
              controllerLogin.branchIdLoggedIn);
          if (resultH == 1) //td inserto correctamente la entrada
          {
            //mandar mensaje que td esta bien
          } else {
            //hubo problema al registrar la entrada
            controllerLogin.inputError();
          }
          Get.offAllNamed('/HomeCordinador');
        } else {
          Get.offAllNamed('/LoginFormPage');
        }
        // } else {
        //   Get.offAllNamed('/LoginFormPage');
        // }

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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDAE2A)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFDAE2A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
