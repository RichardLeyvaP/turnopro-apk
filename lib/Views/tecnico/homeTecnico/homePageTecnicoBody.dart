import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/env.dart';

class HomePageTecnicoBody extends StatefulWidget {
  const HomePageTecnicoBody({super.key});

  @override
  State<HomePageTecnicoBody> createState() => _HomePageTecnicoBodyState();
}

class _HomePageTecnicoBodyState extends State<HomePageTecnicoBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController? _animationTechnicalController1;

  final ClientsTechnicalController clientsScheduledController =
      Get.find<ClientsTechnicalController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();
  final NotificationController notiController =
      Get.find<NotificationController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    clientsScheduledController
        .fetchClientsTechnical(loginController.branchIdLoggedIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callTimerTec();
      callTimerTec2();
      callTimerTecNotification();
    });

    //INICIALIZANDO CONTROLES DE LOS RELOJES
    clientsScheduledController.animationControllerInitialT =
        AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );

// Inicia la animación
    clientsScheduledController.animationControllerInitialT!
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (clientsScheduledController.noncomplianceProfessional['Tiempo'] !=
            0) {
          //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
          String type = 'Tiempo';
          int branchId = loginController.branchIdLoggedIn!;
          int professionalId = loginController.idProfessionalLoggedIn!;
          int estado = 0; //es que incumplió
          clientsScheduledController.changeNoncomplianceTecnhical(
              type, branchId, professionalId, estado);
          //aqui llamar e insertar en las notificacione sque incumplio esta convivencia
          notiController.storeNotification(
              'Incumplimiento de convivencia',
              branchId,
              professionalId,
              'Tu tiempo de espera de 3 minutos para seleccionar al nuevo cliente en cola se ha agotado.',
              'Tecnico');
        }
        LocalStorage.prefs.setBool('convivenciaIncumplidaT', true);
        LocalStorage.prefs.setInt('valueClockIni', 180);
        clientsScheduledController.setTotalTimeInitialTec(180);
        LocalStorage.prefs.setBool('valueClockActivT', false);
        // clientsScheduledController.animationControllerInitialT =
        //     AnimationController(
        //   vsync: this,
        //   duration:
        //       Duration(seconds: clientsScheduledController.totalTimeInitial),
        // );
        // La animación ha llegado al final, reiniciar
        clientsScheduledController.animationControllerInitialT!.reset();
        clientsScheduledController.animationControllerInitialT!.forward();
      }
    });

    if (LocalStorage.prefs.getBool('valueClockTec1ActivT') != null) {
      bool activeClock = LocalStorage.prefs.getBool('valueClockTec1ActivT')!;
      if (activeClock) {
        //si es true hay clientes atendiendose
//obtengo el tiempo en el que esta
        int timeAct = LocalStorage.prefs.getInt('valueClockTec1')!;
        if (timeAct < 0) {
          timeAct = 2;
        }
        _animationTechnicalController1 = AnimationController(
          vsync: this,
          duration: Duration(seconds: timeAct),
        );
        _animationTechnicalController1!.forward();
      } else {
        //si es false simplemente creo e inicializo el control para ser utilizado proximamente
        _animationTechnicalController1 = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 10),
        );
      }
    } else {
      //si es null simplemente creo e inicializo el control para ser utilizado proximamente
      _animationTechnicalController1 = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      );
    }
  }

  Future<void> saveData() async {
    if (LocalStorage.prefs.getBool('valueClockActivT') == true) {
      int valueClock = getTimeRemaining();
      int valueSave = valueClock;
      await LocalStorage.prefs.setInt('valueClockIni', valueSave);

      print('--este es el value del clok... ->Value guardado:$valueSave');
    }

//si el clock de cliente atendido esta activo
    if (LocalStorage.prefs.getBool('valueClockTec1ActivT') == true) {
      int valueClock = getTimeRemainingAten();
      int valueSave = valueClock;
      await LocalStorage.prefs.setInt('valueClockTec1', valueSave);
    }
  }

  int getTimeRemaining() {
    if (clientsScheduledController.animationControllerInitialT != null) {
      return (clientsScheduledController.totalTimeInitial -
              (clientsScheduledController.animationControllerInitialT!.value *
                  clientsScheduledController.totalTimeInitial))
          .round();
    } else {
      return 180;
    }
  }

  int getTimeRemainingAten() {
    int timeAct = LocalStorage.prefs.getInt('valueClockTec1')!;
    if (_animationTechnicalController1 != null) {
      return (timeAct - (_animationTechnicalController1!.value * timeAct))
          .round();
    } else {
      return 180;
    }
  }

  int obtenerHoraActualEnSegundos() {
    DateTime ahora = DateTime.now();
    int segundos = ahora.hour * 3600 + ahora.minute * 60 + ahora.second;
    return segundos;
  }

  @override
  void dispose() {
    clientsScheduledController.animationControllerInitialT!.dispose();
    _animationTechnicalController1!.dispose();
    // Asegúrate de cancelar el temporizador al eliminar el widget
    _timer?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  Timer? _timer;
  Timer? _timer2;
  Timer? _timer3;

  void callTimerTec() {
    // Cancela cualquier temporizador existente para evitar duplicaciones

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      print('callTimerTec1');
      if (clientsScheduledController.boolFilterShowNextTecnhical == true &&
          clientsScheduledController.listClientReal > 0 &&
          (loginController.codigoQrValid() == true) &&
          !clientsScheduledController.idClientsEspera.contains(
              clientsScheduledController.clientsAttendedTechnical!.client_id)) {
        notiController.storeNotification(
            'Clientes en cola',
            loginController.branchIdLoggedIn,
            loginController.idProfessionalLoggedIn,
            'Recuerda que tienes clientes en cola.¡No los mantengas esperando por mucho tiempo!',
            'Tecnico');
        //agregar el id de ese cliente en un array para no mandar mas ese mensaje con ese cliente en espera
        if (clientsScheduledController.clientsAttendedTechnical != null) {
          clientsScheduledController.setNotificateClient(
              clientsScheduledController.clientsAttendedTechnical!.client_id!);
        }
      }
    });
  }

  void callTimerTecNotification() {
    // Cancela cualquier temporizador existente para evitar duplicaciones

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer3 = Timer.periodic(const Duration(seconds: 9), (Timer timer) {
      saveData();
      print('callTimerTec4');

      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          (loginController.chargeUserLoggedIn == "Tecnico")) {
        //await Future.delayed(Duration(seconds: 1));
        //Buscar notificaciones
        print('callTimerTec 4-callTimerTecNotification');
        notiController.fetchNotificationList(loginController.branchIdLoggedIn,
            loginController.idProfessionalLoggedIn, 'Tecnico', 'callTimerTec');
      }
    });
  }

  void callTimerTec2() {
    // Cancela cualquier temporizador existente para evitar duplicaciones

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer2 = Timer.periodic(const Duration(seconds: 11), (Timer timer) {
      print('callTimerTec2');
      // actualizo la cola
      if (clientsScheduledController.showingServiceClientsTechnical == false &&
          loginController.branchIdLoggedIn != null &&
          loginController.chargeUserLoggedIn == "Tecnico") {
        //actualizo la cola del técnico
        clientsScheduledController
            .fetchClientsTechnical(loginController.branchIdLoggedIn);
      }
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ClientsTechnicalController>(builder: (controllerclient) {
      String firstName = '';
      // //todo AQUI DETENGO LOS TIMER QUE NO ESTAN VISIBLES

      if (controllerclient.clientsNextTechnical != null) {
        String fullName = controllerclient.clientsNextTechnical!.client_name!;
        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)
        firstName = partsName.isNotEmpty ? partsName[0] : "";
        // String secondName = partsName.length > 1 ? partsName[1] : "";
      }

      // clientsScheduledController.animationControllerInitialT!.forward();
      // LocalStorage.prefs.setBool('valueClockActivT', true);
      // int hAs = obtenerHoraActualEnSegundos();
      // LocalStorage.prefs.setInt('valueHoraAnt', hAs);

      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, top: 4, right: 12, bottom: 8),
                child: Column(
                  children: [
                    clientsScheduledController.clientsTechnicalLength > 0 &&
                            clientsScheduledController.listClientReal > 0
                        ? Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /*todo texto arriba */ Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      clientsScheduledController
                                                  .quantityClientAttendedTechnical ==
                                              0
                                          ? 'Cliente en espera'
                                          : 'Atendiendo al cliente',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(255, 82, 81, 81),
                                      ),
                                    ),
                                  ),
                                ),

                                /*CRONOMETRO*/ Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //AQUI MUESTRA LOS TIMER DE LOS CLIENTES QUE ESTE ATENDIENDO
                                          if ((controllerclient
                                                          .clientsAttendedTechnical !=
                                                      null &&
                                                  clientsScheduledController
                                                          .quantityClientAttendedTechnical !=
                                                      0) ||
                                              (clientsScheduledController
                                                      .clientAten !=
                                                  null)) ...[
                                            cardTimer(
                                                controllerclient
                                                    .clientsAttendedTechnical!,
                                                0,
                                                UniqueKey(),
                                                controllerclient
                                                    .clientsAttendedTechnical!
                                                    .client_name!,
                                                controllerclient,
                                                _animationTechnicalController1!,
                                                controllerclient
                                                    .clientsAttendedTechnical!
                                                    .client_image!),
                                          ]
                                          //SI NO ESTA ATENDIENDOA NADIE Y HAY GENTE EN LA COLA ESPERANDO CARGA EL TIMER INICIAL
                                          else if (controllerclient
                                                      .quantityClientAttendedTechnical ==
                                                  0 &&
                                              controllerclient
                                                      .clientsAttendedTechnical ==
                                                  null) ...[
                                            const SizedBox(
                                              height: 70,
                                            ),
                                          ] else if (controllerclient
                                                  .quantityClientAttendedTechnical ==
                                              0) ...[
                                            GetBuilder<LoginController>(
                                                builder: (logCont) {
                                              if (logCont.codigoQrValid() ==
                                                  true) {
                                                return cardTimer2(
                                                  UniqueKey(),
                                                  'Esperando',
                                                  controllerclient,
                                                  clientsScheduledController
                                                      .animationControllerInitialT!,
                                                );
                                              } else if (loginController
                                                      .usserPermissionQr ==
                                                  2) {
                                                return const Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Text(
                                                        'Debe de esperar la respuesta',
                                                        style: TextStyle(
                                                            // color: Colors.white,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    39,
                                                                    39,
                                                                    39),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        'a su solicitud',
                                                        style: TextStyle(
                                                            //color: Colors.white,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    39,
                                                                    39,
                                                                    39),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 45,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                      Text(
                                                        'Debe de escanear el código Qr ',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    39,
                                                                    39,
                                                                    39),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        'para atender clientes',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    39,
                                                                    39,
                                                                    39)),
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                          ]
                                        ]),
                                  ),
                                  //FIN CLIENTES QUE ESTAN EN COLA
                                ),
                                //todo CLIENTES QUE ESTAN EN COLA
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 100,
                          ),
                    //aqui mostarr el que le toca
                    controllerclient.boolFilterShowNextTecnhical
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 8, right: 0, bottom: 6),
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: controllerclient.clientsNextTechnical !=
                                        null
                                    ? Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Color blanco para el borde
                                                    width:
                                                        1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                                  ),
                                                  color: Color(0xFFFF6750),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(18)),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    if (loginController
                                                            .codigoQrValid() ==
                                                        true) {
                                                      /*  int resulButton = 0;
                                                    resulButton = loginController
                                                        .handleButtonClickTec(
                                                            controllerclient
                                                                .clientsNextTechnical!
                                                                .reservation_id);
                                                    if (resulButton == 1) {*/
                                                      notiController.storeNotification(
                                                          'Solicitud de rechazo',
                                                          loginController
                                                              .branchIdLoggedIn,
                                                          loginController
                                                              .idProfessionalLoggedIn,
                                                          'EL Técnico "${loginController.nameUserLoggedIn}" está rechazando al cliente "${clientsScheduledController.clientsNextTechnical!.client_name}"',
                                                          'Ambos'); //esto es para quele llegue a coordinador y encargado
                                                      //necesito un metodo igual que este pero que sea para el tecnico
                                                      loginController
                                                          .setCodigoQrValid(2);
                                                      controllerclient
                                                          .acceptClientTechnical(
                                                              controllerclient
                                                                  .clientsNextTechnical!
                                                                  .reservation_id,
                                                              33);
                                                      clientsScheduledController
                                                              .animationControllerInitialT =
                                                          AnimationController(
                                                        vsync: this,
                                                        duration: Duration(
                                                            seconds: 180),
                                                      );
                                                      // La animación ha llegado al final, reiniciar
                                                      clientsScheduledController
                                                          .animationControllerInitialT!
                                                          .reset();
                                                      clientsScheduledController
                                                          .animationControllerInitialT!
                                                          .stop();
                                                      // }
                                                    } else if (loginController
                                                            .usserPermissionQr ==
                                                        2) {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de esperar la respuesta a su solicitud',
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                118,
                                                                255,
                                                                255,
                                                                255),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                205,
                                                                209),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                    } else {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de escanear el código Qr de entrada',
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                118,
                                                                255,
                                                                255,
                                                                255),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                205,
                                                                209),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFF18254)),
                                                        overlayBlur: 3,
                                                      );
                                                    }
                                                  },
                                                  icon: Icon(
                                                    MdiIcons.thumbDownOutline,
                                                    color: Colors.white,
                                                    size:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30, top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                43,
                                                                44,
                                                                49),
                                                            size: 22,
                                                          ),
                                                          Text(
                                                            firstName,
                                                            softWrap: true,
                                                            style: const TextStyle(
                                                                height: 1.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(Icons.timer,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  180, 0, 0, 0),
                                                              size: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.018)),
                                                          Text(
                                                              //AQUI ETSA EL TIEMPO TOTAL DEL SERVICIO
                                                              ' ${(controllerclient.clientsNextTechnical!.total_time)}',
                                                              style:
                                                                  const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        180,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.115),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors
                                                          .white, // Color blanco para el borde
                                                      width:
                                                          1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                                    ),
                                                    color:
                                                        const Color(0xFF19CF9E),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                18))),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    if (loginController
                                                            .codigoQrValid() ==
                                                        true) {
                                                      int resulButton = 0;
                                                      resulButton = loginController
                                                          .handleButtonClickTec(
                                                              controllerclient
                                                                  .clientsNextTechnical!
                                                                  .reservation_id!);
                                                      if (resulButton == 1) {
                                                        //aqui inicia el tmer de cliente atendido
                                                        LocalStorage.prefs.setBool(
                                                            'valueClockTec1ActivT',
                                                            true);
                                                        LocalStorage.prefs
                                                            .setInt(
                                                                'valueClockTec1',
                                                                300);

                                                        _animationTechnicalController1!
                                                            .stop();
                                                        _animationTechnicalController1!
                                                            .reset();

                                                        //
                                                        //todo FALTA QUE SE MUESTRE EL RELOJ
                                                        //

                                                        //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                                                        await controllerclient
                                                            .acceptClientTechnical(
                                                                controllerclient
                                                                    .clientsNextTechnical!
                                                                    .reservation_id,
                                                                5);
                                                        _animationTechnicalController1!
                                                                .duration =
                                                            const Duration(
                                                                seconds:
                                                                    300); //por ahora 5min

                                                        _animationTechnicalController1!
                                                            .forward();
                                                        // detengo todos los timers que deben detenerse
                                                        LocalStorage.prefs.setBool(
                                                            'valueClockActivT',
                                                            false);
                                                        LocalStorage.prefs
                                                            .setInt(
                                                                'valueClockIni',
                                                                180);
                                                        clientsScheduledController
                                                            .animationControllerInitialT!
                                                            .stop();
                                                        clientsScheduledController
                                                            .animationControllerInitialT!
                                                            .reset();
                                                      }
                                                    } else if (loginController
                                                            .usserPermissionQr ==
                                                        2) {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de esperar la respuesta a su solicitud',
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                118,
                                                                255,
                                                                255,
                                                                255),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                205,
                                                                209),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                    } else {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de escanear el código Qr de entrada',
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                118,
                                                                255,
                                                                255,
                                                                255),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                205,
                                                                209),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFF18254)),
                                                        overlayBlur: 3,
                                                      );
                                                    }
                                                  },
                                                  icon: Icon(
                                                    MdiIcons.thumbUpOutline,
                                                    color: Colors.white,
                                                    size:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : clientsScheduledController
                                                .clientsTechnicalLength >
                                            0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GetBuilder<LoginController>(
                                                builder: (controllerLogin) {
                                              return const Column(
                                                children: [
                                                  Text(
                                                    'Esperando respuesta ',
                                                  ),
                                                  Text(
                                                    'de la solicitud de rechazo',
                                                  ),
                                                ],
                                              );
                                            }),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GetBuilder<LoginController>(
                                                builder: (controllerLogin) {
                                              return const Row(
                                                children: [
                                                  Text(
                                                    'No hay clientes en cola',
                                                  ),
                                                ],
                                              );
                                            }),
                                          )),
                          )
                        : controllerclient.clientsNextTechnical == null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GetBuilder<LoginController>(
                                    builder: (controllerLogin) {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No hay clientes en cola',
                                      ),
                                    ],
                                  );
                                }),
                              )
                            : const Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Cliente atendiéndose.',
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
                              ),
                    //FIN CLIENTES QUE ESTAN EN COLA
                  ],
                ),
              )),
          Expanded(
              flex: 14, // 85% del espacio disponible para esta parte
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 43, 44, 49),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cartsHome(
                                  context,
                                  12,
                                  const Color(0xFF19CF9E),
                                  const Color.fromARGB(255, 231, 233, 233),
                                  'Agenda',
                                  'Clientes Agendados',
                                  Icons.perm_contact_calendar),
                              cartsHome(
                                  context,
                                  12,
                                  const Color(0xFF4470F3),
                                  Color.fromARGB(255, 231, 233, 233),
                                  'Notificaciones',
                                  'Tus Notificaciones',
                                  Icons.notifications),
                            ],
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.01),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cartsHome(
                                  context,
                                  12,
                                  const Color(0xFFFF6750),
                                  Color.fromARGB(255, 231, 233, 233),
                                  'Estadísticas',
                                  'Revisa Tus Ingresos',
                                  Icons.bar_chart),
                              cartsHome(
                                  context,
                                  12,
                                  const Color(0xFFFDAE2A),
                                  Color.fromARGB(255, 231, 233, 233),
                                  'Convivencia',
                                  'Cumplimiento de Reglas',
                                  Icons.star),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ],
      );
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

  //todo9
  cardTimer(
      clientsL,
      int index,
      Key uniqueKey,
      String name,
      ClientsTechnicalController clientsScheduledController,
      AnimationController _animationController,
      String imageClient) {
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GetBuilder<LoginController>(builder: (_) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDAE2A),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'CLIENTE ATENDIDO',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              Colors.white, //fondo de la imagen
                                          child: ClipOval(
                                            child: Image.network(
                                              '${Env.apiEndpoint}/images/$imageClient',
                                              fit: BoxFit
                                                  .cover, // Ajusta la imagen para cubrir completamente el área
                                              width:
                                                  50, // Ancho deseado de la imagen dentro del círculo
                                              height: 50,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  // Si la imagen se carga correctamente, mostramos la imagen
                                                  return child;
                                                } else {
                                                  // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                                  return const CircularProgressIndicator(
                                                    color: Color(0xFFFDAE2A),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                                if (kDebugMode) {
                                                  return CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: Colors
                                                        .transparent, // Fondo transparente para que el borde sea visible
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/default_profile.jpg',
                                                        fit: BoxFit
                                                            .cover, // Ajusta la imagen para cubrir completamente el área
                                                        width:
                                                            50, // Ancho deseado de la imagen dentro del círculo
                                                        height:
                                                            50, // Alto deseado de la imagen dentro del círculo
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // Si no estamos en modo de depuración, mostramos un texto de error
                                                  return CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: Colors
                                                        .transparent, // Fondo transparente para que el borde sea visible
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/default_profile.jpg',
                                                        fit: BoxFit
                                                            .cover, // Ajusta la imagen para cubrir completamente el área
                                                        width:
                                                            50, // Ancho deseado de la imagen dentro del círculo
                                                        height:
                                                            50, // Alto deseado de la imagen dentro del círculo
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),

                                        //
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF2B3141),
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xFFFDAE2A)
                                            // Puedes agregar otras propiedades de estilo aquí si es necesario
                                            ),
                                        width: 82,
                                        height: 20,
                                        child: const Center(
                                          child: Text(
                                            'CLIENTE',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // const Text("          "),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 16.0),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 192, 191, 191)),
                                  ),
                                  onPressed: () async {
                                    // Lógica para enviar el comentario

                                    // Cerrar el primer modal
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.cancel,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 16.0),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF4470F3)),
                                  ),
                                  onPressed: () async {
                                    // Lógica para enviar el comentario

                                    Get.dialog(
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    ); //Get.back();
                                    String nameClient =
                                        clientsScheduledController
                                            .clientsAttendedTechnical!
                                            .client_name!;
                                    notiController.storeNotification(
                                        'Cliente Regresando',
                                        loginController.branchIdLoggedIn,
                                        clientsScheduledController
                                            .clientsAttendedTechnical!
                                            .professional_id,
                                        'El cliente ${clientsScheduledController.clientsAttendedTechnical!.client_name} ya está disponible para que continúes con el servicio',
                                        'Barbero');
                                    await clientsScheduledController
                                        .acceptClientTechnical(
                                            clientsScheduledController
                                                .clientsAttendedTechnical!
                                                .reservation_id,
                                            11);
                                    //aqui limpiar la variable que no deja cojer doble al cliente
                                    loginController.pressedButtonIdsTec.clear();
                                    //reseteo y lo dejo en punta para el proximo cliente
                                    _animationTechnicalController1!.stop();
                                    _animationTechnicalController1!.reset();

                                    //ponemos afalse la variable que nos indica que hay cliente atendiendose
                                    LocalStorage.prefs
                                        .setBool('valueClockTec1ActivT', false);
                                    LocalStorage.prefs
                                        .setBool('valueClockActivT', true);
                                    //y dejamos inicializada en 5 min para el nuevo cliente por atender
                                    LocalStorage.prefs
                                        .setInt('valueClockTec1', 300);
                                    //reiniciando el timer del inicio
                                    LocalStorage.prefs
                                        .setInt('valueClockIni', 180);
                                    clientsScheduledController
                                        .setTotalTimeInitialTec(180);
                                    clientsScheduledController
                                            .animationControllerInitialT =
                                        AnimationController(
                                      vsync: this,
                                      duration: Duration(seconds: 180),
                                    );
                                    // La animación ha llegado al final, reiniciar
                                    clientsScheduledController
                                        .animationControllerInitialT!
                                        .reset();
                                    clientsScheduledController
                                        .animationControllerInitialT!
                                        .forward();

                                    //AQUI ENVIAR NOTIFICACION AL PROFESIONAL QUE YA VA EL CLIENTE DE VUELTA PARA ACABAR EL SERVICIO

                                    Get.back();
                                    Get.snackbar(
                                      'Mensaje',
                                      'Finalizado servicio del cliente $nameClient',
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      backgroundColor: const Color.fromARGB(
                                          118, 255, 255, 255),
                                      showProgressIndicator: true,
                                      progressIndicatorBackgroundColor:
                                          const Color.fromARGB(
                                              255, 203, 205, 209),
                                      progressIndicatorValueColor:
                                          const AlwaysStoppedAnimation(
                                              Color(0xFFFDAE2A)),
                                      overlayBlur: 3,
                                    );
                                    // Cerrar el primer modal
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.check,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      const Text(
                                        'Aceptar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: Column(
          children: [
            Container(
              width: 130,
              height: 130,
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
                        width: clientsScheduledController.sizeClockTechnical,
                        height: clientsScheduledController.sizeClockTechnical,
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
                                width: clientsScheduledController
                                    .sizeClockTechnical,
                                height: clientsScheduledController
                                    .sizeClockTechnical,
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
                                width: (clientsScheduledController
                                        .sizeClockTechnical) -
                                    40,
                                height: (clientsScheduledController
                                        .sizeClockTechnical) -
                                    40,
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
    ClientsTechnicalController clientsScheduledController,
    AnimationController _animationController,
  ) {
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios
    bool isPaused =
        clientsScheduledController.animationControllerInitialT!.isAnimating;
    if (!isPaused) {
      clientsScheduledController.animationControllerInitialT!.forward();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
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
                      clientsScheduledController.animationControllerInitialT =
                          AnimationController(
                        vsync: this,
                        duration: Duration(seconds: 180),
                      );
                      // La animación ha llegado al final, reiniciar
                      clientsScheduledController.animationControllerInitialT!
                          .reset();
                      clientsScheduledController.animationControllerInitialT!
                          .forward();
                    }

                    return SizedBox(
                      width: clientsScheduledController.sizeClockTechnical,
                      height: clientsScheduledController.sizeClockTechnical,
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
                              width:
                                  clientsScheduledController.sizeClockTechnical,
                              height:
                                  clientsScheduledController.sizeClockTechnical,
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
                              width: (clientsScheduledController
                                      .sizeClockTechnical) -
                                  40,
                              height: (clientsScheduledController
                                      .sizeClockTechnical) -
                                  40,
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
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  '$name...',
                  style: const TextStyle(
                      fontSize: 10,
                      height: 1.3,
                      color: Color(0xFFFDAE2A),
                      fontWeight: FontWeight.w900),
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
      height: (MediaQuery.of(context).size.height * 0.174),
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
            await clientsScheduledController
                .fetchClientsTechnical(loginController.branchIdLoggedIn);
            pagesConfigC.onTabTapped(1); //index = 1 -> /Clients
            Get.back();
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
            pagesConfigC.onTabTapped(4); //index = 4 -> /CoexistencePage
            Get.back();
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
            await coexistenceController.fetchEstadist0();
            pagesConfigC.onTabTapped(3); //index = 3 -> /StatisticPage
            Get.back();
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
            if (loginController.idProfessionalLoggedIn != null &&
                loginController.branchIdLoggedIn != null &&
                (loginController.chargeUserLoggedIn == "Tecnico")) {
              //await Future.delayed(Duration(seconds: 1));
              //Buscar notificaciones
              await notiController.fetchNotificationList(
                  loginController.branchIdLoggedIn,
                  loginController.idProfessionalLoggedIn,
                  'Tecnico',
                  'Cart-home');
            }
            pagesConfigC.onTabTapped(2); //index = 1 -> /Clients
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
