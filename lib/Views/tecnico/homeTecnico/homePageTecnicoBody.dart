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
import 'package:turnopro_apk/env.dart';

class HomePageTecnicoBody extends StatefulWidget {
  const HomePageTecnicoBody({super.key});

  @override
  State<HomePageTecnicoBody> createState() => _HomePageTecnicoBodyState();
}

class _HomePageTecnicoBodyState extends State<HomePageTecnicoBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController? _animationControllerInitialT;

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
    _animationControllerInitialT = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );

// Inicia la animación
    _animationControllerInitialT!.addStatusListener((status) {
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

        // La animación ha llegado al final, reiniciar
        _animationControllerInitialT!.reset();
        _animationControllerInitialT!.forward();
      }
    });

    _animationTechnicalController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _animationControllerInitialT!.dispose();
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
    _timer3 = Timer.periodic(const Duration(seconds: 13), (Timer timer) {
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
    _timer2 = Timer.periodic(const Duration(seconds: 19), (Timer timer) {
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

      _animationControllerInitialT!.forward();

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
                    clientsScheduledController.clientsTechnicalLength > 0
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
                                          if (controllerclient
                                                      .clientsAttendedTechnical !=
                                                  null &&
                                              clientsScheduledController
                                                      .quantityClientAttendedTechnical !=
                                                  0) ...[
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
                                              controllerclient.clientsAttendedTechnical ==
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
                                                  'Esperando...',
                                                  controllerclient,
                                                  _animationControllerInitialT!,
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
                                          ] else if (controllerclient
                                                  .clientsNextTechnical ==
                                              null) ...[
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.attribution_sharp),
                                                Text('No hay nadie en cola.'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
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
                                left: 8, top: 8, right: 8, bottom: 6),
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
                                                  controllerclient
                                                      .acceptClientTechnical(
                                                          controllerclient
                                                              .clientsNextTechnical!
                                                              .reservation_id,
                                                          33);
                                                  // }
                                                } else {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Debe de escanear el código Qr de entrada',
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(
                                                            255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(
                                                            Color(0xFFF18254)),
                                                    overlayBlur: 3,
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                MdiIcons.thumbDownOutline,
                                                color: Colors.white,
                                                size: (MediaQuery.of(context)
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, top: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Icon(
                                                        Icons.person,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 43, 44, 49),
                                                        size: 22,
                                                      ),
                                                      Text(
                                                        firstName,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                            height: 1.0,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            color:
                                                                Color.fromARGB(
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
                                                color: const Color(0xFF19CF9E),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(18))),
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
                                                    // detengo todos los timers que deben detenerse
                                                    _animationControllerInitialT!
                                                        .stop();
                                                    _animationControllerInitialT!
                                                        .reset();

                                                    _animationTechnicalController1!
                                                        .stop();
                                                    _animationTechnicalController1!
                                                        .reset();
                                                    //
                                                    //todo FALTA QUE SE MUESTRE EL RELOJ
                                                    //
                                                    _animationTechnicalController1!
                                                            .duration =
                                                        const Duration(
                                                            seconds:
                                                                300); //por ahora 5min
                                                    /* Duration(
                                                          seconds: controllerclient
                                                              .convertDateSecons(
                                                                  controllerclient
                                                                      .clientsAttendedTechnical!
                                                                      .total_time));*/
                                                    _animationTechnicalController1!
                                                        .forward();

                                                    //el valor 1 es que es que le va atender y por ende va ser el que esta atendiendo
                                                    controllerclient
                                                        .acceptClientTechnical(
                                                            controllerclient
                                                                .clientsNextTechnical!
                                                                .reservation_id,
                                                            5);
                                                  }
                                                } else {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Debe de escanear el código Qr de entrada',
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(
                                                            255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(
                                                            Color(0xFFF18254)),
                                                    overlayBlur: 3,
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                MdiIcons.thumbUpOutline,
                                                color: Colors.white,
                                                size: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    ),
                            ),
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
                              GestureDetector(
                                onTap: () async {
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  await clientsScheduledController
                                      .fetchClientsTechnical(
                                          loginController.branchIdLoggedIn);
                                  pagesConfigC
                                      .onTabTapped(1); //index = 1 -> /Clients
                                  Get.back();
                                },
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
                                  if (loginController.idProfessionalLoggedIn !=
                                          null &&
                                      loginController.branchIdLoggedIn !=
                                          null &&
                                      (loginController.chargeUserLoggedIn ==
                                          "Tecnico")) {
                                    //await Future.delayed(Duration(seconds: 1));
                                    //Buscar notificaciones
                                    await notiController.fetchNotificationList(
                                        loginController.branchIdLoggedIn,
                                        loginController.idProfessionalLoggedIn,
                                        'Tecnico',
                                        'Cart-home');
                                  }
                                  pagesConfigC
                                      .onTabTapped(2); //index = 1 -> /Clients
                                  Get.back();
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFF4470F3),
                                    Color.fromARGB(255, 231, 233, 233),
                                    'Notificaciones',
                                    'Tus Notificaciones',
                                    Icons.notifications),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.01),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  pagesConfigC.onTabTapped(
                                      3); //index = 3 -> /StatisticPage
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFFFF6750),
                                    Color.fromARGB(255, 231, 233, 233),
                                    'Estadísticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
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
                                  // controllerLogin.setIsLoadingFor(true);
                                  await coexistenceController
                                      .fetchCoexistenceList();
                                  pagesConfigC.onTabTapped(
                                      4); //index = 4 -> /CoexistencePage
                                  Get.back();
                                },
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
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF2B3141),
                                              fontWeight: FontWeight.bold)),
                                      Text('CLIENTE',
                                          style: TextStyle(
                                              color: Color(0xFF2B3141),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
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
                                          vertical: 0, horizontal: 26.0),
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
                                          vertical: 0, horizontal: 26.0),
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
                                    await clientsScheduledController
                                        .acceptClientTechnical(
                                            clientsScheduledController
                                                .clientsAttendedTechnical!
                                                .reservation_id,
                                            11);
                                    //AQUI ENVIAR NOTIFICACION AL PROFESIONAL QUE YA VA EL CLIENTE DE VUELTA PARA ACABAR EL SERVICIO
                                    notiController.storeNotification(
                                        'Cliente Regresando',
                                        loginController.branchIdLoggedIn,
                                        clientsScheduledController
                                            .clientsAttendedTechnical!
                                            .professional_id,
                                        ' El cliente ${clientsScheduledController.clientsAttendedTechnical!.client_name} ya está disponible para que continúes con el servicio',
                                        'Barbero');
                                    Get.back();
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

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";

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
      height: (MediaQuery.of(context).size.height * 0.174),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 20, // Tamaño del CircleAvatar
                backgroundColor: colorBottom, // Color de fondo del CircleAvatar
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
                      height: 0.2),
                ),
                Text(
                  descriptionTitleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
