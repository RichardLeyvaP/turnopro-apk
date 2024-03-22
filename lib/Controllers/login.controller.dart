// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/env.dart';
import 'package:turnopro_apk/get_connect/repository/user.repository.dart';

class LoginController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
    androidInfo();
  }

  bool codigoQrvalid = false;
  bool setIsLoading = false;

  void setIsLoadingFor(value) {
    setIsLoading = value;
    update();
  }

  int segundoPlano = 1; //es que regreso..esta bien
  void getSegundoPlano(int value) {
    //si segundo plano es true es que regreso del segundo plano
    segundoPlano = value;
    print('llegando del segundo plano segundoPlano:$segundoPlano');

    update();
  }

  bool maintainClockStatus = false;
  UserRepository usuarioLg = UserRepository();
  //*************************/
  String uss = '';
  String pass = '';
  //
  String nameUserLoggedIn = '';
  String userLoggedIn = '';
  String tokenUserLoggedIn = '';
  int idUserLoggedIn = -2023991991;
  String emailUserLoggedIn = '';
  String chargeUserLoggedIn = '';
  String imageUrlLoggedIn = '';
  int? idProfessionalLoggedIn;
  int? branchIdLoggedIn;
  int? branchNameLoggedIn;
  int branchTecnicLoggedIn = 0;
  int? usserPermissionQr;
  //*************************/
  bool isLoading = true;
  String pagina = 'nothing';
  bool obscureText = true;
  String qrRead = '';
  bool incorrectFields = false;
  String greeting = 'Buenos días ';
  bool isLoggingIn = false;

  //******************* */
  //propiedades de telefone
  double? androidInfoDisplay;
  double? androidInfoWidth;
  double? androidInfoHeight;
  int? androidInfoVersion;

  void setMaintainClockStatus() {
    maintainClockStatus = true;
    update();
  }

  void setIsLoggingIn(bool value) {
    isLoggingIn = value;
    update();
  }

  void setCodigoQrValid(value) {
    usserPermissionQr = value;
    update();
  }

  bool codigoQrValid() {
    if (usserPermissionQr == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loadingValue(bool value) async {
    isLoading = value;
    update();
  }

  void getGreeting() {
    greeting = 'Hola ';
    update();
  }

  bool ejecutadoEvent = false;
  void ejecutado_(value) {
    ejecutadoEvent = value;
    update();
  }

  androidInfo() async {
    // Obtener información sobre el dispositivo
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    print("Android SDK Version222: ${androidInfo.version.release}");
    print(
        "Android SDK androidInfo.displayMetrics.sizeInches: ${androidInfo.displayMetrics.sizeInches}");
    androidInfoDisplay = androidInfo.displayMetrics.sizeInches;
    androidInfoVersion = int.parse(androidInfo.version.release);
    // getScreenResolution();
    update();
  }

  void getScreenResolution(BuildContext context) {
    final ClientsScheduledController clientContro =
        Get.find<ClientsScheduledController>();
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;

    //Aqui obtengo el ancho y alto de los telefonos
    //dependiendo de este tamaño doy tamaño a los card y demas componentes
    androidInfoWidth = screenSize.width;
    androidInfoHeight = screenSize.height;

    //**********AJUSTAR TAMÑO DE LOS RELOJES********** */
    double valueClock = clientContro.calcularH(androidInfoHeight!);
    //clientContro.setValueClockDinamic(valueClock);

    print('Ancho de pantalla: ${screenSize.width}');
    print('Alto de pantalla: ${screenSize.height}');
  }

  String userNameQR = '';
  String emailQR = '';
  String horaQR = '';
  int idQR = -99;
  int branchIdQR = -99;
  int professionalsQR = -99;
  int workplaceidQR = -99;
  List<int> placesQR = [];

  Future<bool> qrReading(String? qr) async {
    //todo falta poner un cargando
    print(
        'esto es lo que entre aqui a el controlador de lectura del QR${qr.toString()}');
    Map<String, dynamic> jsonMap = json.decode(qr.toString());
    print('esto es lo que ......................Objeto JSON: $jsonMap');

    userNameQR = jsonMap['userName'];
    print('esto es lo que-1');
    emailQR = jsonMap['email'];
    print('esto es lo que-2');
    horaQR = jsonMap['hora'];
    print('esto es lo que-3');
    print('esto es lo que-jsonMap[id]-${jsonMap['id']}');
    idQR = jsonMap['id'];
    print('esto es lo que-4');
    branchIdQR = jsonMap['branch_id'];
    print('esto es lo que-5');
    professionalsQR = int.parse(jsonMap['professional_id']);
    print('esto es lo que-6');
    workplaceidQR = int.parse(jsonMap['workplace_id']);
    print('esto es lo que-7');
    List<dynamic> listaDynamic = jsonMap['places'];
    placesQR = listaDynamic.map((elemento) => int.parse(elemento)).toList();
    print('esto es lo que-8');

    //
    //

    //

    if (branchIdQR == branchIdLoggedIn && idQR == idUserLoggedIn) {
      usserPermissionQr = 1; //SE CREO CORRECTAMENTE EL QR
      update();
      // Get.snackbar(
      //   '',
      //   'Hola, $userName puede prestar servicios,hora de entrada: $hora',
      //   colorText: const Color.fromARGB(255, 43, 44, 49),
      //   titleText: const Text('Mensaje'),
      //   duration: const Duration(seconds: 3),
      //   showProgressIndicator: true,
      //   progressIndicatorBackgroundColor:
      //       const Color.fromARGB(255, 81, 93, 117),
      //   progressIndicatorValueColor:
      //       const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 130, 84)),
      //   overlayBlur: 3,
      // );
      // await Future.delayed(Duration(
      //     seconds:
      //         3)); //aqui espero 3 segundos que se visualize el mensaje del snabar y luego redirecciono al home
      //  Get.offAllNamed('/Professional');
      return true;
    } else {
      /* Get.snackbar(
        'Error',
        '$userName la sucursal no coincide con la de la aplicación.',
        colorText: const Color.fromARGB(255, 43, 44, 49),
        titleText: const Text('Error'),
        duration: const Duration(seconds: 3),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor:
            const Color.fromARGB(255, 81, 93, 117),
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 130, 84)),
        overlayBlur: 3,
      );*/
      usserPermissionQr = null; //SE CREO CORRECTAMENTE EL QR
      update();
      // await Future.delayed(Duration(
      //     seconds:
      //         3)); //aqui espero 3 segundos que se visualize el mensaje del snabar y luego redirecciono al home
      // Get.offAllNamed('/Professional');
      return false;
    }

    /*  bool resp = //(int idBranch, int professionalId)
        await saveDataQr(branchIdLoggedIn!, id);
    if (resp == true) {
      usserPermissionQr = 1; //SE CREO CORRECTAMENTE EL QR
      update();
      //muestro mensaje que ya puede brindar servicios
      //todo falta mandar mensaje
      //mando notificacion a Cordinador, Responsable de que el profesional "Nombre" está en el salón
      Get.snackbar(
        '',
        'Hola, $userName puede prestar servicios,hora de entrada: $hora',
        colorText: const Color.fromARGB(255, 43, 44, 49),
        titleText: const Text('Mensaje'),
        duration: const Duration(seconds: 3),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor:
            const Color.fromARGB(255, 81, 93, 117),
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation(Color.fromARGB(255, 241, 130, 84)),
        overlayBlur: 3,
      );
      await Future.delayed(Duration(
          seconds:
              3)); //aqui espero 3 segundos que se visualize el mensaje del snabar y luego redirecciono al home
      Get.offAllNamed('/Professional');
    }*/
    //AQUI AUTORIZAR PRESTAR SERVICIOS
  }

  Future<bool> saveDataQr(int idBranch, int professionalId) async {
    bool resultList = await usuarioLg.generateQr(idBranch, professionalId);
    return resultList;
  }

  Future<void> getUserLoggedBranch(String u, String p) async {
    String email = u.toString(), pass = p.toString();
    incorrectFields = false;
    try {
      print('aqui estoy dev branch u=$u --- p=$p');
      Map<String, dynamic>? result; //INICIALIZANDO A NULL
      result = await usuarioLg.getUserLoggedBranch(email, pass);

      if (result != null) {
        //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
        print('aqui estoy dev branch sii');

        update();
        Get.offAllNamed('/LoginFormPage2');
      } //cierre if (result != null) {
      else {
        print('aqui estoy dev branch nooo');
      }
    } catch (e) {
      print('aqui estoy dev branch nooo eroor :$e');
    }
  }

//
//
//
//
//
  Future<void> loginGetIn(String u, String p, int idBranch) async {
    final ClientsScheduledController clientsScheduledController =
        Get.find<ClientsScheduledController>();
    String email = u.toString(), pass = p.toString();
    incorrectFields = false;
    try {
      Map<String, dynamic>? result; //INICIALIZANDO A NULL
      result = await usuarioLg.getUserLoggedIn(email, pass, idBranch);

      if (result != null) {
        //*******Asignando Valores*****/
        nameUserLoggedIn = result['name'];
        userLoggedIn = result['userName'];
        tokenUserLoggedIn = result['token'];
        idUserLoggedIn = result['id'];
        emailUserLoggedIn = result['email'];
        chargeUserLoggedIn = result['charge'];
        idProfessionalLoggedIn = result['professional_id'];
        branchIdLoggedIn = result['branch_id'];
        imageUrlLoggedIn = result['image'];
        branchTecnicLoggedIn = result['useTechnical'];
        print('ssssssssssss ${result['useTechnical'].runtimeType}');
        print('ssssssssssss ${result['useTechnical']}');
        print('ssssssssssss branchIdLoggedIn${result['branchIdLoggedIn']}');
        //*******Asignando Valores*****/
        print(
            'a.......... branchIdLoggedIn***************************: $branchIdLoggedIn');
        print('TOKEN***************************: $tokenUserLoggedIn');
        print('ID-Profess***************************: $idProfessionalLoggedIn');

        if (tokenUserLoggedIn != '' &&
            nameUserLoggedIn != '' &&
            emailUserLoggedIn != '') {
          //Define el tipo de saludo
          getGreeting();

          int idPuesto = await getIdPuesto(idProfessionalLoggedIn!);
          if (idPuesto != -99 && idPuesto != -999) {
            print('id de mi puesto de trabajo = $idPuesto');
            setCodigoQrValid(1);
          } else {
            print('id de mi puesto de trabajo = $idPuesto');
            setCodigoQrValid(null);
          }

          if (chargeUserLoggedIn == "Barbero") {
            //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
            print('estoy aqui al cargar datos del controlador de client');
            setIsLoggingIn(true);
            clientsScheduledController.setCloseIesperado(true);
            clientsScheduledController.setCloseIesperadoLogin(true);
            await clientsScheduledController.fetchClientsScheduled(
                idProfessionalLoggedIn, branchIdLoggedIn);

            print(' ya no llegue aqui voy a cargar la pagina del profesional');

            print('***************SOY BARBERO*************');
            pagina = '/Professional';
            loadingValue(false);
            update();
            Get.offAllNamed('/Professional');
          } else if (chargeUserLoggedIn == "Encargado") {
            print('***************SOY ENCARGADO*************');
            pagina = '/HomeResponsible';
            loadingValue(false);
            update();
            Get.offAllNamed('/HomeResponsible');
          } else if (chargeUserLoggedIn == "Tecnico") {
            print('***************SOY TECNICO CAPILAR*************');
            pagina = '/HomeTecnico';
            loadingValue(false);
            update();
            Get.offAllNamed('/HomeTecnico');
          } else if (chargeUserLoggedIn == "Cordinador") {
            print('***************SOY Cordinador del local*************');
            pagina = '/HomeCordinador';
            loadingValue(false);
            update();
            Get.offAllNamed('/HomeCordinador');
          } else {
            incorrectFields = true;
            await loadingValue(false);
            update();
            print(
                ' NO ENTRO PORQUE NO TIENE UN ROL PARA LA APP, COINCIDE QUE ES TRABAJADOR PERO NO DEL APK');
          }
        }

        update();
      } //cierre if (result != null) {
      else {
        incorrectFields = true;
        await loadingValue(false);
        update();
        print(' result == null por eso no entro');
      }
    } catch (e) {
      print('errorrrrrr:$e');
    }
  }

  Future<void> exit(String token) async {
    try {
      if (token != '') {
        Map<String, dynamic>? result; //INICIALIZANDO A NULL
        result = await usuarioLg.userLogout(token);
        if (result != null) {
          print(
              'SI CERRO SECION CORRECTAMENTE ELIMINANDO LOS DATOS DE SECCION');
          await clearSessionData();
          print('reiniciar app mandando');
          Get.offAllNamed('/LoginFormPage');
        } else {
          print('reiniciar app:$result');
          print(
              'NO CERRO SECION CORRECTAMENTE ELIMINANDO LOS DATOS DE SECCION');
          Get.offAllNamed('/LoginFormPage');
        }
      } else
        print('ERROR: -----> Revisar que el token esta llegando aqui vacio');
    } catch (e) {
      print('Erroor:$e');
    }
  }

  Future<void> insertPuesto(professional_id, workplace_id, places) async {
    try {
      var result =
          await usuarioLg.insertPuesto(professional_id, workplace_id, places);
      if (result == 1) {
        print('esto es lo que INSERTO EN EL PUESTO DE TRABAJO');
      } else {
        print('esto es lo que NOO INSERTO EN EL PUESTO DE TRABAJO');
      }
    } catch (e) {
      print('esto es lo que Erroor:$e');
    }
  }

  Future<void> exitPostworking(String type) async {
    try {
      bool result; //INICIALIZANDO A NULL
      print('este es el id del puesto id que mando:$idProfessionalLoggedIn');
      int idPuesto = await getIdPuesto(idProfessionalLoggedIn!);
      print('este es el id del puesto :$idPuesto');

      if (idPuesto != -99 && idPuesto != -999) {
        result = await usuarioLg.exitPostworking(idPuesto, type);
        if (result == true) {
          print(
              'este es el id del puesto EL PROFESIONAL SALIO DEL PUESTO CORRECTAMENTE');
        } else {
          print('este es el id del puesto NO SALIO DEL PUESTO EL PROFESIONAL');
        }
      }
    } catch (e) {
      print('Erroor:$e');
    }
  }

  Future<int> getIdPuesto(int idProfes) async {
    try {
      //INICIALIZANDO A NULL
      int idPuesto = -99;
      print('este es el id del puesto idProfes:$idProfes');
      idPuesto = await usuarioLg.getIdPuesto(idProfes);
      print(
          'este es el id del puesto idProfes despue sde llamar al puesto:$idPuesto');

      if (idPuesto != -99) {
        print('EL PROFESIONAL SALIO DEL PUESTO CORRECTAMENTE');
        return idPuesto;
      } else {
        print('NO ESTA EN NINGUN PUESTO EL PROFESIONAL');
        return idPuesto;
      }
    } catch (e) {
      print('Erroor:$e');
      return -999;
    }
  }

  Future<void> clearSessionData() async {
    nameUserLoggedIn = '';
    userLoggedIn = '';
    tokenUserLoggedIn = '';
    idUserLoggedIn = -2023991991;
    chargeUserLoggedIn = '';
    emailUserLoggedIn = '';
    idProfessionalLoggedIn = null;
    branchIdLoggedIn = null;
    pagina = 'nothing';
    incorrectFields = false;
    update();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    update();
  }
}
