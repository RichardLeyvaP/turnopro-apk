// ignore_for_file: depend_on_referenced_packages, unused_element, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/get_connect/repository/clientsScheduled.repository.dart';
import 'package:turnopro_apk/get_connect/repository/user.repository.dart';

class ClientsScheduledController extends GetxController {
  //DECLARACION DE VARIABLES
  ClientsScheduledRepository repository = ClientsScheduledRepository();
  UserRepository repositoryUser = UserRepository();
  final LoginController controllerLogin = Get.find<LoginController>();

  int clientNew = 0;

  List<ClientsScheduledModel> clientsScheduledList = []; // Lista de clientes
  List<int> clientsScheduledListId = []; // Lista de clientes
  // Lista de clientes
  List<ClientsScheduledModel> clientsScheduledListTechnical = []; // Lista de clientes
  List<ClientsScheduledModel> selectClientsScheduledList = [];
  List<ClientsScheduledModel> selectclientsScheduledListTechnical = [];
  ClientsScheduledModel? clientsScheduledNext; // Cliente en espera
  ClientsScheduledModel? clientsScheduledNextServ; // Cliente en espera
  ClientsScheduledModel? clientsScheduledNextServAux; // Cliente en espera
  ClientsScheduledModel? clientsNextTechnical; // Cliente en espera
  ClientsScheduledModel? clientsAttended1; // Cliente en espera
  ClientsScheduledModel? clientsAttendedTechnical,
      clientsAttended2,
      clientsAttended3,
      clientsAttended4; // Cliente en espera
  int? timeClientsAttended1, timeClientsAttended2, timeClientsAttended3, timeClientsAttended4;
  //en estas variables de notificationClients es para no repetir las notificaciones de un mismo cliente
  int? notificationClients1, notificationClients2, notificationClients3, notificationClients4;

  int? timeClientsActAttended1, timeClientsActAttended2, timeClientsActAttended3, timeClientsActAttended4;
  List<int> item = [];
  List<int> itemDel = [];
  bool activeModifyTime = false;
  bool activeModifyTimeRest = false;
  bool activeModifyTimeRestBE = false;
  int modifyTimeSpecific = -99;
  int modifyTimeSpecificRest = -99;
  int modifyTimeSpecificRest1 = -99;
  int modifyTimeSpecificRest2 = -99;
  int modifyTimeSpecificRest3 = -99;
  int modifyTimeSpecificRestTIME = 0;
  int modifyTimeSpecificRestTIME1 = 0;
  int modifyTimeSpecificRestTIME2 = 0;
  int modifyTimeSpecificRestTIME3 = 0;
  List<int> modifyTime = [
    -1, //este es de _animationController1
    -1, //este es de _animationController2
    -1, //este es de _animationController3
    -1 //este es de _animationController4
  ]; //cuando alguno sea -1 modificar ese tiempo
  List<int> modifyTimeRest = [
    -1, //este es de _animationController1
    -1, //este es de _animationController2
    -1, //este es de _animationController3
    -1 //este es de _animationController4
  ]; //cuando alguno sea -1 modificar ese tiempo
  int availability = 1;
  int busyClock = -99;
  String clientsAttended = 'nobody';
  String technicalClientsAttended = 'nobody';
  List<ServiceModel> serviceCustomerSelected = [], serviceCustomerAux = [];
  List<ServiceModel> serviceCustomerSelected1 = [];
  List<ServiceModel> serviceCustomerSelectedForm = [];
  List<ServiceModel> serviceCustomerSelectedForm1 = [];
  List<ProfessionalModel> professionalDispon = [];
  int professionalDisponLength = 0;

  int clientsScheduledListLength = 0;
  int clientsScheSalon = 0;
  int errorHome = 0;
  int clientsScheduledListLengthTail = 0;
  bool errorClientAcept = false;
  funtErrorClientAcept(bool value) {
    errorClientAcept = value;
  }

  int clientsTechnicalLength = 0;
  int? carIdClientsScheduled;
  int quantityClientAttended = 0;
  int quantityClientAttendedTechnical = 0;
  bool isLoading = true;
  bool correctConnection = true;

  //Variables del reloj
  double sizeClock = 145;
  double sizeClockTechnical = 145;
  int totalTimeInitial = 3 * 60; //Iniciando en 3 minutos el reloj
  int totalTimeInitialT = 3 * 60; //Iniciando en 3 minutos el reloj
  bool callCliente = false; //si esta en false es que es la primera vez
  bool boolFilterShowNext = false; //si esta en false es que es la primera vez
  bool boolFilterShowNextAux = false; //si esta en false es que es la primera vez
  bool boolControlVision = false; //si esta en false es que es la primera vez
  bool boolFilterShowNextTecnhical = false; //si esta en false es que es la primera vez
  bool showingServiceClients = false;
  bool showingServiceClientsTechnical =
      false; // mostrando los servicios de algun cliente en el tecnico
  int filterShowTimer = 0; //si esta en false es que es la primera vez
  int statusClientTemporary = -99;
  String nameClientTemporary = 'Cliente';
  int idClientTemporary = -99;
  String urlImageTemporary = 'comments/default_profile.jpg';
  bool varClientsWaiting = false;
  int contClientsWaiting = 0;
  int endingTime = 3; //Tiempo restante de un servicio en minutos,ahi se le manda una notificacion

  Map<int, int> pausResumeClock = {
    0: -99,
    1: -99,
    2: -99,
    3: -99,
  };
  bool clockchanges = false;
  bool closeIesperado = false;
  bool closeIesperadoLogin = false;
  String? imagePath;
  XFile? pickedFile;

  int cantClientWait = 0;
  clearImage() {
    pickedFile = null;
    imagePath = null;
    // update();
  }

  updateTails() {
    clientsScheduledListLength = 0;
    update();
  }

  //
  //
  //
  String clientNameBarber = '';
  String professionalNameBarber = '';
  String branchNameBarber = '';
  String imageDataBarber = '';
  String imageUrlBarber = '';
  String imageLookBarber = '';
  int cantVisitBarber = 0;
  String endLookBarber = '';
  String lastDateBarber = '';
  String frecuenciaBarber = ''; //
  //
  //
  String clientNameBarber1 = '';
  String professionalNameBarber1 = '';
  String branchNameBarber1 = '';
  String imageDataBarber1 = '';
  String imageUrlBarber1 = '';
  String imageLookBarber1 = '';
  int cantVisitBarber1 = 0;
  String endLookBarber1 = '';
  String lastDateBarber1 = '';
  String frecuenciaBarber1 = '';
  bool waitTime = false; //false es que puede hacer llamadas a buscar la cola
  int waitTimeCount = 30; //false es que puede hacer llamadas a buscar la cola

  int convertTimeToMinutes(String time) {
    // Divide el string en partes separadas por ":"
    List<String> parts = time.split(':');

    // Verifica que el formato tenga al menos horas y minutos
    if (parts.length >= 2) {
      int hours = int.parse(parts[0]); // Convierte horas a entero
      int minutes = int.parse(parts[1]); // Convierte minutos a entero

      // Convierte todo a minutos
      return (hours * 60) + minutes;
    } else {
      throw FormatException('Formato de tiempo inválido');
    }
  }

  int convertTimeToSeconds(String time) {
    // Divide el string en partes separadas por ":"
    List<String> parts = time.split(':');

    // Verifica que el formato tenga horas, minutos y segundos
    if (parts.length == 3) {
      int hours = int.parse(parts[0]); // Convierte horas a entero
      int minutes = int.parse(parts[1]); // Convierte minutos a entero
      int seconds = int.parse(parts[2]); // Convierte segundos a entero

      // Convierte todo a segundos
      return (hours * 3600) + (minutes * 60) + seconds;
    } else {
      throw FormatException('Formato de tiempo inválido');
    }
  }

  Future getShowClock(int differenceInSeconds, idProf, token) async {
    print('RETORNE---Clock: si la diferencia es:differenceInSeconds= {$differenceInSeconds}');
    if (differenceInSeconds > 10) {
      final result = await repository.repoShowClock(differenceInSeconds, idProf, token);
      print('entré aca a cambiar el tiempo del reloj **********');
      if (result is Map<String, int>) {
        // Manejo de una respuesta exitosa
        int timeC1 = result['timeC1'] ?? -999;
        int timeC2 = result['timeC2'] ?? -999;
        int timeC3 = result['timeC3'] ?? -999;
        int timeC4 = result['timeC4'] ?? -999;
        if (timeC1 != -999) //es que esta activo
        {
          print('entré aca a cambiar el tiempo del reloj -3:time:$timeC1');
          //lo reinicio con el nuevo tiempo
          animationController1!
            ..duration = Duration(seconds: timeC1)
            ..reset()
            ..forward();
          controllerLogin.getUpdateTime(timeC1, 1, 'clientSche-getShowClock');
        }
        if (timeC2 != -999) //es que esta activo
        {
          print('entré aca a cambiar el tiempo del reloj -3:time:$timeC2');

          animationController2!
            ..duration = Duration(seconds: timeC2)
            ..reset()
            ..forward();
          controllerLogin.getUpdateTime(timeC2, 2, 'clientSche-getShowClock');
        }
        if (timeC3 != -999) //es que esta activo
        {
          print('entré aca a cambiar el tiempo del reloj -3:time:$timeC3');
          //lo reinicio con el nuevo tiempo
          //lo reinicio con el nuevo tiempo
          animationController3!
            ..duration = Duration(seconds: timeC3)
            ..reset()
            ..forward();
          controllerLogin.getUpdateTime(timeC3, 3, 'clientSche-getShowClock');
        }
        if (timeC4 != -999) //es que esta activo
        {
          print('entré aca a cambiar el tiempo del reloj -4:time:$timeC4');
          //lo reinicio con el nuevo tiempo
          //lo reinicio con el nuevo tiempo
          animationController4!
            ..duration = Duration(seconds: timeC4)
            ..reset()
            ..forward();
          controllerLogin.getUpdateTime(timeC4, 4, 'clientSche-getShowClock');
        }
      } else if (result == false) {
        // Manejo de un caso donde la respuesta es falsa
        print('No se pudo procesar la solicitud.');
      } else if (result == -999) {
        // Manejo de un caso de error
        print('Error en la solicitud.');
      } else {
        // Manejo de un caso inesperado
        print('Respuesta inesperada: $result');
      }
    }
  }

  void setwaitTimeCount(value) {
    if (value == 1) {
      waitTimeCount--;
      print('entrando funcion nueva -sumando ----- waitTimeCount=$waitTimeCount');
    } else if (value == 0) {
      print('entrando funcion nueva - ---- poniendo a 0');
      waitTimeCount = 30;
    }
    update();
  }

  int getwaitTimeCount() {
    return waitTimeCount;
  }

  void setClientsScheSalon(value) {
    clientsScheSalon = value;
    update();
  }

  void setWaitTime(value) {
    waitTime = value;
  }

  bool getWaitTime() {
    return waitTime;
  }

  void setactiveModifyTimeRestBE(value) {
    activeModifyTimeRestBE = value;
    update();
  }

  void setcantClientWait(value) {
    cantClientWait = value;
    update();
  }

  void setclientLisError(value) {
    errorHome = value;
    update();
  }

  void setTotalTimeInitial(value) {
    totalTimeInitial = value;
    update();
  }

  void setImagePath(value) {
    imagePath = value;
    isLoading = false;
    update();
  }

  void setclientNew(value) {
    clientNew = value;

    update();
  }

  void setNotificationClients1(int value, int idClient, String telefone) {
    if (value == 1) {
      sendWhatsappNotification(telefone);
      notificationClients1 = idClient;
    }
    if (value == 2) {
      sendWhatsappNotification(telefone);
      notificationClients2 = idClient;
    }
    if (value == 3) {
      sendWhatsappNotification(telefone);
      notificationClients3 = idClient;
    }
    if (value == 4) {
      sendWhatsappNotification(telefone);
      notificationClients4 = idClient;
    }
    update();
  }

  void clearNotificationClients1(int value) {
    if (value == 1) {
      notificationClients1 = null;
    }
    if (value == 2) {
      notificationClients2 = null;
    }
    if (value == 3) {
      notificationClients3 = null;
    }
    if (value == 4) {
      notificationClients4 = null;
    }
    update();
  }

  void setContClientsWaiting(int value) {
    if (value == -90009) //-999 indica que es para igualar 0
    {
      contClientsWaiting = 0;
    } else if (value == -91119) {
      //esto es sumarle 1;
      contClientsWaiting += 1;
    } else {
      contClientsWaiting = value;
    }
    update();
  }

  void clientsWaiting(value) {
    varClientsWaiting = value;
    update();
  }

  Future<void> loadingValue(bool value) async {
    isLoading = value;
    update();
  }

  void setPickedFile(value) {
    pickedFile = value;
    update();
  }

  void setCloseIesperado(bool value) {
    closeIesperado = value;
    update();
  }

  void setCloseIesperadoLogin(bool value) {
    closeIesperadoLogin = value;
    update();
  }

  void setBoolFilterShowNext(bool value) {
    boolFilterShowNext = value;

    update();
  }

  void setBoolControlVision(bool value) {
    boolControlVision = value;
    update();
  }

  //Fin Variables del reloj

  //VARIABLES PARA EL CONTROL DE INCUMPLIMINETOS (convivencia)
  //ESTA VARIABLE HAY QUE LLENARLA DIRECTAMENTE DE LA DB
  Map<String, int> noncomplianceProfessional = {};

  //
  //
  //
  AnimationController? animationControllerInitial;

  AnimationController? animationController1;

  AnimationController? animationController2;

  AnimationController? animationController3;

  AnimationController? animationController4;

  bool verificateValueTimers() {
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;
    if (hasClient1 || hasClient2 || hasClient3 || hasClient4) {
      return true;
    } else {
      return false;
    }
  }

  final clock1 = {'clock': 1, 'timeClock': 30};
  final clock2 = {'clock': 2, 'timeClock': 120};
  final clock3 = {'clock': 3, 'timeClock': 0};
  final clock4 = {'clock': 4, 'timeClock': 0};

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final newClock1 = {
      'clock': 23,
      'timeClock': 124,
    };
    prefs.setInt('clock1', newClock1['clock']!);
    prefs.setInt('timeClock1', newClock1['timeClock']!);
    final newClock2 = {
      'clock': 36,
      'timeClock': 567,
    };
    prefs.setInt('clock2', newClock2['clock']!);
    prefs.setInt('timeClock2', newClock2['timeClock']!);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final clock1 = {
      'clock': prefs.getInt('clock1') ?? 0,
      'timeClock': prefs.getInt('timeClock1') ?? 0,
    };
    final clock2 = {
      'clock': prefs.getInt('clock2') ?? 0,
      'timeClock': prefs.getInt('timeClock2') ?? 0,
    };
    // Puedes utilizar los datos recuperados como desees.
    print('Reloj 1: $clock1');
    print('Reloj 2: $clock2');
  }

  upadateVariablesValueTimersPreferenc() async {

    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;
    //
    int remainingTime1, remainingTime2, remainingTime3, remainingTime4, reservationId;

    if (hasClient1) {
      // cambio de verificacion
      ClientsScheduledModel? Aux = clientsAttended1;
      double currentTimeDouble = animationController1!.value * animationController1!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController1!.duration!.inSeconds;
      remainingTime1 = totalTimeInSeconds - currentTimeDouble.toInt(); //En segundos
      // Convertir a minutos
      int remainingMinutes1 = (remainingTime1 / 60).floor(); //MINUTOS RESTANTES

      reservationId = Aux!.reservation_id!; //DB - reservation_id
      await LocalStorage.prefs.setInt('timer1', remainingTime1); //en segundos
      await LocalStorage.prefs.setInt('timer1Attend', Aux.attended!); //saber si esta con el tecnico
      if (clientsAttended1 == null) {
        await LocalStorage.prefs.setInt('timer1', -999); //en segundos
      }
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante:upadateVariablesValueTimersPreferenc = $remainingTime1 reservation_id : $reservationId ');
    } else {
      await LocalStorage.prefs.setInt('timer1', -999); //en segundos
      //poner la variable en -999
    }
    if (hasClient2) {
      ClientsScheduledModel? aux2 = clientsAttended2;
      double currentTimeDouble = animationController2!.value * animationController2!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController2!.duration!.inSeconds;
      remainingTime2 = totalTimeInSeconds - currentTimeDouble.toInt(); //segundos
      // Convertir a minutos
      int remainingMinutes2 = (remainingTime2 / 60).floor(); //MINUTOS RESTANTES
      reservationId = aux2!.reservation_id!; //DB - reservation_id
      await LocalStorage.prefs.setInt('timer2', remainingTime2); //en segundos
      await LocalStorage.prefs.setInt('timer2Attend', aux2.attended!); //saber si esta con el tecnico
      if (clientsAttended2 == null) {
        await LocalStorage.prefs.setInt('timer2', -999); //en segundos
      }
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended2 reservation_id : $reservationId ');
    } else {
      //poner en -999
      await LocalStorage.prefs.setInt('timer2', -999); //en segundos
    }
    if (hasClient3) {
      ClientsScheduledModel? aux3 = clientsAttended3;
      double currentTimeDouble = animationController3!.value * animationController3!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController3!.duration!.inSeconds;
      remainingTime3 = totalTimeInSeconds - currentTimeDouble.toInt(); //segundos
      // Convertir a minutos
      int remainingMinutes3 = (remainingTime3 / 60).floor(); //MINUTOS RESTANTES
      reservationId = aux3!.reservation_id!; //DB - reservation_id print(
      await LocalStorage.prefs.setInt('timer3', remainingTime3); //en segundos
      await LocalStorage.prefs.setInt('timer3Attend', aux3.attended!); //saber si esta con el tecnico
      if (clientsAttended3 == null) {
        await LocalStorage.prefs.setInt('timer3', -999); //en segundos
      }
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended3 reservation_id : $reservationId ');
    } else {
      //poner -999
      await LocalStorage.prefs.setInt('timer3', -999); //en segundos
    }
    if (hasClient4) {
      ClientsScheduledModel? aux4 = clientsAttended4;
      double currentTimeDouble = animationController4!.value * animationController4!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController4!.duration!.inSeconds;
      remainingTime4 = totalTimeInSeconds - currentTimeDouble.toInt(); //segundos
      // Convertir a minutos
      int remainingMinutes4 = (remainingTime4 / 60).floor(); //MINUTOS RESTANTES
      reservationId = aux4!.reservation_id!; //DB - reservation_id print(
      await LocalStorage.prefs.setInt('timer4', remainingTime4); //en segundos
      await LocalStorage.prefs.setInt('timer4Attend', aux4.attended!); //saber si esta con el tecnico
      if (clientsAttended4 == null) {
        await LocalStorage.prefs.setInt('timer4', -999); //en segundos
      }
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended4 reservation_id : $reservationId ');
    } else {
      await LocalStorage.prefs.setInt('timer4', -999); //en segundos
    }
  }

  void verifyingClockTimeNew(int t1, int t2, int t3, int t4) {
    final NotificationController notiController = Get.find<NotificationController>();
    String teleClient = '';
    if (clientsScheduledNext != null) {
      teleClient = clientsScheduledNext!.telefone_client!;
      print('cargando aqui-8-EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera:TELEFONO:$teleClient');
    } else {
      print('cargando aqui-8-TELEFONO-NULO:$teleClient');
    }
    print('cargando aqui-8');
    try {
      //este es para el reloj 1
      if (clientsAttended1 != null) {
        if (animationController1 != null && animationController1!.isAnimating) {

          int? idClient = clientsAttended1?.client_id;
          String? nameClient = clientsAttended1?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (notificationClients1 == null || (notificationClients1 != idClient && notificationClients1 != null)) {
              if (animationController1 != null) {
                print('Mandar notificacionq ue el tiempo acabó-***ENTRANDO***-');

                if (t1 != -99 && t1 <= 195 && t1 >= 0) {
                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;
                  notiController.storeNotification(
                      '!Alerta',
                      branchId,
                      professionalId,
                      'El tiempo de servicio del cliente $nameClient se agotará aproximadamente en 3 minutos',
                      'no',
                      'Profesional');

                  //llama al metodo que me dice que para este cliente ya se envio una notificacion al Profesional
                  String teleClient = '';
                  if (clientsScheduledNext != null) {
                    teleClient = clientsScheduledNext!.telefone_client!;
                    print('cargando aqui-8-Actualizando la variable-TELEFONO:$teleClient');
                  }
                  setNotificationClients1(
                      1, //esto indica que es el reloj 1
                      clientsAttended1!.client_id!,
                      teleClient);
                  print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera:TELEFONO:$teleClient');
                  // notificate
                  // scheduleNotification('!Alerta',
                  //     'El tiempo de servicio del cliente $nameClient se agotará');
                } else {
                  print('Mandar notificacionq ue el tiempo -***hrActua:-(1):***-');
                }
              }
            }
          }
        } else {
          print('object-2');
        }
      } else {
        animationController1!.stop();
        clearNotificationClients1(1);
        print('object-2-2 reloj 1');
      }
//este es para el reloj 2
      if (clientsAttended2 != null) {
        if (animationController2 != null && animationController2!.isAnimating) {
          print('object-1 reloj 2');
          int? idClient = clientsAttended2?.client_id;
          String? nameClient = clientsAttended2?.client_name;
          if (idClient != null && nameClient != null) {
            if (notificationClients2 == null || (notificationClients2 != idClient && notificationClients2 != null)) {
              if (animationController2 != null) {
                // verifico aqui si el tiempo con la hora actual
                if (t2 != -99 && t2 <= 195 && t2 >= 0) {
                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;
                  notiController.storeNotification(
                      '!Alerta',
                      branchId,
                      professionalId,
                      'El tiempo de servicio del cliente $nameClient se agotará aproximadamente en 3 minutos',
                      'no',
                      'Profesional');

                  if ((idClient == clientsAttended2?.client_id)) {
                    //llama al metodo que me dice que para este cliente ya se envio una notificacion al Profesional
                    String teleClient = '';
                    if (clientsScheduledNext != null) {
                      teleClient = clientsScheduledNext!.telefone_client!;
                    }
                    setNotificationClients1(
                        2, //esto indica que es el reloj 2
                        clientsAttended2!.client_id!,
                        teleClient);
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 2**');
        }
      } else {
        animationController2!.stop();
        clearNotificationClients1(2);
        print('object-2-2 reloj 2');
      }
      //este es para el reloj 3
      if (clientsAttended3 != null) {
        if (animationController3 != null && animationController3!.isAnimating) {
          print('object-1 reloj 3');
          int? idClient = clientsAttended3?.client_id;
          String? nameClient = clientsAttended3?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (notificationClients3 == null || (notificationClients3 != idClient && notificationClients3 != null)) {
              if (animationController3 != null) {
                // verifico aqui si el tiempo con la hora actual
                if (t3 != -99 && t3 <= 195 && t3 >= 0) {
                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;
                  notiController.storeNotification(
                      '!Alerta',
                      branchId,
                      professionalId,
                      'El tiempo de servicio del cliente $nameClient se agotará aproximadamente en 3 minutos',
                      'no',
                      'Profesional');

                  if ((idClient == clientsAttended3?.client_id)) {
                    //llama al metodo que me dice que para este cliente ya se envio una notificacion al Profesional
                    String teleClient = '';
                    if (clientsScheduledNext != null) {
                      teleClient = clientsScheduledNext!.telefone_client!;
                    }
                    setNotificationClients1(
                        3, //esto indica que es el reloj 2
                        clientsAttended3!.client_id!,
                        teleClient);

                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 3');
        }
      } else {
        animationController3!.stop();
        clearNotificationClients1(3);
        print('object-2-2 reloj 3');
      }

      //este es para el reloj 4
      if (clientsAttended4 != null) {
        if (animationController4 != null && animationController4!.isAnimating) {
          print('object-1 reloj 4');
          int? idClient = clientsAttended4?.client_id;
          String? nameClient = clientsAttended4?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (notificationClients4 == null || (notificationClients4 != idClient && notificationClients4 != null)) {
              if (animationController4 != null) {
                if (t4 != -99 && t4 <= 195 && t4 >= 0) {
                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;
                  notiController.storeNotification(
                      '!Alerta',
                      branchId,
                      professionalId,
                      'El tiempo de servicio del cliente $nameClient se agotará aproximadamente en 3 minutos',
                      'no',
                      'Profesional');

                  if ((idClient == clientsAttended4?.client_id)) {
                    //llama al metodo que me dice que para este cliente ya se envio una notificacion al Profesional
                    String teleClient = '';
                    if (clientsScheduledNext != null) {
                      teleClient = clientsScheduledNext!.telefone_client!;
                    }
                    setNotificationClients1(
                        4, //esto indica que es el reloj 1
                        clientsAttended4!.client_id!,
                        teleClient);

                  }
                }
              }
            }
          }
        }
      } else {
        animationController4!.stop();
        clearNotificationClients1(4);

      }
      //
      //
    } catch (e) {
      print('Error :$e');
    }
  }

  // relojes estan activos-upadateVariablesValueTimers-clientsSchudeld';
  upadateVariablesValueTimers() async {

    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;

    int t1 = -99, t2 = -99, t3 = -99, t4 = -99;
    //
    int remainingTime1, remainingTime2, remainingTime3, remainingTime4, reservationId, clock, detached;
    if (hasClient1 && controllerLogin.getCallDeleteService1() == true) {
      double currentTimeDouble = animationController1!.value * animationController1!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController1!.duration!.inSeconds;
      remainingTime1 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes1 = (remainingTime1 / 60).floor(); //MINUTOS RESTANTES
      int remainingSeconds1 = remainingTime1 % 60; //SEGUNDOS RESTANTES
      // Convierte el tiempo total restante a segundos
      int timeSave = remainingMinutes1 * 60 + remainingSeconds1;

// Guardar el valor en la base de datos
      timeClientsActAttended1 = timeSave; // Almacena en la basmpo en segune de datos el tiedos
      t1 = timeSave;

      reservationId = clientsAttended1!.reservation_id!; //DB - reservation_id
      clock = 1; //DB - clock
      detached = 1; //DB - detached

      print('entrando pa saber que relojes - timeSave:$timeSave-----totalTimeInSeconds:$totalTimeInSeconds');
      await setTimeClock(reservationId, timeClientsActAttended1, detached, clock, true,
          controllerLogin.tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante:segund = $remainingTime1 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient2 && controllerLogin.getCallDeleteService2() == true) {
      double currentTimeDouble = animationController2!.value * animationController2!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController2!.duration!.inSeconds;
      remainingTime2 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes2 = (remainingTime2 / 60).floor(); //MINUTOS RESTANTES
      int remainingSeconds2 = remainingTime2 % 60; //SEGUNDOS RESTANTES
      // Convierte el tiempo total restante a segundos
      int timeSave = remainingMinutes2 * 60 + remainingSeconds2;

// Guardar el valor en la base de datos
      timeClientsActAttended2 = timeSave; // Almacena en la basmpo en segune de datos el tiedos
      t2 = timeSave;

      reservationId = clientsAttended2!.reservation_id!; //DB - reservation_id
      clock = 2; //DB - clock
      detached = 1; //DB - detached

      await setTimeClock(reservationId, timeClientsActAttended2, detached, clock, true,
          controllerLogin.tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended2 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient3 && controllerLogin.getCallDeleteService3() == true) {
      double currentTimeDouble = animationController3!.value * animationController3!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController3!.duration!.inSeconds;
      remainingTime3 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes3 = (remainingTime3 / 60).floor(); //MINUTOS RESTANTES
      int remainingSeconds3 = remainingTime3 % 60; //SEGUNDOS RESTANTES
      // Convierte el tiempo total restante a segundos
      int timeSave = remainingMinutes3 * 60 + remainingSeconds3;

// Guardar el valor en la base de datos
      timeClientsActAttended3 = timeSave; // Almacena en la basmpo en segune de datos el tiedos
      t3 = timeSave;
      //timeClientsActAttended3 = remainingMinutes3; //DB - timeClock
      reservationId = clientsAttended3!.reservation_id!; //DB - reservation_id
      clock = 3; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(reservationId, timeClientsActAttended3, detached, clock, true,
          controllerLogin.tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended3 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    }
    if (hasClient4 && controllerLogin.getCallDeleteService4() == true) {
      double currentTimeDouble = animationController4!.value * animationController4!.duration!.inSeconds.toDouble();
      int totalTimeInSeconds = animationController4!.duration!.inSeconds;
      remainingTime4 = totalTimeInSeconds - currentTimeDouble.toInt();

      // Convertir a minutos
      int remainingMinutes4 = (remainingTime4 / 60).floor(); //MINUTOS RESTANTES
      int remainingSeconds4 = remainingTime4 % 60; //SEGUNDOS RESTANTES
      // Convierte el tiempo total restante a segundos
      int timeSave = remainingMinutes4 * 60 + remainingSeconds4;

// Guardar el valor en la base de datos
      timeClientsActAttended4 = timeSave; // Almacena en la basmpo en segune de datos el tiedos
      t4 = timeSave;
      //timeClientsActAttended4 = remainingMinutes4; //DB - timeClock
      reservationId = clientsAttended4!.reservation_id!; //DB - reservation_id
      clock = 4; //DB - clock
      detached = 1; //DB - detached
      //  await set_timeClock(reservation_id,timeClock,detached,clock);
      await setTimeClock(reservationId, timeClientsActAttended4, detached, clock, true,
          controllerLogin.tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min
      print(
          'EL TIEMPO ACTUAL DEL RELOJ 1 ES Tiempo restante: $timeClientsActAttended4 reservation_id : $reservationId -  clock : $clock - detached :$detached');
    } else {
      print('EL TIEMPO ACTUAL DEL RELOJ 1 ES Nulo:$timeClientsActAttended1 ');
    }

    if (t1 != -99 || t2 != -99 || t3 != -99 || t4 != -99) {
      verifyingClockTimeNew(t1, t2, t3, t4);
      if (animationControllerInitial != null && animationControllerInitial!.isAnimating) {
        animationControllerInitial!
          ..duration = Duration(seconds: 180)
          ..reset()
          ..stop();
      }
    } else if (clientsScheSalon != 0 &&
        animationControllerInitial != null &&
        !animationControllerInitial!.isAnimating) {
      animationControllerInitial!
        ..duration = Duration(seconds: 180)
        ..reset()
        ..forward();
    }

    update();
  }

  Future<void> newClientAttended(ClientsScheduledModel client, int avail) async {
    //este nuevo cliente se le va a signar un reloj
    if (avail == 1) {
      clientsAttended1 = client;
      timeClientsAttended1 = convertDateSecons(client.total_time!);
      print('value del reloj actual-tiempo a modificar -timeClientsAttended1:${client.total_time!}');
      int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended1!);
      //aqui hace analisis y guarda en memoria del telefono
      //cuando falta 3 minu para acabar
      controllerLogin.getUpdateTime(timeMinutes, 1, 'newClientAttended-1');

      busyClock = 0;
    }
    if (avail == 2) {
      clientsAttended2 = client;
      timeClientsAttended2 = convertDateSecons(client.total_time!);
      int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended2!);
      //hace analisis y guarda en memoria del telefono
      //cuando falta 3 minu para acabar
      controllerLogin.getUpdateTime(timeMinutes, 2, 'newClientAttended-2');

      busyClock = 1;
    }
    if (avail == 3) {
      clientsAttended3 = client;
      timeClientsAttended3 = convertDateSecons(client.total_time!);

      int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended3!);
      // hace analisis y guarda en memoria del telefono
      //cuando falta 3 minu para acabar
      controllerLogin.getUpdateTime(timeMinutes, 3, 'newClientAttended-3');
      // metodo nuevo para avisar y mandar notif cuando el servico se este acabando
      busyClock = 2;
    }
    if (avail == 4) {
      clientsAttended4 = client;
      timeClientsAttended4 = convertDateSecons(client.total_time!);

      int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended4!);

      controllerLogin.getUpdateTime(timeMinutes, 4, 'newClientAttended-4');
      // metodo nuevo para avisar y mandar notif cuando el servico se este acabando
      busyClock = 3;
    }
    filterShowCardTimer();
    update();
  }

  void filterShowCardTimer() {
    bool hasClient1 = clientsAttended1 != null;
    bool hasClient2 = clientsAttended2 != null;
    bool hasClient3 = clientsAttended3 != null;
    bool hasClient4 = clientsAttended4 != null;

    if (hasClient1 && !hasClient2 && !hasClient3 && !hasClient4) {
      print('client1');
      clientsAttended = 'client1';
      item.clear();
      item.add(0);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 2, 3]);
    } else if (!hasClient1 && hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'client2';
      print('client2');
      item.clear();
      item.add(1);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 2, 3]);
    } else if (hasClient1 && hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'client1 y client2';
      print('client1 y client2');
      item.clear();
      item.addAll([0, 1]);
      availability = 3; //este esta disponible
      itemDel.clear();
      itemDel.addAll([2, 3]);
    } else if (!hasClient1 && !hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client3';
      print('client3');
      item.clear();
      item.add(2);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1, 3]);
    } else if (!hasClient1 && !hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client4';
      print('client4');
      item.clear();
      item.add(3);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1, 2]);
    } else if (hasClient1 && !hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client1 y client3';
      print('client1 y client3');
      item.clear();
      item.addAll([0, 2]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 3]);
    } else if (hasClient1 && !hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client1 y client4';
      print('client1 y client4');
      item.clear();
      item.addAll([0, 3]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.addAll([1, 2]);
    } else if (!hasClient1 && hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client2 y client3';
      print('client2 y client3');
      item.clear();
      item.addAll([1, 2]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 3]);
    } else if (!hasClient1 && hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client2 y client4';
      print('client2 y client4');
      item.clear();
      item.addAll([1, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 2]);
    } else if (!hasClient1 && !hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client3 y client4';
      print('client3 y client4');
      item.clear();
      item.addAll([2, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.addAll([0, 1]);
    } else if (hasClient1 && hasClient2 && hasClient3 && !hasClient4) {
      clientsAttended = 'client1, client2 y client3';
      print('client1 y client2 y client3');
      item.clear();
      item.addAll([0, 1, 2]);
      availability = 4; //este esta disponible
      itemDel.clear();
      itemDel.add(3);
    } else if (hasClient1 && hasClient2 && !hasClient3 && hasClient4) {
      clientsAttended = 'client1, client2 y client4';
      print('client1 y client2 y client4');
      item.clear();
      item.addAll([0, 1, 3]);
      availability = 3; //este esta disponible
      itemDel.clear();
      itemDel.add(2);
    } else if (!hasClient1 && hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client2, client3 y client4';
      print('client2 y client3 y client4');
      item.clear();
      item.addAll([1, 2, 3]);
      availability = 1; //este esta disponible
      itemDel.clear();
      itemDel.add(0);
    } else if (hasClient1 && !hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'client1, client3 y client4';
      print('client1 y client3 y client4');
      item.clear();
      item.addAll([0, 2, 3]);
      availability = 2; //este esta disponible
      itemDel.clear();
      itemDel.add(1);
    } else if (hasClient1 && hasClient2 && hasClient3 && hasClient4) {
      clientsAttended = 'todos los clientes';
      print('todos los clientes');
      item.clear();
      item.addAll([0, 1, 2, 3]);
      availability = -99; //NO tiene disponible
      itemDel.clear();
    } else if (!hasClient1 && !hasClient2 && !hasClient3 && !hasClient4) {
      clientsAttended = 'nobody';
      print('nobody');

      item.clear();
      availability = 1; //este esta disponible
      itemDel.addAll([0, 1, 2, 3]);
    }


  }

  rest() {
    if (modifyTimeSpecificRest != -99) //reloj 1
    {
      print('modificar time de mm  entrando al metodo nuevo----rest()-1');

      int value = modifyTimeSpecificRestTIME;
      subtractDurationFromTimer(animationController1!, Duration(seconds: value));
      modifyTimeSpecificRest = -99;
      modifyTimeSpecificRestTIME = 0;
    }

    if (modifyTimeSpecificRest1 != -99) //reloj 2
    {

      int value = modifyTimeSpecificRestTIME1;
      subtractDurationFromTimer(animationController2!, Duration(seconds: value));
      modifyTimeSpecificRest1 = -99;
      modifyTimeSpecificRestTIME1 = 0;
    }
    if (modifyTimeSpecificRest2 != -99) //reloj 3
    {

      int value = modifyTimeSpecificRestTIME2;
      subtractDurationFromTimer(animationController3!, Duration(seconds: value));
      modifyTimeSpecificRest2 = -99;
      modifyTimeSpecificRestTIME2 = 0;
    }

    if (modifyTimeSpecificRest3 != -99) //reloj 4
    {

      int value = modifyTimeSpecificRestTIME3;
      subtractDurationFromTimer(animationController4!, Duration(seconds: value));
      modifyTimeSpecificRest3 = -99;
      modifyTimeSpecificRestTIME3 = 0;
    }
  }

// (clientScheduCont.animationController1!,Duration(minutes: durationService));
  void subtractDurationFromTimer(AnimationController controller, Duration subtractionDuration) {
    print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO ***');
    // Verificar si el controlador está detenido o activo
    int currentTime;
    if (controller.isAnimating) {
      // Obtener el tiempo restante en segundos del AnimationController si está activo
      currentTime = (controller.duration!.inSeconds).round();
    } else {
      // Si está detenido, establecer el tiempo actual a la duración total del controlador
      currentTime = controller.duration!.inSeconds;
    }
    print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO:ESTE ES EL TIEMPO QUE TENIA:$currentTime');
    // Convertir subtractionDuration a segundos
    int subtractionTime = subtractionDuration.inSeconds;
    print('tiempo : subtractionTime:$subtractionTime');

    // Calcular el nuevo tiempo total en segundos
    int newTotalTime = currentTime - subtractionTime;

    // Asegurarse de que el nuevo tiempo no sea negativo
    if (newTotalTime <= 0) {
      newTotalTime = 0;
    }
    print('tiempo : newTotalTime:$newTotalTime');

    // Asignar la nueva duración al AnimationController
    controller.duration = Duration(seconds: newTotalTime);
    print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO newTotalTime:$newTotalTime');
    // Reiniciar y avanzar el AnimationController con la nueva duración
    controller
      ..reset()
      ..forward();
    print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA dede subtractDurationFromTimer');
    loginController.getUpdateTime(newTotalTime, 1, 'build-homePage-1');
  }

  Future<void> watchModifyTimeRest(reservationId, descripcion, placeCall, option) async {
    print('modificar time de mm  watchModifyTimeRest-llamanado desde:$placeCall');
    if (option == 'rechazada') {}
    if (option == 'aceptada') {
      int timeRest = obtenerDuracionServicio(descripcion);
      if (clientsAttended1 != null) {
        if (reservationId == clientsAttended1!.reservation_id) {
          controllerLogin.setCallDeleteService1(false);
          print('modificar time de mm 1');

          modifyTimeSpecificRest = 0;
          modifyTimeSpecificRestTIME += timeRest;
          print('modificar time de mm modifyTimeSpecificRestTIME = $modifyTimeSpecificRestTIME');
          print('modificar time de mm timeRest = $timeRest');

          // ACTUALIZAR EL RELOJ
          animationController1!
            ..duration = Duration(seconds: timeRest)
            ..reset()
            ..forward();
          await Future.delayed(const Duration(milliseconds: 500));
          await setTimeClock(reservationId, timeRest, 1, 1, true, controllerLogin.tokenUserLoggedIn);
          //Y PONER LA VARIABLE A TRUE
          controllerLogin.setCallDeleteService1(true); //autorizado a guardar cada 10 segundo el valor del relosj
        }
      }
      if (clientsAttended2 != null) {
        //si es 2 es que ya termino de atender al cliente2
        if (reservationId == clientsAttended2!.reservation_id) {
          controllerLogin.setCallDeleteService2(false);
          print('modificar time de mm 2');
          modifyTimeSpecificRest1 = 1;
          modifyTimeSpecificRestTIME1 += timeRest;
          print('modificar time de mm modifyTimeSpecificRestTIME = $modifyTimeSpecificRestTIME');
          print('modificar time de mm timeRest = $timeRest');

          // ACTUALIZAR EL RELOJ
          animationController2!
            ..duration = Duration(seconds: timeRest)
            ..reset()
            ..forward();
          //Y PONER LA VARIABLE A TRUE
          await Future.delayed(const Duration(milliseconds: 500));
          await setTimeClock(
              //reservationId, timeClock, detached, clock, actVarTelef, token)
              reservationId,
              timeRest,
              1, //detached
              2, //clock
              true,
              controllerLogin.tokenUserLoggedIn);
          controllerLogin.setCallDeleteService2(true); //autorizado a guardar cada 10 segundo el valor del relosj
        }
      }
      if (clientsAttended3 != null) {
        //si es 2 es que ya termino de atender al cliente3
        if (reservationId == clientsAttended3!.reservation_id) {
          controllerLogin.setCallDeleteService3(false);
          print('modificar time de mm 3');
          modifyTimeSpecificRest2 = 2;
          modifyTimeSpecificRestTIME2 += timeRest;
          print('modificar time de mm modifyTimeSpecificRestTIME = $modifyTimeSpecificRestTIME');
          print('modificar time de mm timeRest = $timeRest');

          // ACTUALIZAR EL RELOJ
          animationController3!
            ..duration = Duration(seconds: timeRest)
            ..reset()
            ..forward();
          //Y PONER LA VARIABLE A TRUE
          await Future.delayed(const Duration(milliseconds: 500));
          await setTimeClock(
              //reservationId, timeClock, detached, clock, actVarTelef, token)
              reservationId,
              timeRest,
              1, //detached
              3, //clock
              true,
              controllerLogin.tokenUserLoggedIn);
          controllerLogin.setCallDeleteService3(true); //autorizado a guardar cada 10 segundo el valor del relosj
        }
      }
      if (clientsAttended4 != null) {
        //si es 2 es que ya termino de atender al cliente4
        if (reservationId == clientsAttended4!.reservation_id) {
          controllerLogin.setCallDeleteService4(false);
          print('modificar time de mm 4');
          modifyTimeSpecificRest3 = 3;
          modifyTimeSpecificRestTIME3 += timeRest;
          print('modificar time de mm modifyTimeSpecificRestTIME = $modifyTimeSpecificRestTIME');
          print('modificar time de mm timeRest = $timeRest');

          // ACTUALIZAR EL RELOJ
          animationController4!
            ..duration = Duration(seconds: timeRest)
            ..reset()
            ..forward();
          //Y PONER LA VARIABLE A TRUE
          await Future.delayed(const Duration(milliseconds: 500));
          await setTimeClock(
              //reservationId, timeClock, detached, clock, actVarTelef, token)
              reservationId,
              timeRest,
              1, //detached
              4, //clock
              true,
              controllerLogin.tokenUserLoggedIn);
          controllerLogin.setCallDeleteService4(true); //autorizado a guardar cada 10 segundo el valor del relosj
        }
      }
    }


  }

  clearModifyTimeSpecificRest() {
    modifyTimeSpecificRest = -99;
    modifyTimeSpecificRest1 = -99;
    modifyTimeSpecificRest2 = -99;
    modifyTimeSpecificRest3 = -99;
    //
    modifyTimeSpecificRestTIME = 0;
    modifyTimeSpecificRestTIME1 = 0;
    modifyTimeSpecificRestTIME2 = 0;
    modifyTimeSpecificRestTIME3 = 0;
    update();
  }

  Future<void> watchModifyTime(reservationId) async {
    if (clientsAttended1 != null) {
      if (reservationId == clientsAttended1!.reservation_id) {
        print('modificar time de 1');
        modifyTimeSpecific = 0;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended2 != null) {
      //si es 2 es que ya termino de atender al cliente2
      if (reservationId == clientsAttended2!.reservation_id) {
        print('modificar time de 2');
        modifyTimeSpecific = 1;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended3 != null) {
      //si es 2 es que ya termino de atender al cliente3
      if (reservationId == clientsAttended3!.reservation_id) {
        print('modificar time de 3');
        modifyTimeSpecific = 2;
        modifyTime.addAll([-1]);
      }
    }
    if (clientsAttended4 != null) {
      //si es 2 es que ya termino de atender al cliente4
      if (reservationId == clientsAttended4!.reservation_id) {
        print('modificar time de 4');
        modifyTimeSpecific = 3;
        modifyTime.addAll([-1]);
      }
    }
    update();
  }

  void modifingTimeRest(String descripcion) {
    int timeRest = obtenerDuracionServicio(descripcion);
    print('tiempo a restar es :$timeRest');

    modifyTimeRest[modifyTimeSpecificRest] = timeRest;

    //verificar que en algun timer hay cambio de tiempo
    activeModifyTimeRest = true;
    print(' toma valor -void modifingTime(time)- activeModifyTime:$activeModifyTime');
    update();
  }


  int obtenerDuracionServicio(String cadena) {
    // Definimos la expresión regular para encontrar el número de segundos después de "tiempo de "
    RegExp regExp = RegExp(r'tiempo de (\d+) seg');

    // Buscamos la primera coincidencia de la expresión regular en el texto
    Match? match = regExp.firstMatch(cadena);

    // Verificamos si se encontró una coincidencia
    if (match != null) {
      // Obtenemos el grupo capturado que contiene el número de segundos
      String duracionTexto = match.group(1)!;
      print('modificar time de mm 1 en el forEach-match != null:$duracionTexto');
      // Convertimos el texto a un entero y lo devolvemos
      return int.parse(duracionTexto);
    }

    // Si no se encuentra ningún número en la cadena, devolvemos 0 o algún otro valor predeterminado según sea necesario
    return 0;
  }

  void modifingTime(time) {
    print(
        'tiempo a sumar =  1-*-*-*-------------------inicio------------modifyTimeSpecific-------------${modifyTimeSpecific}');
    print(
        'tiempo a sumar =  1-*-*-*-------------------inicio-----------modifyTime[modifyTimeSpecific]--------------${modifyTime[modifyTimeSpecific]}');
    modifyTime[modifyTimeSpecific] = time;


    //al darle true manda a que verifique que en algun timer hay cambio de tiempo
    activeModifyTime = true;
    print(' toma valor -void modifingTime(time)- activeModifyTime:$activeModifyTime');
    update();
  }

  bool modifingTimeClose() {
    modifyTime.addAll([-1]);
    activeModifyTime = false;
    update();
    return true;
  }

  void setActiveModifyTime(bool value) {
    activeModifyTime = value;
    print(' toma valor -void setActiveModifyTime(bool value)- activeModifyTime:$activeModifyTime');
    update();
  }

  void setActiveModifyTimeRest(bool value) {
    activeModifyTimeRest = value;
    print(' toma valor -void setActiveModifyTime(bool value)- activeModifyTime:$activeModifyTime');
    update();
  }

  Future<bool> setActiveModifyTimeRestVer() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simula una operación asíncrona
    return activeModifyTime;
  }

  Future getProfessionalState(idBranch, token) async {


    professionalDispon = await repository.getProfessionalState(idBranch, token);
    professionalDisponLength = professionalDispon.length;

    update();
  }

  Future<List<ProfessionalModel>> getFirstProfessional(idBranch, idReserv, idBarberAct, token) async {
    print('getProfessionalState(idBranch) async 11');

    List<ProfessionalModel> profDisp = [];

    profDisp = await repository.getProfessionalState2First(idBranch, idReserv, idBarberAct, token);

    return profDisp;
  }

  Future getProfessionalState2Coord(idBranch, idReserv, token) async {

    professionalDispon = await repository.getProfessionalState2Coord(idBranch, idReserv, token);
    professionalDisponLength = professionalDispon.length;
    update();
  }

  Future getProfessionalState2(idBranch, idReserv, token) async {
    professionalDispon = await repository.getProfessionalState2(idBranch, idReserv, token);
    professionalDisponLength = professionalDispon.length;
    update();
  }

  Future<void> acceptClientTechnical(reservationId, attended, token) async {

    quantityClientAttendedTechnical = 1;
    boolFilterShowNextTecnhical = false;
    update();
    bool value = await repository.acceptOrRejectClient(reservationId, attended, token);
    //si lo que devuelve es true actualizo la cola
    if (value == true) {
      quantityClientAttendedTechnical = 1;
      int? idBranch = controllerLogin.branchIdLoggedIn;
      fetchClientsTechnical(idBranch);
    }
  }

  Future<void> deleteReservationClient(reservationId, cause) async {
    try {
      bool value = await repository.deleteReservationClient(reservationId, cause, controllerLogin.tokenUserLoggedIn);
      //si lo que devuelve es true actualizo la cola
      if (value == true) {
        print('Cliente eliminado correctamente de la cola deleteReservationClient value = :$value');
      } else {
        print('Cliente NO fue eliminado de la cola deleteReservationClient value = :$value');
      }
    } catch (e) {
      print('deleteReservationClient value e:$e');
    }
  }

  Future<bool> deleteReservationClientCoor(reservationId, cause) async {
    bool value = false;
    try {
      value = await repository.deleteReservationClient(reservationId, cause, controllerLogin.tokenUserLoggedIn);
      //si lo que devuelve es true actualizo la cola
      return value;
    } catch (e) {
      print('deleteReservationClient value e:$e');
      return value;
    }
  }

  Future<int> storeByReservationId(imag, reservationId, commentText, dioClient) async {
    try {
      bool value = await repository.storeByReservationId(
          imag, reservationId, commentText, dioClient, controllerLogin.tokenUserLoggedIn);
      print('si es - $value - ha o no enviado el comentario');

      //verificar que reloj es el que hay que QUITAR
      if (value == true) //td esta bien
      {
        //si es 2 es que ya termino de atender al cliente1
        if (clientsAttended1 != null) {
          if (reservationId == clientsAttended1!.reservation_id) {
            //ELIMINA DE LA LISTA A clientsAttended1
            clientsAttended1 = null;

            // SE ELIMINA DE LA LISTA AL CLIENTE clientsAttended1
            if (item.contains(0)) {
              item.remove(0);
            }
            pausResumeClock[0] = -99;
            //await sentValueClockDb(reservationId, 0);
            await setTimeClock(
                reservationId,
                0,
                0,
                1,
                false,
                controllerLogin
                    .tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min //el ultimo campo es el reloj
          }
        }
        if (clientsAttended2 != null) {
          //si es 2 es que ya termino de atender al cliente2
          if (reservationId == clientsAttended2!.reservation_id) {
            //ELIMINA DE LA LISTA A clientsAttended2
            clientsAttended2 = null;
            pauseResumeClock(1, 0);
            // ELIMINO DE LA LISTA AL CLIENTE clientsAttended2
            if (item.contains(1)) {
              item.remove(1);
            }
            pausResumeClock[1] = -99;
            // await sentValueClockDb(reservationId, 0);
            await setTimeClock(
                reservationId,
                0,
                0,
                2,
                false,
                controllerLogin
                    .tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min //el ultimo campo es el reloj
          }
        }
        if (clientsAttended3 != null) {
          //si es 2 es que ya termino de atender al cliente3
          if (reservationId == clientsAttended3!.reservation_id) {
            //ELIMINO DE LA LISTA A clientsAttended3
            clientsAttended3 = null;
            pauseResumeClock(2, 0);
            //ELIMINO DE LA LISTA AL CLIENTE clientsAttended3
            if (item.contains(2)) {
              item.remove(2);
            }
            pausResumeClock[2] = -99;
            // await sentValueClockDb(reservationId, 0);
            await setTimeClock(
                reservationId,
                0,
                0,
                3,
                false,
                controllerLogin
                    .tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min //el ultimo campo es el reloj
          }
        }
        if (clientsAttended4 != null) {
          //si es 2 es que ya termino de atender al cliente4
          if (reservationId == clientsAttended4!.reservation_id) {

            clientsAttended4 = null;
            pauseResumeClock(3, 0);

            if (item.contains(3)) {
              item.remove(3);
            }
            pausResumeClock[3] = -99;
            //await sentValueClockDb(reservationId, 0);
            await setTimeClock(
                reservationId,
                0,
                0,
                4,
                false,
                controllerLogin
                    .tokenUserLoggedIn); //ese true es que esta mandando actualizar la variable 3min //el ultimo campo es el reloj
          }
        }
        update();
        // INSERTA EN DB SI EXISTEN RELOJES ACTIVOS
        await upadateVariablesValueTimers();
        filterShowCardTimer();
        filterShowNext();
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        return 1;
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        //no finalizó correctamente al cliente
        controllerLogin.showConnectionError();
        return 0;
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print(e);
      return 0;
    }
  }

  void clockChanges(bool value) {
    clockchanges = value;
    update();
  }

  void pauseResumeClock(int clock, int value) {
    //si clock es 0 es que va hacer algo en el reloj 1
    // value = 0 es pausar y value = 1 es reaunudar
    pausResumeClock[clock] = value;
    clockchanges = true;
    update();
  }

  Future<int> acceptClientClock(clientSig, timeClock, clock, detached, reservationId, attended, token) async {

    try {
      int value = await repository.acceptClientClock(timeClock, clock, detached, reservationId, attended, token);
      //si lo que devuelve es true actualizo la cola
      if (value == 1) {
        print('mensaje al querer hacer esta accion:mando bien-value:$value');
        int? idBranch = controllerLogin.branchIdLoggedIn;
        int? idProfessional = controllerLogin.idProfessionalLoggedIn;
        //aqui actualizo la cola

        try {
          // Llama al próximo cliente a atender y actualiza la cola
          await fetchClientsScheduled(idProfessional, idBranch, 'acceptOrRejectClient');
        } catch (e) {
          // Maneja el error de forma específica
          print('Error al actualizar la cola: $e');
        }

        filterShowCardTimer();
        Future.delayed(Duration(milliseconds: 500));
        try {
          filterShowNext();
        } catch (e) {
          print('Error en filterShowNext: $e');
        }

        if (clientSig is ClientsScheduledModel) {
          //verificando que realmente se del tipo ClientsScheduledModel
          newClientAttended(clientSig, clock);
        }


        clientsWaiting(false); //este es para saber si hay algun cliente esperando para mandar la notificación

        // SE DETIENE el timer de 3 minutos
        LocalStorage.prefs.setInt('valueClockIni', 180);
        setTotalTimeInitial(180);
        LocalStorage.prefs.setBool('valueClockActiv', false);

        animationControllerInitial!
          ..duration = const Duration(seconds: 180)
          ..reset()
          ..stop();



        update();

        //AQUI INSERTO EN LA DB SI HUBIERAS RELOJES ACTIVOS
        // este lo quite ahora en este nuevo cambio porque ya ENVIO a insertar el tiempo
        // await upadateVariablesValueTimers();
        //AQUI ACTUALIZO LA VARIABLE QUE ME DICE QUE YA llama A UN CLIENTE
        callCliente = true;
        return 1;
      } else if (value == -99) {

        print(' error al mandar a aceptar o rechazar al cliente.Status = null');
        return -99;
      } else {
        print(' error al mandar a aceptar o rechazar al cliente');
        return 0;
      }
    } catch (e) {
      print(e);
      return -99;
    } finally {
      setBoolControlVision(true);
    }
  }

  Future<int> acceptOrRejectClient(reservationId, attended, token) async {

    try {
      int value = await repository.acceptOrRejectClient(reservationId, attended, token);
      //si lo que devuelve es true actualizo la cola
      if (value == 1) {
        print('mensaje al querer hacer esta accion:mando bien-value:$value');
        int? idBranch = controllerLogin.branchIdLoggedIn;
        int? idProfessional = controllerLogin.idProfessionalLoggedIn;
        //aqui actualizo la cola
        if (attended == 1) //llama al proximo cliente atender.actualizo la cola
        {
          await fetchClientsScheduled(idProfessional, idBranch, 'acceptOrRejectClient');
        }

        //SI ES ATEENDED = 4 ES PORQUE VA A MANDARLO AL TECNICO
        //AQUI MANDAR A LLAMAR A LA FUNCION set_clock(TIMER), DEPENDIENDO DEL TIMER QUE SEA
        //ESTO LO MODIFICA EN LA BD PARA QUE EL TECNICO TENGA ACCESO A EL
        if (attended == 4) {
          //ES PORQUE ES EL RELOJ 1
          if (clientsAttended1 != null && reservationId == clientsAttended1!.reservation_id) {
            //Pausar reloj 1
            pauseResumeClock(0, 0);
            bool clock = await sentValueClockDb(reservationId, 1);
            print('EL RELOJ MANDO COMO RESPUESTA : $clock');
            print('..............1');
          }
          //ES PORQUE ES EL RELOJ 2
          if (clientsAttended2 != null && reservationId == clientsAttended2!.reservation_id) {
            //Pausar reloj 2
            pauseResumeClock(1, 0);
            print('..............2');
            bool clock = await sentValueClockDb(reservationId, 2);
            print('EL RELOJ MANDO COMO RESPUESTA : $clock');
          }
          //ES PORQUE ES EL RELOJ 3
          if (clientsAttended3 != null && reservationId == clientsAttended3!.reservation_id) {
            //Pausar reloj 3
            pauseResumeClock(2, 0);
            print('..............3');
            bool clock = await sentValueClockDb(reservationId, 3);
            print('EL RELOJ MANDO COMO RESPUESTA : $clock');
          }
          //ES PORQUE ES EL RELOJ 4
          if (clientsAttended4 != null && reservationId == clientsAttended4!.reservation_id) {
            //Pausar reloj 4
            pauseResumeClock(3, 0);
            print('..............4');
            bool clock = await sentValueClockDb(reservationId, 4);
            print('EL RELOJ MANDO COMO RESPUESTA : $clock');
          }
        }
        update();
        //AQUI INSERTO EN LA DB SI EXISTEN RELOJES ACTIVOS
        await upadateVariablesValueTimers();
        filterShowCardTimer();
        filterShowNext();

        //AQUI ACTUALIZO LA VARIABLE QUE ME DICE QUE YA llama A UN CLIENTE
        if (attended == 1) {
          callCliente = true;
        }
        return 1;
      } else if (value == -99) {
        controllerLogin.showConnectionError();
        print(' error al mandar a aceptar o rechazar al cliente.Status = null');
        return -99;
      } else {
        print(' error al mandar a aceptar o rechazar al cliente');
        return 0;
      }
    } catch (e) {
      print(e);
      return -99;
    } finally {
      setBoolControlVision(true);
    }
  }

  Future<void> filterShowNext() async {

    bool contVision = true;
    print(' filterShowNext');
    try {

      int? idBranch = controllerLogin.branchIdLoggedIn;
      int? idProfessional = controllerLogin.idProfessionalLoggedIn;
      String? token = controllerLogin.tokenUserLoggedIn;
      print('mostrando idProfessiona:$idProfessional y IdBranch:$idBranch');

      var result = await repository.typeOfService(idProfessional, idBranch, token);

      if (result is bool) {
        boolFilterShowNextAux = boolFilterShowNext; //guardo aqui para saber si dierra error q valor tenia
        boolFilterShowNext = result;
      }


    } catch (e) {
      contVision = false;
      print(
          'Erra lista de notificor al obtener laciones: noUpdate-*********************$e'); //Error al obtener la lista de notificaciones:este
    } finally {

      update();
    }
  }

  Future<void> setTimeClock(reservationId, timeClock, detached, clock, actVarTelef, token) async {
    print('llamada timer setTimeClock');
    try {
      bool result = await repository.setTimeClock(reservationId, timeClock, detached, clock, token);
      if (result) {
        // este es el importante cuando agrega servicios y elimina
        //cuando falta 3 minu para acabar
        // (reservationId, 0, 0, 4)
        if (timeClock == 0 && detached == 0) {
          if (clock == 1) {
            // Para eliminar una clave específica del almacenamiento y establecerla como null
            LocalStorage.prefs.remove('varSistemHr3min1');
          }
          if (clock == 2) {
            // Para eliminar una clave específica del almacenamiento y establecerla como null
            LocalStorage.prefs.remove('varSistemHr3min2');
          }
          if (clock == 3) {
            // Para eliminar una clave específica del almacenamiento y establecerla como null
            LocalStorage.prefs.remove('varSistemHr3min3');
          }
          if (clock == 4) {
            // Para eliminar una clave específica del almacenamiento y establecerla como null
            LocalStorage.prefs.remove('varSistemHr3min4');
          }
        }

        print('EL TIEMPO ACTUAL DEL RELOJ ************** true $reservationId - $timeClock - $detached - $clock');
        print('llamada timer setTimeClock (ESTA OK)');
      }
    } catch (e) {
      print('EL TIEMPO ACTUAL DEL RELOJ set_timeClock:$e');
    }
  }

  Future<void> returnClientStatus(int reservationId, token) async {
    try {
      idClientTemporary = reservationId;
      int result = await repository.returnClientStatus(reservationId, token);
      statusClientTemporary = result;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> returnClientName(String name) async {
    try {
      nameClientTemporary = name;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> returnImageName(String url) async {
    try {
      urlImageTemporary = url;
      print('cambiando image:$url');
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchForCustomerServices(idCar, token) async {
    serviceCustomerAux = await repository.getCustomerServicesList(idCar, token);
    print('showingServiceClients:$showingServiceClients');
    if (showingServiceClients == false) {
      serviceCustomerSelected = serviceCustomerAux;
      serviceCustomerSelectedForm = serviceCustomerSelected;
    }
    update();
  }

  Future<void> searchForCustomerServices2(idCar, token) async {
    Map<dynamic, dynamic> resultList = await repository.getCustomerServicesList2(idCar, token);

    serviceCustomerSelected = resultList['serviceCustomer'];

    print('showingServiceClients:$showingServiceClients');
    if (showingServiceClients == false) {
      serviceCustomerSelectedForm = serviceCustomerSelected;

      professionalNameBarber = resultList['professionalNameBarber'];
      imageUrlBarber = resultList['imageUrlBarber'];
      imageLookBarber = resultList['imageLookBarber'];
      cantVisitBarber = resultList['cantVisitBarber'];
      endLookBarber = resultList['endLookBarber'];
      frecuenciaBarber = resultList['frecuenciaBarber'];


    }

    update();
  }

  Future<void> searchForCustomerServices3(idCar, token) async {
    try {
      Map<dynamic, dynamic> resultList = await repository.getCustomerServicesList2(idCar, token);

      if (resultList.containsKey("error")) {
        var errorValue = resultList["error"];

        if (errorValue == 'error') {
          // Manejo específico para cuando "error" tiene el valor 'error'
          print('Ocurrió un error: $errorValue');
        } else {
          // Manejo para otros posibles valores de "error"
          print('Error recibido: $errorValue');
        }
      } else {
        serviceCustomerSelected1 = resultList['serviceCustomer'];

        serviceCustomerSelectedForm1 = serviceCustomerSelected1;

        professionalNameBarber1 = resultList['professionalNameBarber'];
        imageUrlBarber1 = resultList['imageUrlBarber'];
        imageLookBarber1 = resultList['imageLookBarber'];
        cantVisitBarber1 = resultList['cantVisitBarber'];
        endLookBarber1 = resultList['endLookBarber'];
        frecuenciaBarber1 = resultList['frecuenciaBarber'];

        update();
        // Manejo del caso en que no haya error y se reciban datos válidos
        print('Datos recibidos: $resultList');
      }
    } catch (e) {
      print(e);
    } finally {
      Get.back();
    }
  }

  Future<Map<dynamic, dynamic>?> searchForCustomerServices4(idCar, token) async {
    try {
      Map<dynamic, dynamic> resultList = await repository.getCustomerServicesList2(idCar, token);

      if (resultList.containsKey("error")) {
        var errorValue = resultList["error"];

        if (errorValue == 'error') {
          // Manejo específico para cuando "error" tiene el valor 'error'
          print('Ocurrió un error: $errorValue');
        } else {
          // Manejo para otros posibles valores de "error"
          print('Error recibido: $errorValue');
        }
      } else {

        return resultList;

      }
    } catch (e) {
      print(e);
    } finally {
      Get.back();
    }
  }

  Future<bool> changeNoncomplianceP(

      type,
      branchId,
      professionalId,
      estado) async {
    // LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    print('Segundo Plano - changeNoncomplianceP');

    bool result =
        await repository.storeByType(type, branchId, professionalId, estado, controllerLogin.tokenUserLoggedIn);
    if (result) {
      print('CORRECTO actualizo el estado correctamente');
      //AQUI ES PÓRQUE INCUMPLIO
      if (estado == 1) {
        noncomplianceProfessional[type] = 1;
        update();
      } else {
        noncomplianceProfessional[type] = 0;
        update();
      }
    }
    return result;
  }

  Future<bool> changeNoncompliancePId(

      id,
      type,
      branchId,
      professionalId,
      estado) async {
    // LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO

    print('Segundo Plano - changeNoncompliancePId');
    bool result =
        await repository.storeByTypeId(id, type, branchId, professionalId, estado, controllerLogin.tokenUserLoggedIn);
    if (result) {
      print('CORRECTO actualizo el estado correctamente');
      //AQUI ES PÓRQUE INCUMPLIO CON ALGO
      if (estado == 1) {
        noncomplianceProfessional[id.toString()] = 1;
        update();
      } else {
        noncomplianceProfessional[id.toString()] = 0;
        update();
      }
    }
    return result;
  }

  Future<bool> changeNoncomplianceP2(

      type,
      branchId,
      professionalId,
      estado) async {

    print('Segundo Plano - changeNoncomplianceP2');
    print('llamda a la api desde segundo plano-ENTRANDO');
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result =
        await repository.storeByType2(type, branchId, professionalId, estado, controllerLogin.tokenUserLoggedIn);

    return result;
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;

      update();
    });
  }

  getList() {
    return clientsScheduledList;
  }

  Future<void> metodsClients(index, idCar, reservationId, clientName, imageName) async {
    (selectClientsScheduledList.contains(clientsScheduledList[index]))
        ? selectClientsScheduledList.remove(clientsScheduledList[index])
        : selectClientsScheduledList.add(clientsScheduledList[index]);
    final ShoppingCartController shoppingCartController = Get.find<ShoppingCartController>();
    shoppingCartController.carIdClienteSelect = idCar;

    nameClientTemporary = clientName;

    urlImageTemporary = imageName;
    idClientTemporary = reservationId;

    await watchModifyTime(reservationId);
    update();
  }

  Future<void> getselectCustomer(index, idCar) async {
    print('IdCar:$idCar');
    // await searchForCustomerServices(idCar);
    (selectClientsScheduledList.contains(clientsScheduledList[index]))
        ? selectClientsScheduledList.remove(clientsScheduledList[index])
        : selectClientsScheduledList.add(clientsScheduledList[index]);

    update();
  }

  Future<void> showingServiceClient(bool value) async {
    print('No actualizar la cola, tengo desplegado los servicios ahora mandando:$value');
    showingServiceClients = value;
    update();
  }

  showingServiceClientTechnical(bool value) {
    print('No actualizar la cola, tengo desplegado los servicios al  TECNICO-> ahora mandando:$value');
    showingServiceClientsTechnical = value;
    update();
  }

  cleanselectCustomer() {
    selectClientsScheduledList.clear();
    update();
  }

  cleanselectCustomerTechnical() {
    selectclientsScheduledListTechnical.clear();
    update();
  }



  Future<void> fetchClientsScheduledNew(idProfessional, idBranch, msj, token) async {
    bool noUpdate = false;
    print('entrando a actualizar la cola en - fetchClientsScheduledNew');
    try {
      List<ClientsScheduledModel> clientsAux = [];

      String s = '';

      Map<String, dynamic> resultList =
          await repository.getClientsScheduledListNew(idProfessional, idBranch, controllerLogin.isLoggingIn, token);


      //verificando , si entra al if es problemas de conexion
      if (resultList.containsKey('ConnectionIssues') && resultList['ConnectionIssues'] == true) {
        correctConnection = false;
        print('llamando a buscar clientes - ERROR2');

      } else {
        correctConnection = true;
        //guardando la cola del dia de hoy del profesional
        List<ClientsScheduledModel>? clientsScheduledListAUX = [];
        List<ClientsScheduledModel>? clientsScheduledListAUX2 = [];

        clientsScheduledListAUX = (resultList['clientList'] ?? [])
            .cast<ClientsScheduledModel>(); // guardando la cola del dia de hoy del profesional
        clientsScheduledListAUX2 = (resultList['clientListSig'] ?? []).cast<ClientsScheduledModel>();
        if (clientsScheduledListAUX != null && clientsScheduledListAUX2 != null) {
          clientsScheduledList = clientsScheduledListAUX;

          clientsScheduledListLength = clientsScheduledList.length;
          print('llamada timer Cantidad de Clientes-1 :$clientsScheduledListLength');
          clientsAux = clientsScheduledListAUX2;
          clientsScheduledListLengthTail = clientsAux.length;
          print('llamando a buscar clientes - BIEN4-clientsScheduledList.length:${clientsScheduledList.length}');
          print(
              ' SI  ->BIEN-${clientsScheduledList.length}--entro de:$msj-idProfessional=$idProfessional--idBranche:$idBranch Objeto-${clientsScheduledList}');


          //aqui guarda al proximo de la cola para mostrarlo en el Home de la apk
          clientsScheduledNext = resultList['nextClient'];
          clientsScheduledNextServ = resultList['nextClient'];

          clientsScheduledNextServ = ClientsScheduledModel.fromMap(
            resultList['nextClient']
          );
          if (resultList.containsKey('clientListSalon')) {
            setClientsScheSalon(resultList['clientListSalon']);
          }

          //si hay un siguiente mandar verificarle si es aleatorio o
          quantityClientAttended = resultList['quantityClientAttended'];
          varClientsWaiting = resultList['varclientswaiting'];
          if (quantityClientAttended == 0) {
            clientsAttended = 'nobody';
          }

          print('activando el Clock - 1 lenght - clientsScheduledList:${clientsScheduledList.length}');
          for (var i = 0; i < clientsScheduledList.length; i++) {
            // int clock = 0;
            if (clientsScheduledList[i].attended == 11) {
              int reservationId = clientsScheduledList[i].reservation_id!;

              int clock = clientsScheduledList[i].clock!;
              print('EL RELOJ DEVUELTO ES : de fetchClientsScheduledNew:$clock');
              //REVISAR SI VIENE EL RELOJ
              // int clock = await getValueClockDb(reservationId);
              if (clock == 1) {
                print('activando el Clock - 1');

                await acceptOrRejectClient(reservationId, 111, loginController.tokenUserLoggedIn);
                animationController1!.forward();
                pauseResumeClock((clock - 1), -99);
              }
              if (clock == 2) {
                print('activando el Clock - 2');

                await acceptOrRejectClient(reservationId, 111, loginController.tokenUserLoggedIn);
                animationController2!.forward();
                pauseResumeClock((clock - 1), -99);
              }
              if (clock == 3) {
                print('activando el Clock - 3');

                await acceptOrRejectClient(reservationId, 111, loginController.tokenUserLoggedIn);
                animationController3!.forward();
                pauseResumeClock((clock - 1), -99);
              }
              if (clock == 4) {
                print('activando el Clock - 4');

                await acceptOrRejectClient(reservationId, 111, loginController.tokenUserLoggedIn);
                animationController4!.forward();
                pauseResumeClock((clock - 1), -99);
              }
            } //fin del if
          }
          //**************************************************************** */
          //**************************************************************** */
        }
      }
    } catch (e) {
      noUpdate = true;
      print('Error en Future<void> fetchClientsScheduled que se encuentra en el controlador del Login:$e');
    } finally {
      if (msj == 'Home-reasignedClient' || msj == 'Agenda-Card' || msj == 'navigation down') {
        Get.back();
      }
      print('Obtener la lista de notificaciones: noUpdate == click $noUpdate');
      if (noUpdate == false) {
        // setBoolControlVision(true);
        update();
      }
      controllerLogin.setIsLoadingFor(false);
    }
  }

  Future<void> fetchClientsScheduled(idProfessional, idBranch, msj) async {
    print('entrando para mandar notificacion desde:$msj');
    try {
      List<ClientsScheduledModel> clientsAux = [];

      Map<String, dynamic> resultList = await repository.getClientsScheduledList(
          idProfessional, idBranch, controllerLogin.isLoggingIn, controllerLogin.tokenUserLoggedIn);
      print(resultList);
      //verificando , si entra al if es problemas de coneccion
      if (resultList.containsKey('ConnectionIssues') && resultList['ConnectionIssues'] == true) {
        correctConnection = false;
        print('llamando a buscar clientes - ERROR2');

      } else {
        correctConnection = true;
        // guardando la cola del dia de hoy del profesional
        List<ClientsScheduledModel>? clientsScheduledListAUX = [];
        List<ClientsScheduledModel>? clientsScheduledListAUX2 = [];

        clientsScheduledListAUX = (resultList['clientList'] ?? [])
            .cast<ClientsScheduledModel>(); //guardando la cola del dia de hoy del profesional
        clientsScheduledListAUX2 = (resultList['clientListSig'] ?? []).cast<ClientsScheduledModel>();
        if (clientsScheduledListAUX != null && clientsScheduledListAUX2 != null) {
          clientsScheduledList = clientsScheduledListAUX;

          clientsScheduledListLength = clientsScheduledList.length;
          print('llamada timer Cantidad de Clientes-2 :$clientsScheduledListLength');
          clientsAux = clientsScheduledListAUX2;
          clientsScheduledListLengthTail = clientsAux.length;
          print('llamando a buscar clientes - BIEN4-clientsScheduledList.length:${clientsScheduledList.length}');

          {
            if (resultList.containsKey('attendingClient')) {
              List<Map>? attendingClientList = resultList['attendingClient'];
              print('clientes asistiendo hora timeClock -valor de attendingClientList:${attendingClientList} ');
              //aqui es donde tiene que entrar solamente si se loguea
              if (controllerLogin.isLoggingIn == true) {
                print(
                    'EL TIEMPO clientes asistiendo -- if (controllerLogin.isLoggingIn == ${controllerLogin.isLoggingIn}) { entre poque vine del login ');

                logicaInesperada(attendingClientList);
                controllerLogin.setIsLoggingIn(false);
              } else {
                print(
                    'clientes asistiendo -- if (controllerLogin.isLoggingIn == ${controllerLogin.isLoggingIn})  NO ');
              }
            } else {
              // La clave 'attendingClient' no está presente en el mapa
              print('!!!!!!!!!!!!!!!!!!!!La clave "attendingClient" no está presente en el mapa.');
            }
          }

          //aqui guarda al proximo de la cola para mostrarlo en el Home de la apk
          clientsScheduledNext = resultList['nextClient'];
          clientsScheduledNextServ = resultList['nextClient'];
          quantityClientAttended = resultList['quantityClientAttended'];
          varClientsWaiting = resultList['varclientswaiting'];
          if (quantityClientAttended == 0) {
            clientsAttended = 'nobody';
          }

          if (clientsScheduledNext != null) {
            int idCar = clientsScheduledNext!.car_id!;
            await searchForCustomerServices(idCar, controllerLogin.tokenUserLoggedIn);
            await filterShowNext();

          } else {
            print('clientsScheduledNext = null');

          }
        }
      }
      update();
      controllerLogin.setIsLoadingFor(false);
    } catch (e) {
      print('Error en Future<void> fetchClientsScheduled que se encuentra en el controlador del Login:$e');
    }
  }

  Future<void> logicaInesperadaQuitarTiempo(List<Map>? attendingClientList) async {
    try {
      if (attendingClientList != null && attendingClientList.isNotEmpty) {
        for (var map in attendingClientList) {
          int? clock;
          int? timeClock;
          int? detached;

          map.forEach((key, value) {

            switch (key) {
              case "detached":
                detached = value;
                break;
              case "clock":
                clock = value;
                break;
              case "timeClock":
                timeClock = value;
                break;

              default:
                // Manejar otras claves si es necesario
                break;
            }
          });

          // Lógica adicional si es necesario con las variables asignadas
          if (clock == 1 && detached == 99) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 1
            timeClientsAttended1 = timeClock!;
            // metodo nuevo para avisar y mandar notif cuando el servico se este acabando
            int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended1!);
            //hace analisis y guarda en memoria del telefono
            //cuando falta 3 minu para acabar
            controllerLogin.getUpdateTime(timeMinutes, 1, 'logicaInesperadaQuitarTiempo-1');
            //metodo nuevo para avisar y mandar notif cuando el servico se este acabando
            print('clientes asistiendo hora timeClock***********timeClock*****:$timeClock');
          } else if (clock == 2 && detached == 99) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 2
            timeClientsAttended2 = timeClock!;
            int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended2!);
            controllerLogin.getUpdateTime(timeMinutes, 2, 'logicaInesperadaQuitarTiempo-2');

          } else if (clock == 3 && detached == 99) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 3
            timeClientsAttended3 = timeClock!;

            int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended3!);
            controllerLogin.getUpdateTime(timeMinutes, 3, 'logicaInesperadaQuitarTiempo-3');

          } else if (clock == 4 && detached == 99) {
            print('clientes asistiendo entre a :$clock');
            // Asignar a variables específicas para clock 3
            timeClientsAttended4 = timeClock!;

            int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended4!);
           controllerLogin.getUpdateTime(timeMinutes, 4, 'logicaInesperadaQuitarTiempo-4');

          }

        }
        update();

      } else {
        // La lista es nula o está vacía
        print('!!!!!!!!!!!!!!!!!!!!La lista de clientes asistiendo es nula o está vacía.');
      }
    } catch (e) {
      print('ERROR en Future<void> logicaInesperada:$e');
    }
  }

  Future<void> logicaInesperada(List<Map>? attendingClientList) async {
    try {
      if (attendingClientList != null && attendingClientList.isNotEmpty) {


        DateTime horaActual = DateTime.now();
        DateTime hora1 = DateTime.parse('2024-02-27 19:34:45');
        int diferenciaSegundos = 0;

        // Usando un bucle for-in
        for (var map in attendingClientList) {
          int? id;
          String? updated; // Definir la hora1
          int? clock;
          int? timeClock;
          ClientsScheduledModel? client;

          map.forEach((key, value) {

            // Asignar valores a las variables según la clave
            switch (key) {
              case "reservation_id":
                id = value;
                break;
              case "clock":
                clock = value;
                break;
              case "timeClock":
                timeClock = value;
                break;
              case "client":
                client = value;
                break;
              case "updated_at":
                hora1 = DateTime.parse(value);

                break;
              default:
                break;
            }
          });


          // Calcular la diferencia en segundos entre hora1 y la hora actual

          int diferenciaSegundos = horaActual.difference(hora1).inSeconds;

          print('clientes asistiendo clock:$clock');
          print('clientes asistiendo hora1:$hora1');
          print('clientes asistiendo horaActual:$horaActual');
          print('clientes asistiendo hora diferenciaSegundos:$diferenciaSegundos');
          print('clientes asistiendo hora timeClock:$timeClock'); //value del reloj actual
          print('clientes asistiendo hora timeClock:${(timeClock! - diferenciaSegundos)}');
          // Lógica adicional si es necesario con las variables asignadas
          if (clock == 1) {
            if (client!.attended == 4 || client!.attended == 5 || client!.attended == 33) {
              clientsAttended1 = client;
              timeClientsAttended1 = timeClock!;
            } else {
              print('clientes asistiendo entre a :$clock');
              // Asignar a variables específicas para clock 1
              clientsAttended1 = client;
              timeClientsAttended1 =
                  (timeClock! - diferenciaSegundos) <= 0 ? 0 : (timeClock! - diferenciaSegundos); //tiempo en segundos
              //pasar el tiempo de segundos a minutos
              int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended1!);
              //hace analisis y guarda en memoria del telefono
              //cuando falta 3 minu para acabar
              controllerLogin.getUpdateTime(timeMinutes, 1, 'logicaInesperada-1');

            }
          } else if (clock == 2) {
            if (client!.attended == 4 || client!.attended == 5 || client!.attended == 33) {
              clientsAttended2 = client;
              timeClientsAttended2 = timeClock!;
            } else {
              clientsAttended2 = client;
              timeClientsAttended2 =
                  (timeClock! - diferenciaSegundos) <= 0 ? 0 : (timeClock! - diferenciaSegundos); //tiempo en segundos
              int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended2!);
              //hace analisis y guarda en memoria del telefono
              //cuando falta 3 minu para acabar
              controllerLogin.getUpdateTime(timeMinutes, 2, 'logicaInesperada-2');

            }
          } else if (clock == 3) {
            if (client!.attended == 4 || client!.attended == 5 || client!.attended == 33) {
              clientsAttended3 = client;
              timeClientsAttended3 = timeClock!;
            } else {
              clientsAttended3 = client;
              timeClientsAttended3 =
                  (timeClock! - diferenciaSegundos) <= 0 ? 0 : (timeClock! - diferenciaSegundos); //tiempo en segundos
              int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended3!);

              //cuando falta 3 minu para acabar
              controllerLogin.getUpdateTime(timeMinutes, 3, 'logicaInesperada-3');

            }
          } else if (clock == 4) {
            if (client!.attended == 4 || client!.attended == 5 || client!.attended == 33) {
              clientsAttended3 = client;
              timeClientsAttended3 = timeClock!;
            } else {
              clientsAttended4 = client;
              timeClientsAttended4 =
                  (timeClock! - diferenciaSegundos) <= 0 ? 0 : (timeClock! - diferenciaSegundos); //tiempo en segundos
              int timeMinutes = controllerLogin.secondsToMinutes(timeClientsAttended4!);

              //cuando falta 3 minu para acabar
              controllerLogin.getUpdateTime(timeMinutes, 4, 'logicaInesperada-4');

            }
          }

        }
        //VERIFICO QUE RELOJ ESTA OCUPADO Y VEO SI HAY DISPONIBILIDAD
        filterShowCardTimer();
        update();
        //
        //verificar si fue que vino de segundo plano
      } else {
        // La lista es nula o está vacía
        print('!!!!!!!!!!!!!!!!!!!!La lista de clientes asistiendo es nula o está vacía.');
      }
    } catch (e) {
      print('ERROR en Future<void> logicaInesperada:$e');
    }
  }

  Future<void> fetchClientsTechnical(idBranch) async {
    Map<String, dynamic> resultList = await repository.getClientsTechnicalList(
        idBranch, controllerLogin.idProfessionalLoggedIn!, controllerLogin.tokenUserLoggedIn);
    print(' entra a buscar inicialmente los clientes del tecnico');
    print(resultList);
    //verificando , si entra al if es problemas de coneccion
    if (resultList.containsKey('ConnectionIssues') && resultList['ConnectionIssues'] == true) {
      correctConnection = false;
      print('mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor-6');
    } else {
      correctConnection = true;
      //aqui guardala cola del dia de hoy del profesional
      clientsScheduledListTechnical = (resultList['clientList'] ?? []).cast<ClientsScheduledModel>();
      clientsTechnicalLength = clientsScheduledListTechnical.length;
      //aqui guarda al proximo de la cola para mostrarlo en el Home de la apk

      clientsNextTechnical = resultList['nextClient'];
      quantityClientAttendedTechnical = resultList['quantityClientAttended'];
      if (quantityClientAttendedTechnical == 0) {
        clientsAttendedTechnical = clientsNextTechnical;
        boolFilterShowNextTecnhical = true;
        technicalClientsAttended = 'nobody';
      } else {
        boolFilterShowNextTecnhical = false;
      }
    }
    update();
  }

  Future<void> selectCarClient(carId) async {
    final ShoppingCartController shoppingCartController = Get.find<ShoppingCartController>();
    shoppingCartController.carIdClienteSelect = carId;
    update();
  }


// le asigna el tamaño al reloj dependiendo del tamaño del telefono
  setValueClockDinamic(double value) {
    sizeClock = value;
    update();
  }

  double calcularH(double heightNew) {
    double h2 = heightNew * 0.155;
    print('ESTE ES EL VALOR NUEVO DEL CLOCK heightAntComponet:$heightNew');
    print('ESTE ES EL VALOR NUEVO DEL CLOCK h2:$h2');
    return h2.roundToDouble();
  }


  int convertDateSecons(String tiempo) {
    try {
      // Dividir la cadena en partes usando ":" como separador
      List<String> partes = tiempo.split(":");

      // Convertir cada parte a entero
      int horas = int.parse(partes[0]);
      int minutos = int.parse(partes[1]);
      int segundos = int.parse(partes[2]);

      // Calcular el tiempo total en segundos
      int tiempoEnSegundos = horas * 3600 + minutos * 60 + segundos;

      return tiempoEnSegundos;
    } catch (e) {
      // Manejar cualquier error en la conversión
      print('Error al convertir el tiempo: $e');
      return 0; // Retornar 0 en caso de error
    }
  }


  Future<bool> sentValueClockDb(int id, int clock) async {
    //si return = false es que no se inserto en la Db
    return await repository.sentValueClockDb(id, clock, controllerLogin.tokenUserLoggedIn);
  }

  Future<int> getValueClockDb(int id) async {
    try {
      return await repository.getValueClockDb(id, controllerLogin.tokenUserLoggedIn);
    } catch (e) {
      print(e);
      return -99;
    }

  }

  Future<void> sendWhatsappNotification(
    String telefone,
  ) async {
    try {
      await repository.sendWhatsappNotificationRepos(telefone, controllerLogin.tokenUserLoggedIn);
      print('enviado el mensaje de whatsap correctamente');
    } catch (e) {
      print('ERROR enviando el mensaje de whatsap correctamente$e');
    }
  }
}
