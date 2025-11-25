import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:intl/intl.dart';

import '../../../services/background_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      void mensjeOk() {
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
      }

      void mensjeError() {
        Get.snackbar(
          '',
          'Hola, ${controllerLogin.userNameQR} hubo problema de conexión al leer el Qr,inténtalo nuevamente',
          colorText: const Color.fromARGB(255, 43, 44, 49),
          titleText: const Text('Error'),
          duration: const Duration(seconds: 4),
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: const Color(0xFF4470F3),
          progressIndicatorValueColor:
              const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 11, 3)),
          overlayBlur: 3,
        );
        controllerLogin.setUsserMssQr(-99);
      }

      void mensjeNot() {
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
        controllerLogin.setUsserMssQr(-99);
      }
      //
      //
      //
      //
      //
      //

      if (controllerLogin.chargeUserLoggedIn == "Profesional" ||
          (controllerLogin.chargeUserLoggedIn == "Profesional y Encargado" &&
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
            mensjeOk();
            await initializeService();
            await clientsScheduledController.fetchClientsScheduled(
                controllerLogin.professionalsQR,
                controllerLogin.branchIdLoggedIn,
                'despues de leer qr');
          } else {
            //hubo problema al registrar la entrada
            mensjeError();
            controllerLogin.inputError();
          }
        } else if (controllerLogin.usserMssQr == 0) {
          mensjeNot(); //no coincide el Qr
        }
        // print(
        //     'datos del profesional - Usuario:${LocalStorage.prefs.getString('EntryFootprintUser')}');
        // print(
        //     'datos del profesional - Pass:${LocalStorage.prefs.getString('EntryFootprintPass')}');
        // print(
        //     'datos del profesional - Pass:${LocalStorage.prefs.getInt('EntryFootprintBranch')}');
        Get.offAllNamed('/Professional');
      } else if (controllerLogin.chargeUserLoggedIn == "Encargado") {
        if (controllerLogin.usserMssQr == 1) {
          int resultH = await controllerLogin.insertHoraEntrada(
              controllerLogin.professionalsQR,
              controllerLogin.branchIdLoggedIn);

          if (resultH == 1) //td inserto correctamente la entrada
          {
            //mandar mensaje que td esta bien
            mensjeOk();
            await initializeService();
          } else {
            //hubo problema al registrar la entrada
            mensjeError();
            controllerLogin.inputError();
          }
        } else if (controllerLogin.usserMssQr == 0) {
          mensjeNot(); //no coincide el Qr
        }
        Get.offAllNamed('/HomeResponsible');
      } else if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
        final ClientsScheduledController clientsSchedCont =
            Get.find<ClientsScheduledController>();
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
            mensjeOk();
            await initializeService();
            clientsSchedCont
                .fetchClientsTechnical(loginController.branchIdLoggedIn);
          } else {
            //hubo problema al registrar la entrada
            mensjeError();
            controllerLogin.inputError();
          }
        } else if (controllerLogin.usserMssQr == 0) {
          mensjeNot(); //no coincide el Qr
        }
        Get.offAllNamed('/HomeTecnico');
      } else if (controllerLogin.chargeUserLoggedIn == "Coordinador") {
        final ClientsCoordinatorController clientCont =
            Get.find<ClientsCoordinatorController>();
        final ShoppingCartController shopCont =
            Get.find<ShoppingCartController>();
        int resultH = await controllerLogin.insertHoraEntrada(
            controllerLogin.professionalsQR, controllerLogin.branchIdLoggedIn);
        if (controllerLogin.usserMssQr == 1) {
          if (resultH == 1) //td inserto correctamente la entrada
          {
            //mandar mensaje que td esta bien
            mensjeOk();
            await initializeService();
            await clientCont.notification_tail_colation(
                controllerLogin.branchIdLoggedIn,
                controllerLogin.professionalsQR,
                'Coordinador');
            clientCont.setLoading(false);
            shopCont.setLoading(false);
          } else {
            //hubo problema al registrar la entrada
            mensjeError();
            controllerLogin.inputError();
          }
        } else if (controllerLogin.usserMssQr == 0) {
          mensjeNot(); //no coincide el Qr
        }
        Get.offAllNamed('/HomeCordinador');
      } else {
        Get.snackbar(
          '',
          'Problemas de conexión al leer el código Qr, vuelva a intentarlo',
          colorText: const Color.fromARGB(255, 43, 44, 49),
          titleText: const Text('Error'),
          duration: const Duration(seconds: 4),
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: const Color(0xFF4470F3),
          progressIndicatorValueColor:
              const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 11, 3)),
          overlayBlur: 3,
        );
        Get.offAllNamed('/LoginFormPage');
      }
    });
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
