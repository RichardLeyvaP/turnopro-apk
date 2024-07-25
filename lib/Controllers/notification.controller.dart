// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/get_connect/repository/notification.repository.dart';
import 'package:turnopro_apk/services/background_service.dart';

import 'login.controller.dart';

class NotificationController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  NotificationController() {
    // initializeNotifications();
  }
//DECLARACION DE VARIABLES
  NotificationRepository repository = NotificationRepository();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsTechnicalController clientsTechnicalCont =
      Get.find<ClientsTechnicalController>();
  final ClientsScheduledController controllerclient =
      Get.find<ClientsScheduledController>();
  int notificationListLength = 0;
  int notificationListLengthEncarg = 0;
  int notificationListNewLength = 0;
  int notificationListNewLengthEncarg = 0;
  int notificationListBack = 0;
  int notificationListBackEncarg = 0;
  List<NotificationModel> notification = []; // Lista de Notificaciones
  List<NotificationModel> notificationEncarg = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNew = []; // Lista de Notificaciones
  List<int> notificationListNewSounded = []; // Lista de Notificaciones
  List<NotificationModel> notificationListNewEncarg =
      []; // Lista de Notificaciones
  List<NotificationModel> selectNotification = [];
  bool isLoading = true;
  List<String> created_atTime = [];
  int outAcept = 0;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  getList() {
    return notification;
  }

  void updateOutAcept(int value) {
    outAcept = value;
    update();
  }

  Future<bool> storeNotification2(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification2(tittle, branchId,
        professionalId, description, type, controllerLogin.tokenUserLoggedIn);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  Future<bool> storeNotification(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotification(tittle, branchId,
        professionalId, description, type, controllerLogin.tokenUserLoggedIn);
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  Future<bool> storeNotificationSERVICE(
      //todo1
      tittle,
      branchId,
      professionalId,
      description,
      type) async {
    //AQUI LLAMAR AL REPOSITORIO PARA DAR INCUMPLIMIENTO
    bool result = await repository.storeNotificationSERVICE(
        tittle, branchId, professionalId, description, type);
    print('notificacion desde :controller-storeNotificationSERVICE ');
    if (result) {
      print('CORRECTO inserto una nueva notificacion ');
    }
    return result;
  }

  /* Future<void> reproducirSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    print('reproduciendo el sonido-1');
    int soundId = await rootBundle
        .load("assets/sound/livechat-129007.mp3")
        .then((ByteData soundData) {
      print('reproduciendo el sonido-3');
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
    print('reproduciendo el sonido-2');
  }*/

  updateNotificationListBack(int value) {
    notificationListBack = value;
    update();
  }

  updateNotificationListBackEncarg(int value) {
    notificationListBackEncarg = value;
    update();
  }

  getSelectNotification(index) {
    (selectNotification.contains(notification[index]))
        ? selectNotification.remove(notification[index])
        : selectNotification.add(notification[index]);
    update();
  }

  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
/*  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(String title, String descripcion) async {
    final Uuid uuid = Uuid(); // Crea una instancia de Uuid
    final String channelId = uuid.v4(); // Genera un channelId único
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId, // ID del canal
      'Nombre del Canal', // Nombre del Canal
      channelDescription:
          'Descripción del Canal', // Descripción del Canal (argumento nombrado)
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('livechat129007'),
      // ^ Utiliza el nombre del archivo de sonido sin la extensión
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      descripcion,
      platformChannelSpecifics,
    );
  }*/
  //todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/

  bool _retryAttempted = false; // Variable para controlar el reintento
  int obtenerNumeroDespuesDelPunto(String textoCompleto) {
    // Dividir el texto por el punto
    List<String> partes = textoCompleto.split('.');

    // Verificar si hay al menos dos partes después de dividir por el punto
    if (partes.length >= 2) {
      // Obtener la segunda parte y eliminar espacios en blanco alrededor
      String restoDelTexto = partes.sublist(1).join('.').trim();

      // Extraer el número oculto usando una expresión regular
      RegExp regExp = RegExp(r'\d+');
      Iterable<Match> matches = regExp.allMatches(restoDelTexto);

      // Iterar sobre las coincidencias y obtener la primera como el número oculto
      if (matches.isNotEmpty) {
        String numeroOcultoString = matches.first.group(0)!;

        // Convertir a entero
        try {
          return int.parse(numeroOcultoString);
        } catch (e) {
          print('Error al convertir a entero: $e');
          // Manejar el error de conversión según sea necesario
          return 0; // O retorna un valor predeterminado en caso de error
        }
      } else {
        print('No se encontró un número después del punto.');
        // Manejar el caso donde no se encuentra ningún número después del punto
        return 0; // O retorna un valor predeterminado si no se encuentra
      }
    } else {
      print('El texto no contiene suficientes partes separadas por punto.');
      // Manejar el caso donde no se puede dividir adecuadamente por punto
      return 0; // O retorna un valor predeterminado si no hay suficientes partes
    }
  }

  Future<void> professionalBranchNotifQueque(
      idBranch, idProfe, type, msj, token) async {
    print('entrando a actualizar la cola en - professionalBranchNotifQueque');
    bool noUpdate = false;
    final ClientsScheduledController clientCon =
        Get.find<ClientsScheduledController>();
    List<ClientsScheduledModel> clientsAux = [];
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');

    try {
      final resultList = await repository.professionalBranchNotifQueque(
          idBranch, idProfe, type, token);
      bool siHayEliminarService = false;
      if (resultList != null && resultList is Map<String, dynamic>) {
        if (resultList.containsKey('notificationList') &&
            resultList.containsKey('notificationListNew')) {
          notification =
              resultList['notificationList']; // busca aqui las notificaciones
          notificationListLength = notification.length;
          notificationListNew = resultList['notificationListNew'];
          notificationListNewLength = notificationListNew.length;

          if (notificationListNew.isNotEmpty) {
            List<NotificationModel> notificationListNewAux1 = [];
            notificationListNew.forEach((element) async {
              if (element.state == 0 || element.state == 3) {
                if (!notificationListNewSounded.contains(element.id)) {
                  notificationListNewSounded.add(element.id);
                  notificationListNewAux1.add(element);
                }
              }

              if (element.state == 3 &&
                  element.tittle == 'Aceptada Eliminación de Servicio') {
                print('modificar time de mm 1 estoy aqui en el forEach');
                String textoCompleto = element.description;
                int idReservation = obtenerNumeroDespuesDelPunto(textoCompleto);
                if (controllerLogin.isLoggingNotification ==
                    false) //vino del login si es true,solo debe entrar si no viene del login
                {
                  controllerclient.watchModifyTimeRest(idReservation,
                      textoCompleto, 'professionalBranchNotifQueque');
                }

                updateNotifications2(idBranch, idProfe, element.id);
              }

              if (element.state == 3 &&
                  element.tittle == 'Aceptada su solicitud de Colación') {
                updateNotifications2(idBranch, idProfe, element.id);
                controllerLogin.setCodigoQrValid(null);
              }
              if (element.state == 3 &&
                  element.tittle == 'Solicitud de Eliminación Rechazada') {
                updateNotifications2(idBranch, idProfe, element.id);
                controllerLogin.setCodigoQrValid(1);
              }
              if (element.state == 3 &&
                  element.tittle == 'Aceptada Eliminación de Cliente') {
                updateNotifications2(idBranch, idProfe, element.id);
                controllerLogin.setCodigoQrValid(1);
              }
              if (element.state == 3 &&
                  element.tittle == 'Rechazada su solicitud de Colación') {
                updateNotifications2(idBranch, idProfe, element.id);
                controllerLogin.setCodigoQrValid(1);
              }
              if (element.state == 3 &&
                  element.tittle == 'Rechazada su solicitud de Salida') {
                updateNotifications2(idBranch, idProfe, element.id);
                controllerLogin.setCodigoQrValid(1);
              }
              if (element.state == 3 &&
                  element.tittle == 'Aceptada su solicitud de Salida') {
                updateOutAcept(element.id);
              }
            });
          }

          if (outAcept != 0) {
            Get.snackbar('Mensaje', 'Cerrando aplicación.',
                duration: const Duration(milliseconds: 2500));
            Get.dialog(
                const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                )),
                barrierDismissible: false);
            await updateNotifications2(idBranch, idProfe, outAcept);
            //  await controllerLogin.exitPostworking("Barbero");
            await controllerLogin.exit(controllerLogin.tokenUserLoggedIn);
            updateOutAcept(0);
            Get.back();
          }

          clientCon.correctConnection = true;
          List<ClientsScheduledModel>? clientsScheduledListAUX = [];
          List<ClientsScheduledModel>? clientsScheSalonAux = [];
          List<ClientsScheduledModel>? clientsScheduledListAUX2 = [];

          clientCon.setClientsScheSalon(resultList['clientListSalon']);
          clientsScheduledListAUX =
              (resultList['clientList'] ?? []).cast<ClientsScheduledModel>();
          clientsScheduledListAUX2 =
              (resultList['clientListSig'] ?? []).cast<ClientsScheduledModel>();

          if (clientsScheduledListAUX != null &&
              clientsScheduledListAUX.isNotEmpty &&
              clientsScheduledListAUX2 != null &&
              clientsScheduledListAUX2.isNotEmpty) {
            clientCon.clientsScheduledList = clientsScheduledListAUX;
            clientCon.clientsScheduledList[0].select_professional;
            clientCon.clientsScheduledListLength =
                clientCon.clientsScheduledList.length;
            clientsAux = clientsScheduledListAUX2;
            clientCon.clientsScheduledListLengthTail = clientsAux.length;

            if (resultList.containsKey('attendingClient')) {
              List<Map>? attendingClientList = resultList['attendingClient'];
              if (controllerLogin.isLoggingIn == true) {
                clientCon.logicaInesperada(attendingClientList);
                controllerLogin.setIsLoggingIn(false);
              }
            }

            clientCon.clientsScheduledNext = resultList['nextClient'];
            int clientNewAux = 0;
            if (clientCon.clientsScheduledListId.isNotEmpty) {
              clientNewAux = clientCon.clientsScheduledListId.length;
            }

            clientCon.clientsScheduledList.forEach((element) async {
              if (!clientCon.clientsScheduledListId
                  .contains(element.reservation_id)) {
                clientCon.clientsScheduledListId.add(element.reservation_id!);
              }
            });

            if (clientNewAux != 0) {
              if (clientCon.clientsScheduledListId.length > clientNewAux) {
                clientCon.setclientNew(
                    clientCon.clientsScheduledListId.length - clientNewAux);
              }
            }

            if (clientCon.clientNew > 0) {
              String s = '';
              if (clientCon.clientNew > 1) {
                s = 's';
              }
              clientCon.setclientNew(0);
            }

            clientCon.quantityClientAttended =
                resultList['quantityClientAttended'];
            clientCon.varClientsWaiting = resultList['varclientswaiting'];
            if (clientCon.quantityClientAttended == 0) {
              clientCon.clientsAttended = 'nobody';
            }

            if (clientCon.clientsScheduledNext != null) {
              int idCar = clientCon.clientsScheduledNext!.car_id!;
              await clientCon.searchForCustomerServices(
                  idCar, controllerLogin.tokenUserLoggedIn);
              await clientCon.filterShowNext();
            }
          }
          controllerclient.setclientLisError(0);
        } else {
          print(
              'Error al obtener la lista de notificaciones:este:-CONTROLADO AQUI');
          controllerclient.setclientLisError(-99);
          if (!_retryAttempted && controllerclient.errorHome == -99) {
            Get.snackbar('Alerta', 'Conexión débil.',
                duration: const Duration(milliseconds: 2500));
            clientCon.correctConnection = false;
            _retryAttempted = true;
            professionalBranchNotifQueque(idBranch, idProfe, type, msj, token);
          }
        }
      } else {
        print('Error al obtener la lista de notificaciones:este:');
        controllerclient.setclientLisError(-99);
        if (!_retryAttempted && controllerclient.errorHome == -99) {
          Get.snackbar('Alerta', 'Conexión débil.',
              duration: const Duration(milliseconds: 2500));
          clientCon.correctConnection = false;
          _retryAttempted = true;
          professionalBranchNotifQueque(idBranch, idProfe, type, msj, token);
        }
      }
      controllerLogin.setLoggingNotification(false);
    } catch (e) {
      print('Error de excepción al obtener la lista de notificaciones:$e');
      controllerclient.setclientLisError(-99);
      if (!_retryAttempted && controllerclient.errorHome == -99) {
        Get.snackbar('Alerta', 'Conexión débil.',
            duration: const Duration(milliseconds: 2500));
        clientCon.correctConnection = false;
        _retryAttempted = true;
        professionalBranchNotifQueque(idBranch, idProfe, type, msj, token);
      }
    }
  }

  //
  //
  //
//todo/****AQUI LO DE LAS NOTIFICACIONES LOCALES****/
//tecnicooooooo
  Future<void> fetchNotificationListSERV(
      idBranch, idProfe, type, msj, token) async {
    print('estoy llamando ahora desde->fetchNotificationListSERV');
    print(
        'callTimerTec 4-callTimerTecNotification-controlador-fetchNotificationList');
    print('qwerc SII mandar ->NOTIFICACIONES-$msj');
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');
    try {
      Map<String, dynamic> result =
          await repository.getNotificationList(idBranch, idProfe, type, token);
      bool siHayEliminarService = false;
      print('object-${clientsTechnicalCont.clientsTechnicalLength}');
      if (result.containsKey('notificationListError') &&
          result.containsKey('notificationListError') == true) {
        print('estoy entrando aqui si al error de notificacion.tec');

        if (type == 'Tecnico' &&
            clientsTechnicalCont.clientsTechnicalLength >
                0) //es tecnico y tiene la cola vacia que ni lo muestre
        {
          controllerLogin.showConnectionError();
        }
        if (type != 'Tecnico') {
          controllerLogin.showConnectionError();
        }
      } else if (result.containsKey('Erroor') && result['Erroor'] == true) {
        print(
            'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor,-8 el error fue en Future<void> fetchNotificationList');
      } else if (result.containsKey('notificationList') &&
          result.containsKey('notificationListNew')) {
        notification = result['notificationList'];

        print(
            'llamada timer estoy en CAntidad de Notificaciones fetchNotificationList :${notification.length}');

        notificationListLength = notification.length;

        notificationListNew = result['notificationListNew'];
        notificationListNewLength = notificationListNew.length;
        List<NotificationModel> notificationListNewAux =
            []; // Lista de Notificaciones
        for (final element in notificationListNew) {
          if (element.state == 0 || element.state == 3) {
            print(
                'callTimerTec 4-callTimerTecNotification -if-element.state :${element.state}');
            if (!notificationListNewSounded.contains(element.id)) {
              notificationListNewSounded.add(element.id);

              notificationListNewAux.add(element);
              //localNotificationsSimplifies(element.tittle, element.description);
            }
          }

          //esto es para saber que valor darle al qr si aceptan o rechazan la colación

          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Colación') //pongo a null el qr
          {
            controllerLogin.setCodigoQrValid(null);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Colación') //pongo a 1 el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Salida') //pongo a 1 el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Salida') //pongo a 1 el qr
          {
            print('cargando aqui-16 para sacar del puesto y la apk-1');

            updateOutAcept(element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Solicitud de Eliminación Rechazada') //pongo a null el qr
          {
            print(
                'callTimerTec 4-callTimerTecNotification -if-element.tittle :${element.tittle}');
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada Eliminación de Cliente') //pongo a null el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
        }

        //todo comentado_nuevo
//aqui veo y voy mandando las notificaciones locales
        for (final result in notificationListNewAux) {
          print(
              'callTimerTec 4-callTimerTecNotification -if-notificaciones locales :sii');
          // Llama a la función localNotificationsSimplifies después del retraso
          localNotificationsSimplifies(result.tittle, result.description);
          print('aqui llamando las notificaciones nuevas');
          await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos
        }
        //todo comentado_nuevo

        if (outAcept !=
            0) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          Get.snackbar(
            'Mensaje',
            'Cerrando aplicación.',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ),
            ),
            barrierDismissible: false,
          ); //Get.back();
          await updateNotifications2(idBranch, idProfe, outAcept);
          //await controllerLogin.exitPostworking("Tecnico");
          await controllerLogin.exit(controllerLogin.tokenUserLoggedIn);
          updateOutAcept(0);
          Get.back();
          print('cargando aqui-16 para sacar del puesto y la apk-2');
        }

        update();
      } else if (result.containsKey('notificationListEncarg') &&
          result.containsKey('notificationListNewEncarg')) {
        print('ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador');
        notificationEncarg = result['notificationListEncarg'];

        notificationListLengthEncarg = notificationEncarg.length;

        notificationListNewEncarg = result['notificationListNewEncarg'];
        notificationListNewLengthEncarg = notificationListNewEncarg.length;
        print(
            'ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador - notificationListNewLengthEncarg:${notificationEncarg.length}');

        notificationListNewEncarg.forEach((element) async {
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            // String numeroOcultoString = textoCompleto
            //     .split('.')[1]
            //     .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            // int idReservation =
            //     int.parse(numeroOcultoString); // Convertir a entero
            int idReservation = obtenerNumeroDespuesDelPunto(textoCompleto);
            print(
                'modificar time de mm 1 estoy aqui en el forEach-2-idReservation:$idReservation - textoCompleto:$textoCompleto');

            controllerclient.watchModifyTimeRest(idReservation, textoCompleto,
                'fetchNotificationListSERV'); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            //  siHayEliminarService = true;
          }
        });
        /* if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.rest();
          // controllerclient.setActiveModifyTimeRest(true);
        }*/

        update();
      }
      controllerLogin.setIsLoadingFor(false);
    } catch (e) {
      controllerLogin.setIsLoadingFor(false);
      // Manejo de errores
      print('Error al obtener la lista de notificaciones:aqui: $e');
    }
  }

  Future<void> fetchNotificationList(
      idBranch, idProfe, type, msj, token) async {
    print('estoy llamando ahora desde->fetchNotificationListAPK');
    print(
        'callTimerTec 4-callTimerTecNotification-controlador-fetchNotificationList');
    print('qwerc SII mandar ->NOTIFICACIONES-$msj');
    print('12345llamada timer estoy en CAntidad de Notificaciones-$type');
    print(
        'llamada timer ...tipo:$type......idSucursal:$idBranch......iProf:$idProfe');
    try {
      Map<String, dynamic> result =
          await repository.getNotificationList(idBranch, idProfe, type, token);
      bool siHayEliminarService = false;
      print('object-${clientsTechnicalCont.clientsTechnicalLength}');
      if (result.containsKey('notificationListError') &&
          result.containsKey('notificationListError') == true) {
        print('estoy entrando aqui si al error de notificacion.tec');

        if (type == 'Tecnico' &&
            clientsTechnicalCont.clientsTechnicalLength >
                0) //es tecnico y tiene la cola vacia que ni lo muestre
        {
          controllerLogin.showConnectionError();
        }
        if (type != 'Tecnico') {
          controllerLogin.showConnectionError();
        }
      } else if (result.containsKey('Erroor') && result['Erroor'] == true) {
        print(
            'mandar alguna variable para la vista deciendo que hay problemas al conectarse con el servidor,-8 el error fue en Future<void> fetchNotificationList');
      } else if (result.containsKey('notificationList') &&
          result.containsKey('notificationListNew')) {
        notification = result['notificationList'];

        print(
            'llamada timer estoy en CAntidad de Notificaciones fetchNotificationList :${notification.length}');

        notificationListLength = notification.length;

        notificationListNew = result['notificationListNew'];
        notificationListNewLength = notificationListNew.length;
        List<NotificationModel> notificationListNewAux =
            []; // Lista de Notificaciones
        for (final element in notificationListNew) {
          if (element.state == 0 || element.state == 3) {
            print(
                'callTimerTec 4-callTimerTecNotification -if-element.state :${element.state}');
            if (!notificationListNewSounded.contains(element.id)) {
              notificationListNewSounded.add(element.id);

              notificationListNewAux.add(element);
              //localNotificationsSimplifies(element.tittle, element.description);
            }
          }

          //esto es para saber que valor darle al qr si aceptan o rechazan la colación
          print('estoy llamando ahora desde->fetchNotificationList');
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Colación') //pongo a null el qr
          {
            controllerLogin.setCodigoQrValid(null);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Colación') //pongo a 1 el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Rechazada su solicitud de Salida') //pongo a 1 el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada su solicitud de Salida') //pongo a 1 el qr
          {
            print('cargando aqui-16 para sacar del puesto y la apk-1');

            updateOutAcept(element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Solicitud de Eliminación Rechazada') //pongo a null el qr
          {
            print(
                'callTimerTec 4-callTimerTecNotification -if-element.tittle :${element.tittle}');
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
          if (element.state == 3 &&
              element.tittle ==
                  'Aceptada Eliminación de Cliente') //pongo a null el qr
          {
            controllerLogin.setCodigoQrValid(1);
            updateNotifications2(idBranch, idProfe, element.id);
          }
        }

        //todo comentado_nuevo
//aqui veo y voy mandando las notificaciones locales
        /*   for (final result in notificationListNewAux) {
          print(
              'callTimerTec 4-callTimerTecNotification -if-notificaciones locales :sii');
          // Llama a la función localNotificationsSimplifies después del retraso
          localNotificationsSimplifies(result.tittle, result.description);
          print('aqui llamando las notificaciones nuevas');
          await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos
        }*/
        //todo comentado_nuevo

        if (outAcept !=
            0) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          Get.snackbar(
            'Mensaje',
            'Cerrando aplicación.',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ),
            ),
            barrierDismissible: false,
          ); //Get.back();
          await updateNotifications2(idBranch, idProfe, outAcept);
          // await controllerLogin.exitPostworking("Tecnico");
          await controllerLogin.exit(controllerLogin.tokenUserLoggedIn);
          updateOutAcept(0);
          Get.back();
          print('cargando aqui-16 para sacar del puesto y la apk-2');
        }

        update();
      } else if (result.containsKey('notificationListEncarg') &&
          result.containsKey('notificationListNewEncarg')) {
        print('ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador');
        notificationEncarg = result['notificationListEncarg'];

        notificationListLengthEncarg = notificationEncarg.length;

        notificationListNewEncarg = result['notificationListNewEncarg'];
        notificationListNewLengthEncarg = notificationListNewEncarg.length;
        print(
            'ENTRO A BUSCAR NOTIFICACIONES - cont: estoy en el controlador - notificationListNewLengthEncarg:${notificationEncarg.length}');

        notificationListNewEncarg.forEach((element) async {
          if (element.state == 3 &&
              element.tittle == 'Aceptada Eliminación de Servicio') {
            print('modificar time de mm 1 estoy aqui en el forEach');
            String textoCompleto = element.description;
            // String descripcion =
            //     textoCompleto.split('.')[0]; // Obtener la descripción
            // Obtener el segundo número (999)
            // String numeroOcultoString = textoCompleto
            //     .split('.')[1]
            //     .trim(); // Obtener la parte después del punto y eliminar espacios en blanco
            // int idReservation =
            //     int.parse(numeroOcultoString); // Convertir a entero
            int idReservation = obtenerNumeroDespuesDelPunto(textoCompleto);
            print(
                'modificar time de mm 1 estoy aqui en el forEach-2-idReservation:$idReservation - textoCompleto:$textoCompleto');

            controllerclient.watchModifyTimeRest(idReservation, textoCompleto,
                'fetchNotificationList'); //aqui le mando el tiempo tambien y los voy sumando si el id coincidiera
            updateNotifications2(idBranch, idProfe,
                element.id); //aqui es para no repetir esto y lo pongo en 0

            //NOTIFICAR UQ HAY CAMBIOS EN LOS RELOJES
            //DESCONTAR EL TIEMPO AL RELOJ
            //MANDAR AL METODO DE SABER CUANTOS MINUTOS HAY QUE DESCONTAR
            //  siHayEliminarService = true;
          }
        });
        /* if (siHayEliminarService ==
            true) //entro solo si entro al if de 'Aceptada Eliminación de Servicio'
        {
          controllerclient.rest();
          // controllerclient.setActiveModifyTimeRest(true);
        }*/

        update();
      }
      controllerLogin.setIsLoadingFor(false);
    } catch (e) {
      controllerLogin.setIsLoadingFor(false);
      // Manejo de errores
      print('Error al obtener la lista de notificaciones:aqui: $e');
    }
  }

  Future<void> updateNotifications(idBranch, idProf, type) async {
    try {
      int result = await repository.updateNotifications(
          idBranch, idProf, type, controllerLogin.tokenUserLoggedIn);
      if (result == 1) {
        print('Las notificaciones fueron vistas');
      } else {
        print('No modifico las notificaciones como vistas');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }

  Future<void> updateNotifications2(idBranch, idProf, id) async {
    try {
      int result = await repository.updateNotifications2(
          idBranch, idProf, id, controllerLogin.tokenUserLoggedIn);
      if (result == 1) {
        print('Las notificaciones fueron cambiada a 3 estas de id:$id');
      } else {
        print('Las notificaciones fueron cambiada a 3 NOOOOOOOOOOOOO');
      }
    } catch (e) {
      print('error de notification:$e');
    }
  }
}
