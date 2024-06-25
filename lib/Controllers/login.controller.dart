// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
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

  String pagePosition = '';
  bool codigoQrvalid = false;
  bool setIsLoading = false;
  bool setIsLoading2 = false;

  bool switchValue = false; //false es barbero y true Encargado

  //optener la hora actual
  String getCurrentTime() {
    // Obtener la hora actual
    DateTime now = DateTime.now();

    // Formatear la hora
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return formattedTime;
  }

  void showConnectionError() {
    showSimpleNotification(
      Text(
        'Problemas de conexión',
        style: TextStyle(color: Colors.white),
      ),
      background: Colors.red,
      // position: NotificationPosition.top,
      position: NotificationPosition.bottom,
      slideDismiss: true, // para que se pueda deslizar para cerrar
    );
  }

  //optener la hora actual
  String getDateString(DateTime hr) {
    // Formatear la hora
    String formattedTime = DateFormat('HH:mm:ss').format(hr);
    return formattedTime;
  }

  //convierte una hora pasada en string en un formato de hora DateTime
  DateTime parseTime(String time) {
    DateFormat format = DateFormat('HH:mm:ss');
    return format.parse(time);
  }

//restar duracion a una hora dada
  DateTime subtractTime(String time, Duration duration) {
    DateTime dateTime = parseTime(time);
    return dateTime.subtract(duration);
  }

  Duration getDurationTime(int min) {
    return Duration(minutes: min);
  }

//sumar una duracion dada a una hora
  DateTime addTime(String time, Duration duration) {
    DateTime dateTime = parseTime(time);
    return dateTime.add(duration);
  }

  //comparar 2 horas si h1>h2 devuelve true
  bool isTime1GreaterThanTime2(String h1, String h2) {
    DateFormat format = DateFormat('HH:mm:ss');

    // Convertir las cadenas a objetos DateTime
    DateTime time1 = format.parse(h1);
    DateTime time2 = format.parse(h2);

    // Comparar los tiempos
    return time1.isAfter(time2);
  }

  int secondsToMinutes(int seconds) {
    int minutes = seconds ~/ 60; // División entera
    // int remainingSeconds = seconds % 60; // Resto de la división

    return minutes;
  }

  DateTime h3min = DateTime.now();

  void getUpdateTime(int tiempo, int clock, String place) {
    print('entrando en getUpdateTime-> $place');
    int timeAlert = 0;
    int alert =
        0; //0 es que acabo el tiempo, 1 es que aun no llega los 3 minutos, y 2 es que ya le qeuda menos de 3 min
    String hActual = getCurrentTime();
    if (tiempo > 0 && tiempo < 3) {
      timeAlert = tiempo;
    } else if (tiempo > 3) {
      timeAlert = tiempo - 3; //3 significa que son 3 minutos
    }
    if (timeAlert > 3) //hay tiempo para sumarle a la hora actual
    {
      //aqui ya tengo la hora en que faltarian 3 minutos para terminar
      h3min = addTime(hActual, getDurationTime(timeAlert));
      alert = 1;
    } else if (timeAlert > 0) {
      alert = 2;
    }
    //aqui ya verifico los estados y ghuardo resultado
    if (clock == 1) //si fuera reloj 1
    {
      print(
          'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera 1-:${getDateString(h3min)}');
      if (alert == 0) {
        //aqui retorna un String 'FIN'
        LocalStorage.prefs.setString('varSistemHr3min1', 'FIN');
        //quiere decir que acabo el tiempo
      } else if (alert == 2) {
        LocalStorage.prefs.setString('varSistemHr3min1', 'MENOR');
        //quiere decir que ya e smenor que 3 min
      } else {
        //asignar aqui a la variable en memoria del telefono esa hora
        LocalStorage.prefs.setString('varSistemHr3min1', getDateString(h3min));
        //aqui retorna la hora enq ue hay qeu mandar la notificacion
      }
    } else if (clock == 2) //si fuera reloj 2
    {
      print(
          'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera 2-:${getDateString(h3min)}');
      if (alert == 0) {
        //aqui retorna un String 'FIN'
        LocalStorage.prefs.setString('varSistemHr3min2', 'FIN');
        //quiere decir que acabo el tiempo
      } else if (alert == 2) {
        LocalStorage.prefs.setString('varSistemHr3min2', 'MENOR');
        //quiere decir que ya e smenor que 3 min
      } else {
        //asignar aqui a la variable en memoria del telefono esa hora
        LocalStorage.prefs.setString('varSistemHr3min2', getDateString(h3min));
        //aqui retorna la hora enq ue hay qeu mandar la notificacion
      }
    } else if (clock == 3) //si fuera reloj 1
    {
      print(
          'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera 3-:${getDateString(h3min)}');
      if (alert == 0) {
        //aqui retorna un String 'FIN'
        LocalStorage.prefs.setString('varSistemHr3min3', 'FIN');
        //quiere decir que acabo el tiempo
      } else if (alert == 2) {
        LocalStorage.prefs.setString('varSistemHr3min3', 'MENOR');
        //quiere decir que ya e smenor que 3 min
      } else {
        //asignar aqui a la variable en memoria del telefono esa hora
        LocalStorage.prefs.setString('varSistemHr3min3', getDateString(h3min));
        //aqui retorna la hora enq ue hay qeu mandar la notificacion
      }
    } else if (clock == 4) //si fuera reloj 1
    {
      print(
          'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera 4-:${getDateString(h3min)}');
      if (alert == 0) {
        //aqui retorna un String 'FIN'
        LocalStorage.prefs.setString('varSistemHr3min4', 'FIN');
        //quiere decir que acabo el tiempo
      } else if (alert == 2) {
        LocalStorage.prefs.setString('varSistemHr3min4', 'MENOR');
        //quiere decir que ya e smenor que 3 min
      } else {
        //asignar aqui a la variable en memoria del telefono esa hora
        LocalStorage.prefs.setString('varSistemHr3min4', getDateString(h3min));
        //aqui retorna la hora enq ue hay qeu mandar la notificacion
      }
    }
  }

  Future<void> setswitchValue() async {
    final ClientsScheduledController clientsScheduledController =
        Get.find<ClientsScheduledController>();

    if (switchValue == false) {
      switchValue = true;
      print('soy un switchValue:true');
      Get.offAllNamed('/HomeResponsible');
    } else {
      clockInitialTimeB(clientsScheduledController, 'Barbero');
      setLoggingInCharge(true, 'setswitchValue-194');
      switchValue = false;
      setIsLoggingIn(true);
      clientsScheduledController.setCloseIesperado(true);
      clientsScheduledController.setCloseIesperadoLogin(true);

      await clientsScheduledController.fetchClientsScheduled(
          idProfessionalLoggedIn, branchIdLoggedIn, 'setswitchValue');
      print('soy un switchValue:false');
      Get.offAllNamed('/Professional');
    }
    update();
  }

  void setIsLoadingFor(value) {
    setIsLoading = value;
    update();
  }

  void setPagePosition(value) {
    print(
        'llamada timer en 10 segundos llamadasTimer1()-setPagePosition(value):$value');
    pagePosition = value;
    update();
  }

  void setIsLoadingFor2(value) {
    setIsLoading2 = value;
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
  bool varInTheClock = false;
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
  int usserPermissionQrAntes = 1;
  int usserMssQr = -99;
  int contLlamClient = 0;
  bool makeCall = true;
  bool makeCallT = true;

  setMakeCall(value) {
    makeCall = value;
  }

  setMakeCallT(value) {
    makeCallT = value;
  }

  void setContLlamClient(int value) {
    if (value == 1) {
      contLlamClient++;
    } else {
      contLlamClient = value;
    }
  }

  //variables para el encargado

  String tokenUserLoggedIn2 = '';
  int? usserPermissionQr2;
  int usserMssQr2 = -99;

  //*************************/
  bool isLoading = true;
  String pagina = 'nothing';
  bool obscureText = true;
  String qrRead = '';
  bool incorrectFields = false;
  String greeting = 'Buenos días ';
  bool isLoggingIn = false;
  bool isLoggingInCharge = false;

  //******************* */
  //propiedades de telefone
  double? androidInfoDisplay;
  double? androidInfoWidth;
  double? androidInfoHeight;
  int? androidInfoVersion;
  List<int> pressedButtonIds = [];
  List<int> pressedButtonServ = [];

  int serviceTime = 0;
  setServiceTime(value) {
    serviceTime = value;
    update();
  }

  int handleButtonClick(int buttonId) {
    // Verificar si el ID del botón ya ha sido presionado
    if (pressedButtonIds.contains(buttonId)) {
      print('Botón $buttonId presionado return 0');
      // Si el ID ya ha sido presionado, no hacer nada
      return 0;
    } else {
      // Agregar el ID del botón a la lista de IDs presionados
      pressedButtonIds.add(buttonId);
      // Aquí puedes poner el código que deseas ejecutar solo una vez
      print('Botón $buttonId presionado return 1');
      return 1;
    }
  }

  int handleButtonClickService(int buttonId) {
    // Verificar si el ID del botón ya ha sido presionado
    if (pressedButtonServ.contains(buttonId)) {
      print('Botón $buttonId presionado return 0');
      // Si el ID ya ha sido presionado, no hacer nada
      return 0;
    } else {
      // Agregar el ID del botón a la lista de IDs presionados
      pressedButtonServ.add(buttonId);
      update();
      // Aquí puedes poner el código que deseas ejecutar solo una vez
      print('Botón $buttonId presionado return 1');
      return 1;
    }
  }

  //esta la llamo en el modal para limpiar nuevamente la variable
  void handleButtonClickServiceClear() {
    pressedButtonServ.clear();
    update();
  }

  List<int> pressedButtonIdsTec = [];
  int handleButtonClickTec(int buttonId) {
    // Verificar si el ID del botón ya ha sido presionado
    if (pressedButtonIdsTec.contains(buttonId)) {
      print('Botón $buttonId presionado return 0');
      // Si el ID ya ha sido presionado, no hacer nada
      return 0;
    } else {
      // Agregar el ID del botón a la lista de IDs presionados
      pressedButtonIdsTec.add(buttonId);
      update();
      // Aquí puedes poner el código que deseas ejecutar solo una vez
      print('Botón $buttonId presionado return 1');
      return 1;
    }
  }

  void removeButtonIdTec(int buttonId) {
    // Verificar si el ID del botón ya ha sido presionado
    if (pressedButtonIdsTec.contains(buttonId)) {
      // Si el ID ya ha sido presionado, eliminarlo de la lista
      pressedButtonIdsTec.remove(buttonId);
      update(); // Llamar a update() para reflejar el cambio en la interfaz de usuario si es necesario
      print('Botón $buttonId eliminado de la lista');
    } else {
      print('Botón $buttonId no está en la lista');
    }
  }

  List<int> pressedButtonModal = [];
  int handleButtonClickModal(int buttonId) {
    // Verificar si el ID del botón ya ha sido presionado
    if (pressedButtonModal.contains(buttonId)) {
      print('Botón $buttonId presionado return 0');
      // Si el ID ya ha sido presionado, no hacer nada
      return 0;
    } else {
      // Agregar el ID del botón a la lista de IDs presionados
      pressedButtonModal.add(buttonId);
      update();
      // Aquí puedes poner el código que deseas ejecutar solo una vez
      print('Botón $buttonId presionado return 1');
      return 1;
    }
  }

  //esta la llamo en el modal para limpiar nuevamente la variable
  void setHandleButtonClickModal() {
    pressedButtonModal.clear();
    update();
  }

  //esta la llamo en el modal para limpiar nuevamente la variable
  void inTheClock(bool value) {
    varInTheClock = value;
    update();
  }

  void setMaintainClockStatus() {
    maintainClockStatus = true;
    update();
  }

  void setIsLoggingIn(bool value) {
    isLoggingIn = value;
    update();
  }

  Future<void> setLoggingInCharge(bool value, String place) async {
    print('setLoggingInCharge de :$place');
    isLoggingInCharge = value;

    update();
  }

  void setCodigoQrValidAnt(value) {
    usserPermissionQrAntes = value;
    update();
  }

  void setCodigoQrValid(value) {
    usserPermissionQr = value;
    update();
  }

  int getCodigoQrValid() {
    return usserPermissionQr ?? 0;
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

  setUsserMssQr(value) {
    usserMssQr = value;
    update();
  }

  inputError() {
    usserMssQr = -99;
    usserPermissionQr = null;
    update();
  }

  int parseWorkplaceId(dynamic value) {
    if (value is String) {
      return int.parse(value);
    } else if (value is int) {
      return value;
    } else {
      return -99;
    }
  }

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
    idQR = parseWorkplaceId(jsonMap['id']);
    print('esto es lo que-4');
    branchIdQR = parseWorkplaceId(jsonMap['branch_id']);
    ;
    print('esto es lo que-5');
    professionalsQR = parseWorkplaceId(jsonMap['professional_id']);
    print('esto es lo que-6');
    workplaceidQR = parseWorkplaceId(jsonMap['workplace_id']);
    print('esto es lo que-7');
    print('esto es lo : ${jsonMap['places']}');
    print('esto es lo que-777');
    List<dynamic> listaDynamic = jsonMap['places'];
    placesQR = listaDynamic.map((elemento) => int.parse(elemento)).toList();
    print('esto es lo que-8');

    //
    //

    //

    if (branchIdQR == branchIdLoggedIn && idQR == idUserLoggedIn) {
      usserPermissionQr = 1; //SE CREO CORRECTAMENTE EL QR
      usserMssQr = 1; //SE CREO CORRECTAMENTE EL QR
      update();
      //  Get.offAllNamed('/Professional');
      return true;
    } else {
      usserPermissionQr = null; //NO SE CREO CORRECTAMENTE EL QR
      usserMssQr = 0; //NO SE CREO CORRECTAMENTE EL QR
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
            const Color(0xFF4470F3),
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
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
    bool resultList =
        await usuarioLg.generateQr(idBranch, professionalId, tokenUserLoggedIn);
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
  Future<void> loginGetInEncargadoBarbero(
      String u, String p, int idBranch) async {
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
        print('ssssssssssss branchIdLoggedIn:$branchIdLoggedIn');
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
            int state = await getStateProfessionall(idProfessionalLoggedIn!);

            //preguntar por el state
            if (state == 2) //si esta en colación 2 Qr = null
            {
              print('estoy si aqui 1');
              setCodigoQrValid(null);
            } else if (state == 1) //si esta 1 Qr = 1
            {
              print('estoy si aqui 2');
              setCodigoQrValid(1);
            } else if (state == 3) // si esta en 3 Qr = 2
            {
              print('estoy si aqui 3');
              setCodigoQrValid(2);
            }
          } else {
            print('estoy si aqui 4');
            print('id de mi puesto de trabajo = $idPuesto');
            setCodigoQrValid(null);
            print(
                'id de mi puesto de trabajo estoy entrando a poner el codigo1 en :null');
          }

          if (chargeUserLoggedIn == "Barbero") {
            //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
            print('estoy aqui al cargar datos del controlador de client');
            setIsLoggingIn(true);
            setLoggingInCharge(true, 'loginGetInEncargadoBarbero-659');
            clientsScheduledController.setCloseIesperado(true);
            clientsScheduledController.setCloseIesperadoLogin(true);
            await clientsScheduledController.fetchClientsScheduled(
                idProfessionalLoggedIn, branchIdLoggedIn, 'Barbero');

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

//
//
//
  int obtenerHoraActualEnSegundos() {
    DateTime ahora = DateTime.now();
    int segundos = ahora.hour * 3600 + ahora.minute * 60 + ahora.second;
    return segundos;
  }

  clockInitialTimeB(
      ClientsScheduledController clientsScheduledController, String tyype) {
    //aqui obtengo la hora actual para comparar con la anterior si es posible
    int hAs = obtenerHoraActualEnSegundos();
    print('verificando si esta activo:');
    LocalStorage.prefs.setInt('valueHoraAct', hAs);
    print('--este es el value del clok-valueHoraAct-LOGIN:$hAs');
    if (LocalStorage.prefs.getBool('valueClockActiv') != null &&
        LocalStorage.prefs.getBool('valueClockActiv') == true) {
      print('verificando si esta activo:Si entre al if-1');
      if (LocalStorage.prefs.getInt('valueHoraAnt') != null &&
          LocalStorage.prefs.getInt('valueHoraAct') != null) {
        print('verificando si esta activo:Si entre al if-2');
        int timeAsig = 180;
        //obtengo la hora anterior y actual en segundos
        int hourAnt = LocalStorage.prefs.getInt('valueHoraAnt')!;
        int hourAct = LocalStorage.prefs.getInt('valueHoraAct')!;
        int segundExit = hourAct - hourAnt;
        //resto los segundos que estuvo fuera
        int valueAntClock = LocalStorage.prefs.getInt('valueClockIni')!;
        int diferSeg = valueAntClock - segundExit;
        if (diferSeg > 0) {
          //aun no s eacabaron los 3 minutos
          // asigno el tiempo
          if (diferSeg > 180) {
            timeAsig = 180;
          } else {
            timeAsig = diferSeg;
          }
        } else //es que se acaboron los 3 min
        {
          // ya una vez en el dia esto cumplido ya no importa el reloj de espera
          //al salir del sistema esta variable debe tomar false
          timeAsig = 0;
        }
        LocalStorage.prefs.setInt('valueClockIni', timeAsig);

        print('--este es el value del clok-hourAnt:$hourAnt');
        print('--este es el value del clok-hourAct:$hourAct');
        print('--este es el value del clok-segundExit:$segundExit');
        print('--este es el value del clok-valueAntClock:$valueAntClock');
        print('--este es el value del clok-diferSeg:$diferSeg');

        clientsScheduledController.setTotalTimeInitial(timeAsig);
      } else {
        print('verificando si esta activo:NO entre al if-de adentro');
      }
    } else {
      print('verificando si esta activo:NO entre al if-de afuera');
    }
  }

  clockInitialTimeT(
      ClientsTechnicalController clientsScheduledController, String tyype) {
    //aqui obtengo la hora actual para comparar con la anterior si es posible

    if (LocalStorage.prefs.getBool('valueClockActivT') != null &&
        LocalStorage.prefs.getBool('valueClockActivT') == true) {
      int timeAsig = 180;
      if (LocalStorage.prefs.getInt('valueHoraAnt') != null &&
          LocalStorage.prefs.getInt('valueClockIni') != null) {
        //obtengo la hora anterior y actual en segundos
        int hourAnt = LocalStorage.prefs.getInt('valueHoraAnt')!;
        int hourAct = obtenerHoraActualEnSegundos();
        int segundExit = hourAct - hourAnt;
        //resto los segundos que estuvo fuera
        int valueAntClock = LocalStorage.prefs.getInt('valueClockIni')!;
        int diferSeg = valueAntClock - segundExit;
        if (diferSeg > 0) {
          //aun no s eacabaron los 3 minutos
          // asigno el tiempo
          timeAsig = diferSeg > 180 ? 180 : diferSeg;
        } else //es que se acaboron los 3 min
        {
          // ya una vez en el dia esto cumplido ya no importa el reloj de espera
          //al salir del sistema esta variable debe tomar false
          timeAsig = 180;
        }
        LocalStorage.prefs.setInt('valueClockIni', timeAsig);

        print('--este es el value del clok-hourAnt:$hourAnt');
        print('--este es el value del clok-hourAct:$hourAct');
        print('--este es el value del clok-segundExit:$segundExit');
        print('--este es el value del clok-valueAntClock:$valueAntClock');
        print('--este es el value del clok-diferSeg:$diferSeg');

        clientsScheduledController.setTotalTimeInitialTec(timeAsig);
      }
    }

    if (LocalStorage.prefs.getBool('valueClockTec1ActivT') != null) {
      bool activeClock = LocalStorage.prefs.getBool('valueClockTec1ActivT')!;
      print('entrando porque esta el atendiendo cliente:CONTROLADOR-INI');
      if (activeClock) {
        print(
            'entrando porque esta el atendiendo cliente:CONTROLADOR-activeClock:$activeClock');
        if (LocalStorage.prefs.getInt('valueHoraAnt') != null &&
            LocalStorage.prefs.getInt('valueClockTec1') != null) {
          print(
              'entrando porque esta el atendiendo cliente:CONTROLADOR-dentro del if:si');
          int timeAsig = 180;
          //obtengo la hora anterior y actual en segundos
          int hourAnt = LocalStorage.prefs.getInt('valueHoraAnt')!;
          int hourAct = obtenerHoraActualEnSegundos();
          int segundExit = hourAct - hourAnt;
          //resto los segundos que estuvo fuera
          int valueAntClock = LocalStorage.prefs.getInt('valueClockTec1')!;
          int diferSeg = valueAntClock - segundExit;
          if (diferSeg > 0) {
            //aun no s eacabaron los 3 minutos
            // asigno el tiempo
            timeAsig = diferSeg > 300 ? 300 : diferSeg;
          } else //es que se acaboron los 3 min
          {
            // ya una vez en el dia esto cumplido ya no importa el reloj de espera
            //al salir del sistema esta variable debe tomar false
            timeAsig = 1;
          }
          LocalStorage.prefs.setInt('valueClockTec1', timeAsig);

          print('--este es el value del clok-hourAnt-T:$hourAnt');
          print('--este es el value del clok-hourAct-T:$hourAct');
          print('--este es el value del clok-segundExit-T:$segundExit');
          print('--este es el value del clok-valueAntClock-T:$valueAntClock');
          print('--este es el value del clok-diferSeg-T:$diferSeg');

          clientsScheduledController.setTotalTimeClientec(timeAsig);
          print(
              'entrando porque esta el atendiendo cliente:CONTROLADOR-dentro del if-FINAL:timeAsig:$timeAsig');
        }
      }
    }
  }

//
  Future<void> loginGetIn(String u, String p, int idBranch) async {
    final ClientsScheduledController clientsScheduledController =
        Get.find<ClientsScheduledController>();
    final ClientsTechnicalController clientsScheduledControllerT =
        Get.find<ClientsTechnicalController>();
    final PagesConfigController pagesConfigCont =
        Get.find<PagesConfigController>();
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
        print('ssssssssssss branchIdLoggedIn:login:$branchIdLoggedIn');
        print('ssssssssssss chargeUserLoggedIn:login:$chargeUserLoggedIn');
        //*******Asignando Valores*****/
        print(
            'T123456789-a.......... branchIdLoggedIn***************************: $branchIdLoggedIn');
        print('T123456789-OKEN***************************: $tokenUserLoggedIn');
        print('ID-Profess***************************: $idProfessionalLoggedIn');

        if (tokenUserLoggedIn != '' &&
            nameUserLoggedIn != '' &&
            emailUserLoggedIn != '') {
          //Define el tipo de saludo
          getGreeting();

          int idPuesto = await getIdPuesto(idProfessionalLoggedIn!);
          if (idPuesto != -99 && idPuesto != -999) {
            print('id de mi puesto de trabajo = $idPuesto');
            int state = await getStateProfessionall(idProfessionalLoggedIn!);

            //preguntar por el state
            if (state == 1) //si esta 1 Qr = 1
            {
              print('estoy si aqui 2');
              setCodigoQrValid(1);
            } else if (state == 2) //si esta en colación 2 Qr = null
            {
              print('estoy si aqui 1');
              setCodigoQrValid(null);
            } else if (state == 3 || state == 4) // si esta en 3 Qr = 2
            {
              print('estoy si aqui 3');
              setCodigoQrValid(2);
            }
          } else {
            print('estoy si aqui 4');
            print('id de mi puesto de trabajo = $idPuesto');
            setCodigoQrValid(null);
            print(
                'id de mi puesto de trabajo estoy entrando a poner el codigo1 en :null');
          }

          if (chargeUserLoggedIn == 'Encargado' ||
              chargeUserLoggedIn == 'Coordinador') {
            int entrada = 0;
            entrada = await getEntradaPuesto(
                idProfessionalLoggedIn!, branchIdLoggedIn!);
            if (entrada == 1) {
              setCodigoQrValid(1);
            } else {
              setCodigoQrValid(null);
            }
          }

          if (chargeUserLoggedIn == "Barbero" ||
              chargeUserLoggedIn == "Barbero y Encargado") {
            //aqui es para saber solamnete el tiempo del reloj inicial de los 3min
            clockInitialTimeB(clientsScheduledController, 'Barbero');
            //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
            print('estoy aqui al cargar datos del controlador de client');
            setIsLoggingIn(true);
            setLoggingInCharge(true, 'loginGetIn-904');
            clientsScheduledController.setCloseIesperado(true);
            clientsScheduledController.setCloseIesperadoLogin(true);
            await clientsScheduledController.fetchClientsScheduled(
                idProfessionalLoggedIn,
                branchIdLoggedIn,
                'Barbero y Encargado');

            print(' ya no llegue aqui voy a cargar la pagina del profesional');

            print('***************SOY BARBERO*************');
            pagina = '/Professional';
            loadingValue(false);
            pagesConfigCont.selectedIndex = 0;
            update();
            Get.offAllNamed('/Professional');
          } else if (chargeUserLoggedIn == "Encargado") {
            print('***************SOY ENCARGADO*************');
            pagina = '/HomeResponsible';
            loadingValue(false);
            update();
            Get.offAllNamed('/HomeResponsible');
          } else if (chargeUserLoggedIn == "Tecnico") {
            //aqui es para saber solamnete el tiempo del reloj inicial de los 3min
            clockInitialTimeT(clientsScheduledControllerT, 'Tecnico');
            print('***************SOY TECNICO CAPILAR*************');
            pagina = '/HomeTecnico';
            loadingValue(false);
            update();
            Get.offAllNamed('/HomeTecnico');
          } else if (chargeUserLoggedIn == "Coordinador") {
            print('***************SOY Coordinador del local*************');
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
        Get.back();

        update();
      } //cierre if (result != null) {
      else if (result == null) {
        showConnectionError();
        Get.back();
      } else {
        incorrectFields = true;
        await loadingValue(false);
        update();
        print(' result == null por eso no entro');
        Get.back();
      }
    } catch (e) {
      showConnectionError();
      Get.back();
      print('errorrrrrreeeeeeeeeeeeeeeee:$e');
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
          LocalStorage.prefs.setBool('valueClockActiv', false);
          LocalStorage.prefs.setBool('valueClockActivT', false);
          LocalStorage.prefs.setBool('convivenciaIncumplida', false);
          LocalStorage.prefs.setBool('convivenciaIncumplidaT', false);
          Get.offAllNamed('/LoginFormPage');
        } else {
          await clearSessionData();
          LocalStorage.prefs.setBool('valueClockActiv', false);
          LocalStorage.prefs.setBool('valueClockActivT', false);
          LocalStorage.prefs.setBool('convivenciaIncumplida', false);
          LocalStorage.prefs.setBool('convivenciaIncumplidaT', false);
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

  Future<int> insertPuesto(professional_id, workplace_id, places) async {
    try {
      var result = await usuarioLg.insertPuesto(
          professional_id, workplace_id, places, tokenUserLoggedIn);
      if (result == 1) {
        print('esto es lo que INSERTO EN EL PUESTO DE TRABAJO');
      } else {
        print('esto es lo que NOO INSERTO EN EL PUESTO DE TRABAJO');
      }
      return result;
    } catch (e) {
      print('esto es lo que Erroor:$e');
      return 0;
    }
  }

  Future<int> insertHoraEntrada(professional_id, branch_id) async {
    try {
      var result = await usuarioLg.insertHoraEntrada(
          professional_id, branch_id, tokenUserLoggedIn);
      if (result == 1) {
        print('esto es lo que INSERTO LA HORA D EENTRADA');
      } else {
        print('esto es lo que NOO INSERTO LA HORA D EENTRADA');
      }
      return result;
    } catch (e) {
      print('esto es lo que Erroor:$e');
      return 0;
    }
  }

  Future<void> exitPostworking(String tipe) async {
    try {
      if (tipe == 'Barbero' || tipe == 'Tecnico') {
        bool result; //INICIALIZANDO A NULL
        print('este es el id del puesto id que mando:$idProfessionalLoggedIn');
        int idPuesto = await getIdPuesto(idProfessionalLoggedIn!);
        print('este es el id del puesto :$idPuesto');

        if (idPuesto != -99 && idPuesto != -999) {
          result = await usuarioLg.exitPostworking(
              idPuesto, tipe, idProfessionalLoggedIn!);
          if (result == true) {
            await ColacionProfessional(idProfessionalLoggedIn, tipe, 0);
            bool exit = await usuarioLg.exitHours(
                branchIdLoggedIn, idProfessionalLoggedIn, tokenUserLoggedIn);
            if (exit) {
              print('YA registra la hora de salida del barbero o tecnico');
            } else {
              print('NO registró la hora de salida del barbero o tecnico');
            }
          } else {
            print(
                'este es el id del puesto NO SALIO DEL PUESTO EL PROFESIONAL');
          }
        }
      } else if (tipe == 'Admin') {
        bool exit = await usuarioLg.exitHours(
            branchIdLoggedIn, idProfessionalLoggedIn, tokenUserLoggedIn);
        if (exit) {
          print('YA registra la hora de salida del encargado o coordinador');
        } else {
          print('NO registró la hora de salida encargado o coordinador');
        }
      }
    } catch (e) {
      print('Erroor:$e');
    }
  }

  Future<int> ColacionProfessional(idProfe, type, state) async {
    try {
      int exit = await usuarioLg.solitColacion(
          branchIdLoggedIn, idProfe, type, state, tokenUserLoggedIn);

      if (state == 2) //es solicitud a enviar
      {
        if (exit == 1) {
          //aqui enviar notificacion que fue aceptada y que salio del puesto y poner el QR a false
          print('solicitud aceptada');
        }
      } else if (state == 1) //es solicitud a enviar
      {
        if (exit == 1) {
          //mandar mensaje que fue rechazada
          print('solicitud rechazada');
        }
      } else if (state == 3) //es solicitud a enviar
      {
        if (exit == 1) {
          //mandar mensaje y que le salga a los cordinadores y encargados la solicitud
          print('solicitud enviada');
        }
      }

      return exit; //if es 1 bien , si es 2 codigo diferente a 200
    } catch (e) {
      print('Erroor:$e');
      return 3;
    }
  }

  Future<int> getIdPuesto(int idProfes) async {
    try {
      //INICIALIZANDO A NULL
      int idPuesto = -99;
      print('este s es el id del puesto idProfes:$idProfes');
      idPuesto = await usuarioLg.getIdPuestoRepo(idProfes, chargeUserLoggedIn);
      print(
          'este s es el id del puesto idProfes despue sde llamar al puesto:$idPuesto');

      print('NO s ESTA EN NINGUN PUESTO EL PROFESIONAL');
      return idPuesto;
    } catch (e) {
      print('Erroor:$e');
      return -999;
    }
  }

  Future<int> getEntradaPuesto(int idProfes, int branch) async {
    try {
      //INICIALIZANDO A NULL
      int idPuesto = -99;
      print('este s es el id del puesto idProfes:$idProfes');
      idPuesto = await usuarioLg.getEntradaPuestoRepo(idProfes, branch);
      print(
          'este s es el id del puesto idProfes despue sde llamar al puesto:$idPuesto');

      return idPuesto;
    } catch (e) {
      print('Erroor:$e');
      return -999;
    }
  }

  Future<int> getStateProfessionall(int idProfes) async {
    try {
      //INICIALIZANDO A NULL
      int state = -99;
      state = await usuarioLg.getStateProfessional(idProfes);
      print(
          'este es el id del puesto idProfes despue sde llamar al state:$state');

      return state;
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
    pressedButtonIds.clear();
    pressedButtonIdsTec.clear();
    //
    branchNameLoggedIn = null;
    branchTecnicLoggedIn = 0;
    usserPermissionQr = null;
    usserMssQr = -99;

    //*************************/
    obscureText = true;
    qrRead = '';
    greeting = 'Buenos días ';
    isLoggingIn = false;
    isLoggingInCharge = false;

    update();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    update();
  }
}
