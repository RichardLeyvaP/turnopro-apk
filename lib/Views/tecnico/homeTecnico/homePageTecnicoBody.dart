import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';

class HomePageTecnicoBody extends StatefulWidget {
  const HomePageTecnicoBody({super.key});

  @override
  State<HomePageTecnicoBody> createState() => _HomePageTecnicoBodyState();
}

class _HomePageTecnicoBodyState extends State<HomePageTecnicoBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController? _animationControllerInitial;

  AnimationController? _animationTechnicalController1;

  final ClientsTechnicalController clientsScheduledController =
      Get.find<ClientsTechnicalController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();
  NotificationController notiController = Get.find<NotificationController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    clientsScheduledController
        .fetchClientsTechnical(loginController.branchIdLoggedIn);
    iniciarLlamadaCada10Segundos();

    //INICIALIZANDO CONTROLES DE LOS RELOJES
    _animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );
    _animationControllerInitial!.forward();

// Inicia la animación
    _animationControllerInitial!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (clientsScheduledController
                .noncomplianceProfessional['initialTime'] !=
            0) {
          //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
          String type = 'initialTime';
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
              'Tiempo de espera agotado, solo tenias 3 minutos para escoger a un nuevo al cliente que tiene en cola esperando.');
        }

        // La animación ha llegado al final, reiniciar
        _animationControllerInitial!.reset();
        _animationControllerInitial!.forward();
      }
    });

    _animationTechnicalController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _animationControllerInitial!.dispose();
    _animationTechnicalController1!.dispose();
    // Asegúrate de cancelar el temporizador al eliminar el widget
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  void iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 20), (Timer timer) {
      // actualizo la cola
      if (clientsScheduledController.showingServiceClientsTechnical == false &&
          loginController.branchIdLoggedIn != null &&
          loginController.chargeUserLoggedIn == "Tecnico") {
        //solo
        print(
            'ESTOY HomePageTecnicoBody ACTUALIZANDO LA COLA CADA 10 SEGUNDOS (TECNICO) showingServiceClients = false');
        clientsScheduledController
            .fetchClientsTechnical(loginController.branchIdLoggedIn);
      }
      //todo REVISAR valor fijo
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
        String fullName = controllerclient.clientsNextTechnical!.client_name;
        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)
        firstName = partsName.isNotEmpty ? partsName[0] : "";
        // String secondName = partsName.length > 1 ? partsName[1] : "";
      }

      _animationControllerInitial!.forward();

      return Column(
        //Cart anaranjado grande inicial que tiene el cronometro
        children: [
          Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Color(0xFFF18254),
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
                                color: Colors.white),
                          ),
                        ),
                      ),

                      /*CRONOMETRO*/ Padding(
                        padding: const EdgeInsets.all(8.0),
                        //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //AQUI MUESTRA LOS TIMER DE LOS CLIENTES QUE ESTE ATENDIENDO
                                if (controllerclient.clientsAttendedTechnical !=
                                        null &&
                                    clientsScheduledController
                                            .quantityClientAttendedTechnical !=
                                        0) ...[
                                  cardTimer(
                                    UniqueKey(),
                                    controllerclient
                                        .clientsAttendedTechnical!.client_name,
                                    controllerclient,
                                    _animationTechnicalController1!,
                                  ),
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
                                  cardTimer(
                                    UniqueKey(),
                                    'Esperando...',
                                    controllerclient,
                                    _animationControllerInitial!,
                                  ),
                                ] else if (controllerclient
                                        .clientsNextTechnical ==
                                    null) ...[
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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

                      controllerclient.boolFilterShowNextTecnhical
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 6),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: controllerclient //todo1
                                            .clientsNextTechnical !=
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
                                                color: const Color(0xFFF18254),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  // Get.snackbar(
                                                  //   'Mensaje',
                                                  //   'Cancelar',
                                                  //   duration: const Duration(
                                                  //       milliseconds: 2000),
                                                  // );
                                                  // atender este cliente
                                                  //el valor 3 es que es que lo rechazo, por alguna razon no lo va a tender

                                                  /* controllerclient
                                                      .acceptOrRejectClient(
                                                          controllerclient
                                                              .clientsNextTechnical!
                                                              .reservation_id,
                                                          3);*/
                                                  controllerclient
                                                      .acceptClientTechnical(
                                                          controllerclient
                                                              .clientsNextTechnical!
                                                              .reservation_id,
                                                          3);
                                                },
                                                icon: Icon(
                                                  MdiIcons.thumbDown,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          color: Colors.black,
                                                          size: 22,
                                                        ),
                                                        Text(
                                                          firstName,
                                                          softWrap: true,
                                                          style:
                                                              const TextStyle(
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
                                                            (controllerclient
                                                                .clientsNextTechnical!
                                                                .total_time),
                                                            style:
                                                                const TextStyle(
                                                              height: 1.2,
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromARGB(180,
                                                                      0, 0, 0),
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
                                                  color: const Color.fromARGB(
                                                      255, 32, 32, 32),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: IconButton(
                                                onPressed: () async {
                                                  // Get.snackbar(
                                                  //   'Mensaje',
                                                  //   'Aceptar',
                                                  //   duration: const Duration(
                                                  //       milliseconds: 2000),
                                                  // );
                                                  //aqui manda aceptar, es decir atender este cliente

                                                  // detengo todos los timers que deben detenerse
                                                  _animationControllerInitial!
                                                      .stop();
                                                  _animationControllerInitial!
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
                                                },
                                                icon: Icon(
                                                  MdiIcons.thumbUp,
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
                                              Icon(
                                                Icons.person_off,
                                                color: Colors.white,
                                              ),
                                              Text('No hay clientes en cola',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  )),
                                            ],
                                          );
                                        }),
                                      ),
                              ),
                            )
                          : const Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Cliente atendiéndose.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Esperando para mostrar el siguiente',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                      //FIN CLIENTES QUE ESTAN EN COLA
                    ],
                  ),
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
                                color: Colors.black,
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
                                onTap: () {
                                  pagesConfigC
                                      .onTabTapped(1); //index = 1 -> /Clients
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFF2B3141),
                                    const Color.fromARGB(255, 231, 233, 233),
                                    'Agenda',
                                    'Clientes Agendados',
                                    Icons.perm_contact_calendar),
                              ),
                              InkWell(
                                onTap: () {
                                  pagesConfigC.onTabTapped(
                                      2); //index = 2 -> /NotificationsPageProf
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color.fromARGB(255, 81, 93, 117),
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
                                    const Color.fromARGB(255, 177, 174, 174),
                                    Color.fromARGB(255, 231, 233, 233),
                                    'Estadisticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
                              ),
                              InkWell(
                                onTap: () {
                                  pagesConfigC.onTabTapped(
                                      4); //index = 4 -> /CoexistencePage
                                },
                                child: cartsHome(
                                    context,
                                    12,
                                    const Color(0xFFF18254),
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
  Padding cardTimer(
    Key uniqueKey,
    String name,
    ClientsTechnicalController controllerclient,
    AnimationController _animationController,
  ) {
    String segundos = "";
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFF18254);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.035);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Center(
        child: AnimatedBuilder(
          key: uniqueKey,
          animation: _animationController,
          builder: (context, child) {
            final value = _animationController.value;
            final remainingSeconds = (_animationController.duration!.inSeconds -
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
              width: controllerclient.sizeClockTechnical,
              height: controllerclient.sizeClockTechnical,
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
                              colors: [Colors.white, Colors.grey.withAlpha(55)])
                          .createShader(rect);
                    },
                    child: Container(
                      width: controllerclient.sizeClockTechnical,
                      height: controllerclient.sizeClockTechnical,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  Image.asset("assets/images/radial_scale.png")
                                      .image)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: (controllerclient.sizeClockTechnical) - 40,
                      height: (controllerclient.sizeClockTechnical) - 40,
                      decoration: BoxDecoration(
                          color: colorInicialCirculo, shape: BoxShape.circle),
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
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
                                            0.05), //todo2
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                    color: colorInicial,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "$segundos$seconds",
                                style: TextStyle(
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
                                            0.05),
                                    color: colorInicial,
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              firstName,
                              style: TextStyle(
                                  fontSize: fontSizeText,
                                  color: colorInicial,
                                  fontWeight: FontWeight.w900),
                            ),
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
      height: (MediaQuery.of(context).size.height * 0.20),
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
                  color:
                      const Color.fromARGB(255, 26, 50, 82), // Color del icono
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
                      fontWeight: FontWeight.w600),
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
