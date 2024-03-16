// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
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

  bool maintainClockStatus = false;
  UserRepository usuarioLg = UserRepository();
  //*************************/
  String nameUserLoggedIn = '';
  String userLoggedIn = '';
  String tokenUserLoggedIn = '';
  int idUserLoggedIn = -2023991991;
  String emailUserLoggedIn = '';
  String chargeUserLoggedIn = '';
  String imageUrlLoggedIn = '';
  int? idProfessionalLoggedIn;
  int? branchIdLoggedIn;
  int branchTecnicLoggedIn = 0;
  int? usserPermissionQr;
  //*************************/
  bool isLoading = true;
  String pagina = 'nothing';
  bool obscureText = true;
  String qrRead = '';
  bool incorrectFields = false;
  String greeting = 'Buenos días ';

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

  Future<void> loadingValue(bool value) async {
    isLoading = value;
    update();
  }

  void getGreeting() {
    // Obtener la hora actual
    /* DateTime now = DateTime.now();

    // Obtener la hora del día
    int hour = now.hour;

    // Determinar el saludo según la hora

    if (hour < 12) {
      greeting = 'Buenos días ';
    } else if (hour < 18) {
      greeting = 'Buenas tardes ';
    } else {
      greeting = 'Buenas noches ';
    }*/
    greeting = 'Hola ';
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

  Future<void> qrReading(String? qr) async {
    //todo falta poner un cargando
    print('entre aqui a el controlador de lectura del QR${qr.toString()}');
    Map<String, dynamic> jsonMap = json.decode(qr.toString());
    print('......................Objeto JSON: $jsonMap');
    String userName = jsonMap['userName'];
    String email = jsonMap['email'];
    String hora = jsonMap['hora'];
    int id = jsonMap['id'];
    int branch_id = jsonMap['branch_id'];
    //
    //
    //
    print(userName);
    print(email);
    print(hora);
    print(id);
    print(branch_id);

    bool resp = //(int idBranch, int professionalId)
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
    }
  }

  Future<bool> saveDataQr(int idBranch, int professionalId) async {
    bool resultList = await usuarioLg.generateQr(idBranch, professionalId);
    return resultList;
  }

  Future<void> loginGetIn(String u, String p) async {
    final ClientsScheduledController clientsScheduledController =
        Get.find<ClientsScheduledController>();
    String email = u.toString(), pass = p.toString();
    incorrectFields = false;
    try {
      Map<String, dynamic>? result; //INICIALIZANDO A NULL
      result = await usuarioLg.getUserLoggedIn(email, pass);

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
        print('branchIdLoggedIn***************************: $branchIdLoggedIn');
        print('TOKEN***************************: $tokenUserLoggedIn');
        print('ID-Profess***************************: $idProfessionalLoggedIn');

        if (tokenUserLoggedIn != '' &&
            nameUserLoggedIn != '' &&
            emailUserLoggedIn != '') {
          //Define el tipo de saludo
          getGreeting();

          if (chargeUserLoggedIn == "Barbero") {
            //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
            print('estoy aqui al cargar datos del controlador de client');
            clientsScheduledController.setCloseIesperado(true);
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
          await clearSessionData();
          Get.offAllNamed('/LoginFormPage');
        } else {
          print('NO CERRO SECION');
        }
      } else
        print('ERROR: -----> Revisar que el token esta llegando aqui vacio');
    } catch (e) {
      print('Erroor:$e');
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
