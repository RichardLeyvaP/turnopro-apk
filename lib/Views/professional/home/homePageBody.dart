import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';

import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:uuid/uuid.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
/*
import 'package:turnopro_apk/Models/notification_model.dart';
import 'package:turnopro_apk/env.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; // Importa el paquete 'dart:convert' para trabajar con JSON*/

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());
  NotificationController notiController = Get.find<NotificationController>();
  ServiceController serviceControll = Get.find<ServiceController>();
  ShoppingCartController chopCont = Get.find<ShoppingCartController>();
  CoexistenceController coexCont = Get.find<CoexistenceController>();

  @override
  bool get wantKeepAlive => true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
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
  }

/*
  WebSocketChannel channel = IOWebSocketChannel.connect(
      'wss://api2.simplifies.cl/api/notification-professional?branch_id=15&professional_id=76');*/
  @override
  void initState() {
    super.initState();
    print('fff12 antes del channel.stream');
    /* channel.stream.listen((message) {
      // Parsear el mensaje JSON recibido
      Map<String, dynamic> jsonMessage = jsonDecode(message);
      List<dynamic> notificationsJson = jsonMessage['notifications'];
      print('fff12 antes del map');
      // Mapear la lista de notificaciones a objetos NotificationModel
      List<NotificationModel> notifications =
          notificationsJson.map((notificationJson) {
        return NotificationModel.fromJson(notificationJson);
      }).toList();
      print('fff12 despues del map');
      // Usar las notificaciones en tu aplicación (por ejemplo, mostrar en la interfaz de usuario)
      notifications.forEach((notification) {
        print('fff12 ID: ${notification.id}');
        print('fff12 Título: ${notification.tittle}');
        print('fff12 Descripción: ${notification.description}');
        print('fff12 ID del profesional: ${notification.professional_id}');
        print('fff12 ID de la sucursal: ${notification.branch_id}');
        // Puedes actualizar el estado local de tu aplicación o mostrar las notificaciones en la interfaz de usuario
      });
    });*/
    print('cargando aqui-3');
    // initializeNotifications();
    //AQUI ME DEVUELVE A Q CLIENTE LE SIGUE Y ACUAL MOSTRAR EN LA COLA
    clientsScheduledController.filterShowNext();
    //clientsScheduledController.filterShowCardTimer();//todo ahora comente a ver que pasa

    //INICIALIZANDO CONTROLES DE LOS RELOJES
    clientsScheduledController.animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );
    //clientsScheduledController.animationControllerInitial!.forward();
    //clientsScheduledController.animationControllerInitial!.forward();
// Inicia la animación
    if ((loginController.chargeUserLoggedIn !=
        "Barbero y Encargado")) //a este cargo no se le cambie la regla de convivencia del tiempo
    {
      clientsScheduledController.animationControllerInitial!
          .addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (clientsScheduledController.noncomplianceProfessional['Tiempo'] !=
                  0 &&
              loginController.usserPermissionQr == 1 &&
              clientsScheduledController.clientsScheduledListLength > 0) {
            print(
                'inserto correctamente ********** .noncomplianceProfessional[]');
            //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
            String type = 'Tiempo';
            int branchId = loginController.branchIdLoggedIn!;
            int professionalId = loginController.idProfessionalLoggedIn!;
            int estado = 0; //es que incumplió
            clientsScheduledController.changeNoncomplianceP(
                type, branchId, professionalId, estado);
            //aqui llamar e insertar en las notificacione sque incumplio esta convivencia
            notiController.storeNotification(
                'Incumplimiento de convivencia',
                branchId,
                professionalId,
                'Tu tiempo de espera de 3 minutos para seleccionar al nuevo cliente en cola se ha agotado',
                'Barbero');

            scheduleNotification('Incumplimiento de convivencia',
                'Tu tiempo de espera de 3 minutos');
          }

          // La animación ha llegado al final, reiniciar
          clientsScheduledController.animationControllerInitial!.reset();
          clientsScheduledController.animationControllerInitial!.forward();
        } else {
          print(
              'inserto correctamente NO ENTRO ********** .noncomplianceProfessional[]');
        }
      });
    }

    clientsScheduledController.animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
//

    WidgetsBinding.instance.addPostFrameCallback((_) {
      llamadasTimer1();
    });
  }

  @override
  void dispose() {
    clientsScheduledController.animationControllerInitial!.dispose();
    clientsScheduledController.animationController1!.dispose();
    clientsScheduledController.animationController2!.dispose();
    clientsScheduledController.animationController3!.dispose();
    clientsScheduledController.animationController4!.dispose();
    // channel.sink.close();

    _timer1?.cancel();

    super.dispose();
  }

  void verifyingClockTimeActive() {
    print('cargando aqui-9');
    if (clientsScheduledController.clientsAttended1 == null &&
        clientsScheduledController.clientsAttended2 == null &&
        clientsScheduledController.clientsAttended3 == null &&
        clientsScheduledController.clientsAttended4 == null &&
        loginController.usserPermissionQr == 1 &&
        clientsScheduledController.clientsScheduledListLength > 0 &&
        clientsScheduledController.animationControllerInitial != null) {
      //SI TODOS LOS RELOS ESTAN DETENIDOS Y TIENE EL QR LEIDO Y HAY ALGIEN EN COLA QUE REINICIE EL RELOJ DE 3 MIN DE ESPERA
      //REINICIO Y ACTIVO EL RELOJ DE ESPERA
      print('estoy reiniciando el reloj inicial');
      bool isAnimating =
          clientsScheduledController.animationControllerInitial!.isAnimating;
      if (!isAnimating) {
        print('estoy reiniciando el reloj inicial--NO ESTABA ANIMADO');

        clientsScheduledController.animationControllerInitial!.reset();
        clientsScheduledController.animationControllerInitial!.forward();
      }
    } else {
      if (clientsScheduledController.animationControllerInitial != null) {
        clientsScheduledController.animationControllerInitial!.stop();
      }
    }
  }

  void verifyingClockTime(
      ClientsScheduledController clientsScheduledController, int endingTime) {
    print('cargando aqui-8');
    try {
      //este es para el reloj 1
      if (clientsScheduledController.clientsAttended1 != null) {
        if (clientsScheduledController.animationController1 != null &&
            clientsScheduledController.animationController1!.isAnimating) {
          print('object-1');
          int? idClient =
              clientsScheduledController.clientsAttended1?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended1?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients1 == null ||
                (clientsScheduledController.notificationClients1 != idClient &&
                    clientsScheduledController.notificationClients1 != null)) {
              if (clientsScheduledController.animationController1 != null) {
                double progress =
                    clientsScheduledController.animationController1!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended1!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar
                print(
                    'aqui viendo los tiempos-remainingTimeInSeconds:$remainingTimeInSeconds ----- standbyTimeSeconds:$standbyTimeSeconds');
                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended1?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    clientsScheduledController.setNotificationClients1(1,
                        clientsScheduledController.clientsAttended1!.client_id);
                    scheduleNotification('!Alerta',
                        'El tiempo de servicio del cliente $nameClient se agotará');
                  }
                }
              }
            }
          }
        } else {
          print('object-2');
        }
      } else {
        clientsScheduledController.animationController1!.stop();
        clientsScheduledController.clearNotificationClients1(1);
        print('object-2-2 reloj 1');
      }
//este es para el reloj 2
      if (clientsScheduledController.clientsAttended2 != null) {
        if (clientsScheduledController.animationController2 != null &&
            clientsScheduledController.animationController2!.isAnimating) {
          print('object-1 reloj 2');
          int? idClient =
              clientsScheduledController.clientsAttended2?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended2?.client_name;
          if (idClient != null && nameClient != null) {
            print('object-1 reloj 2******************');
            print(
                'object-1 reloj 2******************notificationClients2${clientsScheduledController.notificationClients2}');
            print('object-1 reloj 2******************idClient:$idClient');
            print(
                'object-1 reloj 2******************clientsScheduledController.animationController2 :${clientsScheduledController.animationController2}');
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients2 == null ||
                (clientsScheduledController.notificationClients2 != idClient &&
                    clientsScheduledController.notificationClients2 != null)) {
              if (clientsScheduledController.animationController2 != null) {
                print('object-1 reloj 2*********....................*********');
                double progress =
                    clientsScheduledController.animationController2!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended2!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar
                print(
                    'aqui viendo los tiempos-2 remainingTimeInSeconds:${remainingTimeInSeconds - 40} ----- standbyTimeSeconds:$standbyTimeSeconds');
                if ((remainingTimeInSeconds - 40) <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended2?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    scheduleNotification('!Alerta',
                        'El tiempo de servicio del cliente $nameClient se agotará');
                    clientsScheduledController.setNotificationClients1(2,
                        clientsScheduledController.clientsAttended2!.client_id);
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 2');
        }
      } else {
        clientsScheduledController.animationController2!.stop();
        clientsScheduledController.clearNotificationClients1(2);
        print('object-2-2 reloj 2');
      }
      //este es para el reloj 3
      if (clientsScheduledController.clientsAttended3 != null) {
        if (clientsScheduledController.animationController3 != null &&
            clientsScheduledController.animationController3!.isAnimating) {
          print('object-1 reloj 3');
          int? idClient =
              clientsScheduledController.clientsAttended3?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended3?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients3 == null ||
                (clientsScheduledController.notificationClients3 != idClient &&
                    clientsScheduledController.notificationClients3 != null)) {
              if (clientsScheduledController.animationController3 != null) {
                double progress =
                    clientsScheduledController.animationController3!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended3!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar
                print(
                    'aqui viendo los tiempos-3 remainingTimeInSeconds:$remainingTimeInSeconds ----- standbyTimeSeconds:$standbyTimeSeconds');

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended3?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    scheduleNotification('!Alerta',
                        'El tiempo de servicio del cliente $nameClient se agotará');
                    clientsScheduledController.setNotificationClients1(3,
                        clientsScheduledController.clientsAttended3!.client_id);
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 3');
        }
      } else {
        clientsScheduledController.animationController3!.stop();
        clientsScheduledController.clearNotificationClients1(3);
        print('object-2-2 reloj 3');
      }

      //este es para el reloj 4
      if (clientsScheduledController.clientsAttended4 != null) {
        if (clientsScheduledController.animationController4 != null &&
            clientsScheduledController.animationController4!.isAnimating) {
          print('object-1 reloj 4');
          int? idClient =
              clientsScheduledController.clientsAttended4?.client_id;
          String? nameClient =
              clientsScheduledController.clientsAttended4?.client_name;
          if (idClient != null && nameClient != null) {
            //analizo si para este clientes ya se envio el mensaje para no repetirselo
            if (clientsScheduledController.notificationClients4 == null ||
                (clientsScheduledController.notificationClients4 != idClient &&
                    clientsScheduledController.notificationClients4 != null)) {
              if (clientsScheduledController.animationController4 != null) {
                double progress =
                    clientsScheduledController.animationController4!.value;
                int totalTimeInSeconds = clientsScheduledController
                    .timeClientsAttended4!; // Duración total del AnimationController en segundos
                int elapsedTimeInSeconds =
                    (progress * totalTimeInSeconds).round();
                int remainingTimeInSeconds =
                    totalTimeInSeconds - elapsedTimeInSeconds;
                int standbyTimeSeconds = endingTime * 60;
                // Verificar si faltan menos de 180 segundos (3 minutos) para terminar
                print(
                    'aqui viendo los tiempos-4 remainingTimeInSeconds:$remainingTimeInSeconds ----- standbyTimeSeconds:$standbyTimeSeconds');

                if (remainingTimeInSeconds <= standbyTimeSeconds) {
                  // Realizar alguna acción
                  print(
                      'object-Enviar mensaje que el tiempo de servicio esta por culminar, que solo le faltan 3 minutos');

                  int professionalId = loginController.idProfessionalLoggedIn!;
                  int branchId = loginController.branchIdLoggedIn!;

                  if ((idClient ==
                      clientsScheduledController.clientsAttended4?.client_id)) {
                    notiController.storeNotification(
                        '!Alerta',
                        branchId,
                        professionalId,
                        'El tiempo de servicio del cliente $nameClient se agotará en los próximos $endingTime minutos',
                        'Barbero');
                    //llamo al metodo que me dice que para este cliente ya se envio una notificacion al barbero
                    scheduleNotification('!Alerta',
                        'El tiempo de servicio del cliente $nameClient se agotará');
                    clientsScheduledController.setNotificationClients1(4,
                        clientsScheduledController.clientsAttended4!.client_id);
                  }
                }
              }
            }
          }
        } else {
          print('object-2 reloj 4');
        }
      } else {
        clientsScheduledController.animationController4!.stop();
        clientsScheduledController.clearNotificationClients1(4);
        print('object-2-2 reloj 4');
      }
      //
      //
    } catch (e) {
      print('object-4 dio error en :$e');
    }
  }

  Timer? _timer1;

  llamadasTimer1() {
    _timer1 = //notificaciones
        Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      print('llamada timer en 10 segundos');
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          (loginController.chargeUserLoggedIn == "Barbero" ||
              (loginController.chargeUserLoggedIn == "Barbero y Encargado"))) {
        //await Future.delayed(Duration(seconds: 1));
        //Buscar notificaciones
        //variables
        int idBranch = loginController.branchIdLoggedIn!;
        int idProfe = loginController.idProfessionalLoggedIn!;
        String type = 'Barbero';
        String msj = 'llamadasTimer1';

        notiController.professionalBranchNotifQueque(
            idBranch, idProfe, type, msj);

        //lo que llamaba el timer 2
        print('llamada timer 2 - 11segundos');
        if (loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          //guardar datos de los relojes en la db
          await clientsScheduledController.upadateVariablesValueTimers();
          //  await Future.delayed(Duration(seconds: 2));
          //saber si hay que parar o reaunudar algun reloj
          for (var i = 0;
              i < clientsScheduledController.clientsScheduledList.length;
              i++) {
            int clock = 0;
            if (clientsScheduledController.clientsScheduledList[i].attended ==
                11) {
              int reservationId = clientsScheduledController
                  .clientsScheduledList[i].reservation_id;
              clock = await clientsScheduledController
                  .getValueClockDb(reservationId);
              if (clock == 1) {
                print('activando el Clock - 1');
                clientsScheduledController.animationController1!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 2) {
                print('activando el Clock - 2');
                clientsScheduledController.animationController2!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 3) {
                print('activando el Clock - 3');
                clientsScheduledController.animationController3!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
              if (clock == 4) {
                print('activando el Clock - 4');
                clientsScheduledController.animationController4!.forward();
                clientsScheduledController.acceptOrRejectClient(
                    reservationId, 111);
                clientsScheduledController.pauseResumeClock((clock - 1), -99);
              }
            } //fin del if
          }
        }
        //lo que llamaba el timer 2

        //ESTO ES LO QUE LLAMABA EL TIMER
        if (loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          //en este caso son 3 minutos que esta definido en el controlador
          //aqui verifico si se esta acabando algun servico para mandar una notificacion
          //  await Future.delayed(Duration(seconds: 1));
          verifyingClockTime(clientsScheduledController,
              clientsScheduledController.endingTime);
        }
        //ESTO ES LO QUE LLAMABA EL TIMER

        //ESTO ES LO QUE LLAMABA EL TIMER 3
        if (loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          //en este caso son 3 minutos que esta definido en el controlador
          //aqui verifico si se esta acabando algun servico para mandar una notificacion
          //
          // await Future.delayed(Duration(seconds: 2));
          if ((clientsScheduledController.varClientsWaiting == true) &&
              (loginController.usserPermissionQr == 1)) {
            print('esteeeeee se cumplio que puede atender ..aqui entrandoya');
            if (clientsScheduledController
                    .animationControllerInitial!.isAnimating &&
                clientsScheduledController.cantClientWait !=
                    clientsScheduledController.clientsScheduledListLength) {
              // La animación está activa (en progreso)
              if (clientsScheduledController.contClientsWaiting == 10) {
                print('esteeeeee varClientsWaiting Mande la notificacion ya');
                //aqui llamar e insertar en las notificaciones
                notiController.storeNotification(
                    'Clientes en cola',
                    loginController.branchIdLoggedIn,
                    loginController.idProfessionalLoggedIn,
                    'Recuerda que tienes clientes en cola.¡No los mantengas esperando por mucho tiempo!',
                    'Barbero');
                scheduleNotification(
                    '!Alerta', 'Recuerda que tienes clientes en cola');
                //para controlar que con este cliente solo le avise una vez
                clientsScheduledController.setContClientsWaiting(20);
                clientsScheduledController.setcantClientWait(
                    clientsScheduledController.clientsScheduledListLength);
              }
              if (clientsScheduledController.contClientsWaiting == 10) {
                print(
                    'entando en 10 segundos aqui para insertar el tiempo si hubiera reloj activo');
              } else if (clientsScheduledController.contClientsWaiting ==
                  100) //si llega a 100 mando que sea 20 de nuevo para q no pase de los valores del entero y tener un control mejor de el
              {
                clientsScheduledController.setContClientsWaiting(20);
              } else {
                clientsScheduledController
                    .setContClientsWaiting(-91119); //sumo 1
              }
            } else {
              clientsScheduledController
                  .setContClientsWaiting(-90009); //inicializo nuevamente a 0
              // La animación está detenida
            }
          } else {
            clientsScheduledController
                .setContClientsWaiting(-90009); //inicializo nuevamente a 0
          }
          //
        }
        //ESTO ES LO QUE LLAMABA EL TIMER 3
      }
    });
  }

  // //
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO

    super.build(context);
    return GetBuilder<ClientsScheduledController>(
        builder: (clientsScheduledController) {
      //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<ClientsScheduledModel?> clientsList = [
        clientsScheduledController.clientsAttended1,
        clientsScheduledController.clientsAttended2,
        clientsScheduledController.clientsAttended3,
        clientsScheduledController.clientsAttended4,
        // Agrega más listas según sea necesario
      ]; //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<AnimationController?> animationCont = [
        clientsScheduledController.animationController1,
        clientsScheduledController.animationController2,
        clientsScheduledController.animationController3,
        clientsScheduledController.animationController4,
        // Agrega más listas según sea necesario
      ];

      activeClock() {
        print('La aplicación se activeClock() {--');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration =
                Duration(seconds: animationCont[0]!.duration!.inSeconds);
            animationCont[0]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[0]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration =
                Duration(seconds: animationCont[1]!.duration!.inSeconds);
            animationCont[1]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[1]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration =
                Duration(seconds: animationCont[2]!.duration!.inSeconds);
            animationCont[2]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[2]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration =
                Duration(seconds: animationCont[3]!.duration!.inSeconds);
            animationCont[3]!.forward();
            print(
                'La aplicación se activeClock() {-- ${animationCont[3]!.duration!.inSeconds}');
          }
        }
      }

      activeClockLogin() {
        print('La aplicación se activeClock() {--');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended1!);
            animationCont[0]!.forward();
            print(
                'La aplicación se activeClock() {-- ${clientsScheduledController.timeClientsAttended1!}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended2!);
            animationCont[1]!.forward();
            print(
                'La aplicación se activeClock() {-- ${clientsScheduledController.timeClientsAttended2!}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended3!);
            animationCont[2]!.forward();
            print(
                'La aplicación se activeClock() {-- ${clientsScheduledController.timeClientsAttended3!}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended4!);
            animationCont[3]!.forward();
            print(
                'La aplicación se activeClock() {-- ${clientsScheduledController.timeClientsAttended4!}');
          }
        }
      }

      /*   if (loginController.segundoPlano == 3) {
        print(
            '..segundoPlano siii activando los relojes animationCont[0]!.duration : ${animationCont[0]!.duration}');
        print('..segundoPlano siii activando los relojes');
        animationCont[0]!.duration =
            Duration(seconds: clientsScheduledController.timeClientsAttended1!);
      }*/

      if (loginController.isLoggingInCharge == true) {
        //solo va a entar si viene del login
        print(
            'Hubo un cierre inesperado y se estan activando los relojessiiiiii');

        activeClockLogin();
      }
      if (clientsScheduledController.closeIesperado == true &&
          loginController.isLoggingInCharge == false) {
        print(
            'Hubo un cierre inesperado y se estan activando los relojesDDDDDDDDDDDDDDDDDDDDD');
        activeClock();
      }
      if (clientsScheduledController.activeModifyTime == true) {
        //SI activeModifyTime =  TRUE SUMO TIEMPO
        print(
            'tiempo a sumar =  2 EL TIEMPO ACTUAL DEL RELOJ estoy entrando aqui');
        //aqui verifico qsi hay que agregarle el tiempo algun reloj
        print(
            'activeModifyTime SOY = ${clientsScheduledController.activeModifyTime} Y MANDE ESTE TIEMPO ${clientsScheduledController.modifyTime[clientsScheduledController.modifyTimeSpecific]}');
        int i = clientsScheduledController.modifyTimeSpecific;
        int value = clientsScheduledController
            .modifyTime[clientsScheduledController.modifyTimeSpecific];
        // Obtén la duración total del AnimationController
        Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
        double tiempoTranscurrido =
            animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
        double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo duracionTotal: $duracionTotal');
        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo tiempoTranscurrido: ${tiempoTranscurrido.truncate()}');
        print('EL TIEMPO ACTUAL DEL RELOJ Tiempo restante: $tiempoRestante');

        Duration duracionSendAct = Duration(
          minutes: tiempoRestante.truncate() + value,
        );

// Aumenta la duración actual en 30 segundos
        Duration nuevaDuracion = duracionSendAct;

        animationCont[i]!.duration = nuevaDuracion;
        print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

        animationCont[i]!.reset();
        animationCont[i]!.forward();
        print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');

        //preguntar que no venga del login
      }

      if (clientsScheduledController.activeModifyTimeRest == true) {
        if (clientsScheduledController.modifyTimeSpecificRest != -99) //reloj 1
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;
          print('modificar time de mm i = $i');
          print('modificar time de mm value = $value');
// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }

          Duration duracionSendAct = Duration(
            minutes: valueMin,
          );

// Aumenta la duración actual en 30 segundos
          Duration nuevaDuracion = duracionSendAct;

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest1 != -99) //reloj 2
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest1 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest1;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME1;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

          Duration duracionSendAct = Duration(
            minutes: tiempoRestante.truncate() - value,
          );

// Aumenta la duración actual en 30 segundos
          Duration nuevaDuracion = duracionSendAct;

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }
        if (clientsScheduledController.modifyTimeSpecificRest2 != -99) //reloj 3
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest2 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest2;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME2;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

          Duration duracionSendAct = Duration(
            minutes: tiempoRestante.truncate() - value,
          );

// Aumenta la duración actual en 30 segundos
          Duration nuevaDuracion = duracionSendAct;

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest3 != -99) //reloj 4
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest3 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest3;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME3;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

          Duration duracionSendAct = Duration(
            minutes: tiempoRestante.truncate() - value,
          );

// Aumenta la duración actual en 30 segundos
          Duration nuevaDuracion = duracionSendAct;

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$duracionSendAct');

          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        //preguntar que no venga del login
      }

      //AQUI ESCUCHANDO PARA SABER SI TENGO QUE DETENER O REAUNUDAR LOS TIMER
      if (clientsScheduledController.clockchanges == true) {
        //
        for (var i = 0;
            i < clientsScheduledController.pausResumeClock.length;
            i++) {
          int? value = clientsScheduledController.pausResumeClock[i];
          //
          if (value != -99) {
            if (value == 0) //hay que pausarlo
            {
              if (i == 0) {
                clientsScheduledController.animationController1!.stop();
                print('PAUSE EL RELOJ 1');
              }
              if (i == 1) {
                clientsScheduledController.animationController2!.stop();
                print('PAUSE EL RELOJ 2');
              }
              if (i == 2) {
                clientsScheduledController.animationController3!.stop();
                print('PAUSE EL RELOJ 3');
              }
              if (i == 3) {
                clientsScheduledController.animationController4!.stop();
                print('PAUSE EL RELOJ 4');
              }
            }
          }
        } //fin del for
      }

      String firstName = '';
      // //todo AQUI DETENGO LOS TIMER QUE NO ESTAN VISIBLES

      if (clientsScheduledController.clientsScheduledNext != null) {
        String fullName =
            clientsScheduledController.clientsScheduledNext!.client_name;
        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)
        firstName = partsName.isNotEmpty ? partsName[0] : "";
        // String secondName = partsName.length > 1 ? partsName[1] : "";
      }

      //clientsScheduledController.animationControllerInitial!.forward();

      // print('clientes asistiendo Antes de addPostFrameCallback');

      //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        //   print('cargando aqui-10');
        //aqui solo debe entrar cuando o se agregan servicios o cuando se eliminan
        if (loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          verifyingClockTimeActive();
        }
        if (loginController.segundoPlano == 3) {
          print('cargando aqui-11');
          print('..segundoPlano siii APAGANDO LLAMADA');
          loginController.getSegundoPlano(1);
        }
        if (clientsScheduledController.activeModifyTime == true) {
          print('cargando aqui-12');
          //AQUI GARANTIZO QUE AUMENTE EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
          clientsScheduledController.setActiveModifyTime(false);
        }
        if (clientsScheduledController.activeModifyTimeRest == true) {
          print('cargando aqui-13');
          //AQUI GARANTIZO QUE disminuya EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
          clientsScheduledController.setActiveModifyTimeRest(false);
          clientsScheduledController.clearModifyTimeSpecificRest();
        }

        if (loginController.ejecutadoEvent == false) {
          print('cargando aqui-14');
          // Se ejecutará después de que se haya construido el widget
          //define que tipo de saludo dar dependiendo de la hora

          if (clientsScheduledController.closeIesperado == true) {
            print('-*-*-*-**>>>> si fui un sierre inesperado');
            if (clientsScheduledController.item.isNotEmpty) {
              loginController.setCodigoQrValid(1);
            } else if (loginController.usserPermissionQr == -99 &&
                loginController.usserPermissionQr == 0) {
              loginController.setCodigoQrValid(null);
              print(
                  'id de mi puesto de trabajo 1 no esta en ningun puesto:null');
            }
          } else {
            print('-*-*-*-**>>>> NOOO fui un sierre inesperado');
          }
          if (loginController.isLoggingInCharge == true) {
            await loginController.setLoggingInCharge(false);
          }

          clientsScheduledController.setCloseIesperado(false);
          clientsScheduledController.clockChanges(false);
          loginController.ejecutado_(true);
          clientsScheduledController.modifingTimeClose();
        }
        clientsScheduledController.setCloseIesperadoLogin(false);
        if (loginController.isLoggingInCharge == true) {
          print('cargando aqui-15');
          await loginController.setLoggingInCharge(false);
        }
        clientsScheduledController.setCloseIesperado(false);
        // print(
        //     'clientes asistiendo ENTRE A DESTRUIR LAS VARIABLES DEL TIEMPO ASIGNADO activeModifyTime SOY = ${clientsScheduledController.activeModifyTime}');
      });
      // print('clientes asistiendo Después de addPostFrameCallback');
      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: loginController.androidInfoDisplay! >=
                      6.6 //propiedades de telefone
                  ? 12
                  : 13,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: (clientsScheduledController
                                .clientsScheduledListLength >
                            0)
                        ? Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Colors.white,
                              //color: Color(0xFFFDAE2A),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /*todo texto arriba */ Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      clientsScheduledController.item.isEmpty
                                          ? 'Cliente en espera'
                                          : 'Atendiendo ${clientsScheduledController.item.length} cliente(s)',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(255, 82, 81, 81),
                                      ),
                                    ),
                                  ),
                                ),

                                /*CRONOMETRO*/ Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //AQUI MUESTRA LOS TIMER DE LOS CLIENTES QUE ESTE ATENDIENDO
                                          if (clientsScheduledController
                                              .item.isNotEmpty) ...[
                                            for (int i = 0;
                                                i <
                                                    clientsScheduledController
                                                        .item.length;
                                                i++) ...[
                                              cardTimer(
                                                clientsList[
                                                        clientsScheduledController
                                                            .item[i]]!
                                                    .reservation_id,
                                                i,
                                                clientsList[
                                                        clientsScheduledController
                                                            .item[i]]!
                                                    .attended,
                                                clientsList[
                                                        clientsScheduledController
                                                            .item[i]]!
                                                    .car_id,
                                                clientsList[
                                                        clientsScheduledController
                                                            .item[i]]!
                                                    .client_image,
                                                UniqueKey(),
                                                clientsList[
                                                        clientsScheduledController
                                                            .item[i]]!
                                                    .client_name,
                                                clientsScheduledController,
                                                animationCont[
                                                    clientsScheduledController
                                                        .item[i]]!,
                                              ),
                                            ],
                                          ]
                                          //SI NO ESTA ATENDIENDOA NADIE Y HAY GENTE EN LA COLA ESPERANDO CARGA EL TIMER INICIAL
                                          else if (clientsScheduledController
                                                  .clientsScheduledNext !=
                                              null) ...[
                                            //AQUI VERIFICO SI YA ESCANEO EL CODIGO QR
                                            if (loginController
                                                        .codigoQrValid() ==
                                                    true &&
                                                clientsScheduledController
                                                    .item.isEmpty) ...[
                                              cardTimer2(
                                                UniqueKey(),
                                                'Esperando',
                                                clientsScheduledController,
                                                clientsScheduledController
                                                    .animationControllerInitial!,
                                              ),
                                            ] else ...[
                                              const Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 35,
                                                    ),
                                                    Text(
                                                      'Debe de escanear el código Qr ',
                                                      style: TextStyle(
                                                          // color: Colors.white,
                                                          color: Color.fromARGB(
                                                              255, 39, 39, 39),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      'para atender clientes',
                                                      style: TextStyle(
                                                          //color: Colors.white,
                                                          color: Color.fromARGB(
                                                              255, 39, 39, 39),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 45,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]
                                          ] else ...[
                                            const SizedBox(
                                              height: 45,
                                            ),
                                          ]
                                        ]),
                                  ),
                                  //FIN CLIENTES QUE ESTAN EN COLA
                                ),
                                //todo CLIENTES QUE ESTAN EN COLA

                                //FIN CLIENTES QUE ESTAN EN COLA
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 80,
                          ),
                  ),
                  clientsScheduledController.boolFilterShowNext
                      ? cardClientTails(clientsScheduledController, context,
                          firstName, animationCont)
                      :

                      //si hubiera algien en cola
                      (clientsScheduledController
                                  .clientsScheduledListLengthTail >
                              0)
                          ? const Column(
                              children: [
                                Text(
                                  'Cliente atendiéndose',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 81, 81),
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Esperando para mostrar el siguiente',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 81, 81),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : const Text('No hay clientes en cola',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color.fromARGB(255, 82, 81, 81),
                              )),
                ],
              )),
          Expanded(
              flex: 13, // 85% del espacio disponible para esta parte
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 82, 81, 81),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            loginController.setIsLoading == true
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFDAE2A),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(''),
                            Text('                        '),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.46), //Tamaño de los Cards
                                  height: loginController.androidInfoWidth! >=
                                          867.42 //propiedades de telefone
                                      ? (MediaQuery.of(context).size.height *
                                          0.198)
                                      : (MediaQuery.of(context).size.height *
                                          0.170),
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFF19CF9E),
                                      const Color.fromARGB(255, 231, 233, 233),
                                      'Agenda',
                                      'Clientes Agendados',
                                      Icons.perm_contact_calendar),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Get.dialog(
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    ); //Get.back();
                                    await coexCont.fetchEstadist0();
                                    pagesConfigC.onTabTapped(
                                        3); //index = 3 -> /StatisticPage
                                  },
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFF4470F3),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Estadísticas',
                                      'Revisa Tus Ingresos',
                                      Icons.bar_chart),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.height * 0.01),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFFFF6750),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Notificaciones',
                                      'Tus Notificaciones',
                                      Icons.notifications),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: cartsHome(
                                      context,
                                      12,
                                      const Color(0xFFFDAE2A),
                                      Color.fromARGB(255, 231, 233, 233),
                                      'Convivencia',
                                      'Cumplimiento de Reglas',
                                      Icons.star),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      );
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

  Padding cardClientTails(
      ClientsScheduledController clientsScheduledController,
      BuildContext context,
      String firstName,
      List<AnimationController?> animationCont) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: clientsScheduledController.clientsScheduledNext != null
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.115),
                      width: (MediaQuery.of(context).size.width * 0.20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // Color blanco para el borde
                          width:
                              1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                        ),
                        color: Color(0xFFFF6750),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18)),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(
                              0xFFFF6750), // Color de fondo en verde
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16.0), // Ajusta el radio según tus necesidades
                          ),
                        ),
                        onPressed: () {
                          if (loginController.codigoQrValid() == true) {
                            // int resulButton = 0;
                            // resulButton = loginController.handleButtonClick(
                            //     clientsScheduledController
                            //         .clientsScheduledNext!.reservation_id);
                            // if (resulButton == 1) {
                            clientsScheduledController.acceptOrRejectClient(
                                clientsScheduledController
                                    .clientsScheduledNext!.reservation_id,
                                3);
                            //}
                          } else {
                            Get.snackbar(
                              'Mensaje',
                              'Debe de escanear el código Qr de entrada',
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor:
                                  const Color.fromARGB(118, 255, 255, 255),
                              showProgressIndicator: true,
                              progressIndicatorBackgroundColor:
                                  const Color.fromARGB(255, 203, 205, 209),
                              progressIndicatorValueColor:
                                  const AlwaysStoppedAnimation(
                                      Color(0xFFFDAE2A)),
                              overlayBlur: 3,
                            );
                          }
                        },
                        child: Icon(
                          MdiIcons.thumbDownOutline,
                          color: Colors.white,
                          size: (MediaQuery.of(context).size.height * 0.04),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.115),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color:
                                          const Color.fromARGB(255, 43, 44, 49),
                                      size: 22,
                                    ),
                                    Text(
                                      firstName,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      //AQUI ETSA EL TIEMPO TOTAL DEL SERVICIO
                                      (clientsScheduledController
                                          .clientsScheduledNext!.total_time),
                                      style: const TextStyle(
                                        height: 1.2,
                                        fontSize: 16,
                                        color: Color.fromARGB(180, 0, 0, 0),
                                      )),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: clientsScheduledController
                                            .serviceCustomerSelected.length >
                                        2
                                    ? 2
                                    : clientsScheduledController
                                        .serviceCustomerSelected.length,
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              MdiIcons.menu,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              clientsScheduledController
                                                  .serviceCustomerSelected[
                                                      index]
                                                  .name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.115),
                      width: (MediaQuery.of(context).size.width * 0.20),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFF19CF9E),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18))),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(
                              0xFF19CF9E), // Color de fondo en verde
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16.0), // Ajusta el radio según tus necesidades
                          ),
                        ),
                        onPressed: () async {
                          //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                          if (loginController.codigoQrValid() == true) {
                            int resulButton = 0;
                            resulButton = loginController.handleButtonClick(
                                clientsScheduledController
                                    .clientsScheduledNext!.reservation_id);
                            if (resulButton == 1) {
                              //aqui manda aceptar, es decir atender este cliente
                              clientsScheduledController.clientsWaiting(false);
                              // detengo el timer de 2 minutos
                              clientsScheduledController
                                  .animationControllerInitial!
                                  .stop();
                              clientsScheduledController
                                  .animationControllerInitial!
                                  .reset();
                              // detengo todos los timers que deben detenerse
                              for (int j = 0;
                                  j < clientsScheduledController.itemDel.length;
                                  j++) {
                                animationCont[
                                        clientsScheduledController.itemDel[j]]!
                                    .stop();
                                animationCont[
                                        clientsScheduledController.itemDel[j]]!
                                    .reset();
                              }
                              await clientsScheduledController
                                  .newClientAttended(
                                      clientsScheduledController
                                          .clientsScheduledNext!,
                                      clientsScheduledController.availability);

                              //
                              //
                              //
                              //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                              if (clientsScheduledController.busyClock == 0) {
                                animationCont[0]!.duration = Duration(
                                    seconds: clientsScheduledController
                                        .timeClientsAttended1!);
                                animationCont[0]!.forward();
                              } else if (clientsScheduledController.busyClock ==
                                  1) {
                                animationCont[1]!.duration = Duration(
                                    seconds: clientsScheduledController
                                        .timeClientsAttended2!);
                                animationCont[1]!.forward();
                              } else if (clientsScheduledController.busyClock ==
                                  2) {
                                animationCont[2]!.duration = Duration(
                                    seconds: clientsScheduledController
                                        .timeClientsAttended3!);
                                animationCont[2]!.forward();
                              } else if (clientsScheduledController.busyClock ==
                                  3) {
                                animationCont[3]!.duration = Duration(
                                    seconds: clientsScheduledController
                                        .timeClientsAttended4!);
                                animationCont[3]!.forward();
                              }

                              //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                              await clientsScheduledController
                                  .acceptOrRejectClient(
                                      clientsScheduledController
                                          .clientsScheduledNext!.reservation_id,
                                      1);
                            }
                          } else {
                            Get.snackbar(
                              'Mensaje',
                              'Debe de escanear el código Qr de entrada',
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor:
                                  const Color.fromARGB(118, 255, 255, 255),
                              showProgressIndicator: true,
                              progressIndicatorBackgroundColor:
                                  const Color.fromARGB(255, 203, 205, 209),
                              progressIndicatorValueColor:
                                  const AlwaysStoppedAnimation(
                                      Color(0xFFFDAE2A)),
                              overlayBlur: 3,
                            );
                          }
                        },
                        child: Icon(
                          MdiIcons.thumbUpOutline,
                          color: Colors.white,
                          size: (MediaQuery.of(context).size.height * 0.04),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<LoginController>(builder: (controllerLogin) {
                  return const Row(
                    children: [
                      Text('No hay clientes en cola',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color.fromARGB(255, 82, 81, 81),
                          )),
                    ],
                  );
                }),
              ),
      ),
    );
  }

  //todo9
  cardTimer(
    int idreservation,
    int index,
    int attend,
    int carrId,
    String imag,
    Key uniqueKey,
    String name,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";

    return InkWell(
      onTap: () async {
        {
          //VA A EJECUTARSE SI NO ESTA CON EL TECNICO
          int resulButton = 0;
          resulButton = loginController.handleButtonClickModal(idreservation);
          if (resulButton == 1) {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            );
            //limpio la lista que controla que se de un solo click al seleccionar los servicios
            loginController.inTheClock(true);
            loginController.handleButtonClickServiceClear();
            serviceControll.clearSelectService();

            if (attend != 4) {
              // aqui selecciono el cliente
              await clientsScheduledController.metodsClients(
                  index, carrId, idreservation, name, imag);
              //todo FIN esto estaba en la pagina del modal al dar en Ver carrito
              await chopCont.loadDataInitiallyNecessary().then((_) async {
                await clientsScheduledController
                    .searchForCustomerServices(carrId)
                    .then((_) {
                  loginController.setHandleButtonClickModal();
                  String clientName = name;
                  String urlImage = imag;
                  int reservationId = idreservation;
                  int carId = carrId;
                  //   _mostrarBottomSheet(          context);
                  //  showMyDialog(context);
                  print(
                      'LISTA2 _fetchServiceList Limpiando clientName:$clientName...reservationId:$reservationId....carId:$carId....urlImage:$urlImage');
                  Get.back();
                  //Get.toNamed('/servicesProductsPage');
                  pagesConfigC.onTabTapped(1); //index = 1 -> /Clients
                });
              });
            }
          } //cierre del if de comprobacion que no lo llame vairas veces
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: Column(
          children: [
            Container(
              width: (clientsScheduledController.boolFilterShowNext == false &&
                          clientsScheduledController
                                  .clientsScheduledListLengthTail >
                              0) ||
                      (clientsScheduledController
                              .clientsScheduledListLengthTail ==
                          0)
                  ? 130
                  : 110,
              height: (clientsScheduledController.boolFilterShowNext == false &&
                          clientsScheduledController
                                  .clientsScheduledListLengthTail >
                              0) ||
                      (clientsScheduledController
                              .clientsScheduledListLengthTail ==
                          0)
                  ? 130
                  : 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   color: Color.fromARGB(255, 75, 24, 2),
                // ),
                color: const Color(0xFFFDAE2A),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Center(
                  child: AnimatedBuilder(
                    key: uniqueKey,
                    animation: _animationController,
                    builder: (context, child) {
                      final value = _animationController.value;
                      final remainingSeconds =
                          (_animationController.duration!.inSeconds -
                                  (_animationController.duration!.inSeconds *
                                      value))
                              .ceil();
                      int minutes = remainingSeconds ~/
                          60; // Calcula los minutos restantes
                      int seconds = remainingSeconds %
                          60; // Calcula los segundos restantes

                      if (seconds < 10) {
                        segundos = "0";
                      } else {
                        segundos = "";
                      }

                      if (minutes == 0 && seconds == 0) {
                        firstName = 'Terminó';
                        colorInicial = Colors.red;
                        colorInicialCirculo = Colors.white;
                        fontSizeText = 10;
                      }

                      return SizedBox(
                        width: clientsScheduledController.sizeClock,
                        height: clientsScheduledController.sizeClock,
                        child: Stack(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                    startAngle: 0.0,
                                    endAngle: 3.14 * 2, //twoPi
                                    stops: [value, value],
                                    // 0.0 , 0.5 , 0.5 , 1.0
                                    center: Alignment.center,
                                    colors: [
                                      Colors.white,
                                      Color.fromARGB(255, 92, 91, 91)
                                          .withAlpha(100)
                                    ]).createShader(rect);
                              },
                              child: Container(
                                width: clientsScheduledController.sizeClock,
                                height: clientsScheduledController.sizeClock,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: Image.asset(
                                                "assets/images/radial_scale.png")
                                            .image)),
                              ),
                            ),
                            Center(
                              child: Container(
                                width:
                                    (clientsScheduledController.sizeClock) - 40,
                                height:
                                    (clientsScheduledController.sizeClock) - 40,
                                decoration: BoxDecoration(
                                    color: colorInicialCirculo,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$minutes :',
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04), //todo2
                                              fontFamily: GoogleFonts.orbitron()
                                                  .fontFamily,
                                              color: colorInicial,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          "$segundos$seconds",
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                              color: colorInicial,
                                              fontFamily: GoogleFonts.orbitron()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                firstName,
                style: TextStyle(
                    fontSize: 18,
                    height: 1.3,
                    color: Color(0xFFFDAE2A),
                    fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //todo9
  cardTimer2(
    Key uniqueKey,
    String name,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        children: [
          Container(
            width: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 110,
            height: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // border: Border.all(
              //   color: Color.fromARGB(255, 75, 24, 2),
              // ),
              color: const Color(0xFFFDAE2A),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: AnimatedBuilder(
                  key: uniqueKey,
                  animation: _animationController,
                  builder: (context, child) {
                    final value = _animationController.value;
                    final remainingSeconds = (_animationController
                                .duration!.inSeconds -
                            (_animationController.duration!.inSeconds * value))
                        .ceil();
                    int minutes =
                        remainingSeconds ~/ 60; // Calcula los minutos restantes
                    int seconds =
                        remainingSeconds % 60; // Calcula los segundos restantes

                    if (seconds < 10) {
                      segundos = "0";
                    } else {
                      segundos = "";
                    }

                    if (minutes == 0 && seconds == 0) {
                      firstName = 'Terminó';
                      colorInicial = Colors.red;
                      colorInicialCirculo = Colors.white;
                      fontSizeText = 10;
                    }

                    return SizedBox(
                      width: clientsScheduledController.sizeClock,
                      height: clientsScheduledController.sizeClock,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2, //twoPi
                                  stops: [value, value],
                                  // 0.0 , 0.5 , 0.5 , 1.0
                                  center: Alignment.center,
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 92, 91, 91)
                                        .withAlpha(100)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: clientsScheduledController.sizeClock,
                              height: clientsScheduledController.sizeClock,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.asset(
                                              "assets/images/radial_scale.png")
                                          .image)),
                            ),
                          ),
                          Center(
                            child: Container(
                              width:
                                  (clientsScheduledController.sizeClock) - 40,
                              height:
                                  (clientsScheduledController.sizeClock) - 40,
                              decoration: BoxDecoration(
                                  color: colorInicialCirculo,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$minutes :',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04), //todo2
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            color: colorInicial,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "$segundos$seconds",
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                            color: colorInicial,
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: firstName == 'Esperando'
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        '$firstName...',
                        style: TextStyle(
                            fontSize: 10,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w900),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        firstName,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w600),
                      ),
                    )),
        ],
      ),
    );
  }

  Container cartsHome(
      BuildContext context,
      double borderRadiusValue,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.46), //Tamaño de los Cards
      height:
          loginController.androidInfoWidth! >= 867.42 //propiedades de telefone
              ? (MediaQuery.of(context).size.height * 0.198)
              : (MediaQuery.of(context).size.height * 0.170),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorVariable, // Color de fondo en verde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadiusValue), // Ajusta el radio según tus necesidades
          ),
        ),
        onPressed: () async {
          if (titleCart == 'Agenda') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();

            await clientsScheduledController.fetchClientsScheduled(
                loginController.idProfessionalLoggedIn,
                loginController.branchIdLoggedIn,
                'Agenda-Card');
            Get.back();
            pagesConfigC.onTabTapped(1); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Convivencia') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            // controllerLogin.setIsLoadingFor(true);
            await coexistenceController.fetchCoexistenceList();
            Get.back();
            pagesConfigC.onTabTapped(4); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Estadísticas') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await coexCont.fetchEstadist0();
            Get.back();
            pagesConfigC.onTabTapped(3); //index = 3 -> /StatisticPage
          }
          if (titleCart == 'Notificaciones') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            String typeEnv = '';

            if (loginController.chargeUserLoggedIn == 'Barbero y Encargado') {
              if (loginController.switchValue == false) //'Barbero'
              {
                typeEnv = 'Barbero';
              } else {
                typeEnv = 'Encargado';
              }
            } else {
              typeEnv = 'Barbero';
            }

            await notiController.fetchNotificationList(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn,
                typeEnv,
                'Cart home');

            pagesConfigC.onTabTapped(2); //index = 2 -> /NotificationsPageProf
            Get.back();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 20, // Tamaño del CircleAvatar
                  backgroundColor:
                      colorBottom, // Color de fondo del CircleAvatar
                  child: Icon(
                    iconCart, // Icono que deseas mostrar
                    size: 30, // Tamaño del icono
                    color: colorVariable, // Color del icono
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleCart,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.4),
                  ),
                  Text(
                    descriptionTitleCart,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.5,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
