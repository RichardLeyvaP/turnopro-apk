// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';

class HomeResponsibleBodyPages extends StatefulWidget {
  const HomeResponsibleBodyPages({super.key});

  @override
  State<HomeResponsibleBodyPages> createState() =>
      _HomeResponsibleBodyPagesState();
}

class _HomeResponsibleBodyPagesState extends State<HomeResponsibleBodyPages>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsCoordinatorController clientCorControl =
      Get.find<ClientsCoordinatorController>();
  final ClientsScheduledController clientsScheduleCont =
      Get.find<ClientsScheduledController>();
  final CoexistenceController coexistCont = Get.find<CoexistenceController>();

  final PagesConfigResponController pagesConfigReC =
      Get.find<PagesConfigResponController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();
  NotificationController notiController = Get.find<NotificationController>();
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadDataFirt();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callTimer1();
    });
  }

  @override
  void dispose() {
    // Asegúrate de cancelar el temporizador al eliminar el widget
    _timerResp?.cancel();
    super.dispose();
  }

  Timer? _timerResp;

  loadDataFirt() async {
    print('llamada timer encargado - loadDataFirt()');
    print(
        'llamada timer encargado branchIdLoggedIn: ${controllerLogin.branchIdLoggedIn}');
    print(
        'llamada timer encargado idProfessionalLoggedIn: ${controllerLogin.idProfessionalLoggedIn}');

    if (controllerLogin.branchIdLoggedIn != null &&
        controllerLogin.idProfessionalLoggedIn != null &&
        (controllerLogin.usserPermissionQr == 1 ||
            controllerLogin.usserPermissionQr == 2)) {
      notiController.fetchNotificationList(
          controllerLogin.branchIdLoggedIn,
          controllerLogin.idProfessionalLoggedIn,
          'Encargado',
          'loadDataFirt',
          loginController.tokenUserLoggedIn);
      if (loginController.chargeUserLoggedIn == "Barbero y Encargado") {
        notiController.fetchNotificationList(
            controllerLogin.branchIdLoggedIn,
            controllerLogin.idProfessionalLoggedIn,
            'Barbero',
            'loadDataFirt',
            loginController.tokenUserLoggedIn);
      }
      await controllerShoppingCart
          .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
      print('llamada timer encargado loadOrderDeleteCar completed');

      await clientCorControl
          .fetchClientsScheduledBranch(controllerLogin.branchIdLoggedIn);
      print('llamada timer encargado fetchClientsScheduledBranch completed');
      await clientCorControl
          .fetchClientsRechazBranch(controllerLogin.branchIdLoggedIn);
      print('llamada timer encargado fetchClientsRechazBranch completed');
      await clientCorControl.ColacionRequestBranch(
          controllerLogin.branchIdLoggedIn);
      print('llamada timer encargado ColacionRequestBranch completed');
      await clientCorControl.outRequestBranch(controllerLogin.branchIdLoggedIn);
      print('llamada timer encargado outRequestBranch completed');
      controllerShoppingCart.setLoading(false);
    }
  }

  void callTimer1() {
    // Cancela cualquier temporizador existente para evitar duplicaciones

    // Establece un temporizador que llama a la función cada 20 segundos
    _timerResp =
        Timer.periodic(const Duration(seconds: 13), (Timer timer) async {
      //estoy entrando cada 8 segundos
      print('llamada timer - l callTimer1 9segundos');
      if (loginController.makeCallE == true) {
        if (controllerLogin.branchIdLoggedIn != null &&
            controllerLogin.idProfessionalLoggedIn != null &&
            controllerLogin.usserPermissionQr != null) {
          notiController.fetchNotificationList(
              controllerLogin.branchIdLoggedIn,
              controllerLogin.idProfessionalLoggedIn,
              'Encargado',
              'loadDataFirt',
              loginController.tokenUserLoggedIn);
          if (loginController.chargeUserLoggedIn == "Barbero y Encargado") {
            notiController.fetchNotificationList(
                controllerLogin.branchIdLoggedIn,
                controllerLogin.idProfessionalLoggedIn,
                'Barbero',
                'loadDataFirt',
                loginController.tokenUserLoggedIn);
          }
          await controllerShoppingCart
              .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
          print('llamada timer encargado loadOrderDeleteCar completed');

          await clientCorControl
              .fetchClientsScheduledBranch(controllerLogin.branchIdLoggedIn);
          print(
              'llamada timer encargado fetchClientsScheduledBranch completed');
          await clientCorControl
              .fetchClientsRechazBranch(controllerLogin.branchIdLoggedIn);
          print('llamada timer encargado fetchClientsRechazBranch completed');
          await clientCorControl.ColacionRequestBranch(
              controllerLogin.branchIdLoggedIn);
          print('llamada timer encargado ColacionRequestBranch completed');
          await clientCorControl
              .outRequestBranch(controllerLogin.branchIdLoggedIn);
          print('llamada timer encargado outRequestBranch completed');
          controllerShoppingCart.setLoading(false);
        } else {
          controllerShoppingCart.setLoading(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

//ESTRUCTURA DE LOS CARTS
    final twoPi = 3.14 * 2;

    return Column(
      children: [
        Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: const Color(0xFF4470F3), //CARAGANDO COLOR HEXADECIMAL,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*todo texto arriba */ const Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Últimas Notificaciones',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    /*todo cart1 servicios*/ Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 4, right: 8, bottom: 6),
                          child: FadeIn(
                            duration: const Duration(seconds: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<ShoppingCartController>(
                                    builder: (contShopp) {
                                  if (controllerShoppingCart.isLoading ==
                                      true) {
                                    return const Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 45,
                                        ),
                                        CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                        Text(
                                          'Cargando lista de solicitudes...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      ],
                                    ));
                                  } else {
                                    return showRequestsDelete(
                                        context,
                                        contShopp,
                                        controllerLogin,
                                        clientCorControl);
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
            flex: 14, // 85% del espacio disponible para esta parte
            child: SingleChildScrollView(
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
                                  const Color(0xFF19CF9E),
                                  'Clientes',
                                  'Clientes del día',
                                  Icons.notifications),
                              cartsHome(
                                  context,
                                  const Color(0xFFFF6750),
                                  'Colación',
                                  'Colación',
                                  Icons.person_pin_rounded),
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
                                  const Color(0xFF4470F3),
                                  'Estadísticas',
                                  'Revisa tus Ingresos',
                                  Icons.bar_chart),
                              cartsHome(
                                  context,
                                  const Color(0xFFFDAE2A),
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
              ),
            )),
      ],
    );
  }

  Container cartsHome(BuildContext context, Color colorVariable,
      String titleCart, String descriptionTitleCart, iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.46), //Tamaño de los Cards
      height: (MediaQuery.of(context).size.height * 0.20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: colorVariable,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorVariable, // Color de fondo en verde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12), // Ajusta el radio según tus necesidades
          ),
        ),
        onPressed: () async {
          if (titleCart == 'Clientes') {
            pagesConfigC.updateColacionNotification(0);
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await clientCorControl
                .fetchClientsScheduledBranch(controllerLogin.branchIdLoggedIn);

            pagesConfigReC.onTabTapped(1);
            Get.back();
            print('cargando valores 2');
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
            await coexistCont.fetchBranchProfessionals();
            pagesConfigReC.onTabTapped(4);
            Get.back();
            /*Get.toNamed(
                                    '/coexistencePageResponsible',
                                  );*/
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
            pagesConfigReC.onTabTapped(3);
            Get.back();
          }
          if (titleCart == 'Colación') {
            pagesConfigC.updateColacionNotification(1);
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await clientCorControl.ClientsColacionBranch(
                controllerLogin.branchIdLoggedIn);
            pagesConfigReC.onTabTapped(1);
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
                  backgroundColor: const Color.fromARGB(
                      255, 231, 233, 233), // Color de fondo del CircleAvatar
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

  Column showRequestsDelete(
      context,
      ShoppingCartController contShopp,
      LoginController controllerLogin,
      ClientsCoordinatorController controllerclient) {
    List<Widget> widgets = [];
    String titulo = "";
    bool service = false;
    /* if (fin > 2) {
    fin = 2;
  }*/

    //todo aqui le muestra las solicitudes de Salida
    for (int i = 0; i < controllerclient.pOutRequestLength; i++) {
      titulo = 'Solicitando Salida';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            //  if (controllerLogin.codigoQrValid() == true) {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .pOutRequestBranch[i].professional_id!;
                              String charge =
                                  controllerclient.pOutRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 1);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //codigo 200
                                String typeDelete =
                                    'Rechazada su solicitud de Salida';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Su solicitud de Salida fue rechazada',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await clientCorControl.outRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AutofillHints.familyName,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                      ),
                                      Text(
                                        controllerclient.pOutRequestBranch[i]
                                            .professional_name!,
                                        style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      controllerclient
                                          .pOutRequestBranch[i].start_time!,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .pOutRequestBranch[i].professional_id!;
                              String charge =
                                  controllerclient.pOutRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 0);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //poner a 4 para que le cierre la session el Qr
                                // controllerLogin.setCodigoQrValid(null);
                                //viendo a la hora que se le aceptó
                                //la notificación la inserta la api
                                //
                                /*  var now = DateTime.now(); //hora actual
                                //sumo 1 hora
                                var formatter = DateFormat('hh:mm');
                                String formattedTime = formatter.format(now);

                                //codigo 200
                                String typeDelete =
                                    'Aceptada su solicitud de Salida';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Aceptada su solicitud de Salida, ($formattedTime).',
                                    charge);
                                    */
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await clientCorControl.outRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //
    //todo aqui le muestra las solicitudes de Salida
    //
    //
    //

    //todo aqui le muestra las solicitudes de Colación
    for (int i = 0; i < controllerclient.clientsColacionRequestLength; i++) {
      titulo = 'Solicitando Colación';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            //  if (controllerLogin.codigoQrValid() == true) {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .clientsColacionRequestBranch[i]
                                  .professional_id!;
                              String charge = controllerclient
                                  .clientsColacionRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              print('este es el cargo : $charge');

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 1);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //codigo 200
                                String typeDelete =
                                    'Rechazada su solicitud de Colación';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Su solicitud de Colación fue rechazada',
                                    charge);
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await clientCorControl.ColacionRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AutofillHints.familyName,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                      ),
                                      Text(
                                        controllerclient
                                            .clientsColacionRequestBranch[i]
                                            .professional_name!,
                                        style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      controllerclient
                                          .clientsColacionRequestBranch[i]
                                          .start_time!,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.120),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              controllerShoppingCart.setLoading(true);
                              int idProf = controllerclient
                                  .clientsColacionRequestBranch[i]
                                  .professional_id!;
                              String charge = controllerclient
                                  .clientsColacionRequestBranch[i].charge!;
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }

                              int result =
                                  await controllerLogin.ColacionProfessional(
                                      idProf, charge, 2);
                              //aqui mandar notificacion
                              if (result == 1) {
                                //poner a null el Qr
                                // controllerLogin.setCodigoQrValid(null);
                                //viendo a la hora que se le aceptó
                                //la notificación la inserta la api
                                //
                                /*  var now = DateTime.now(); //hora actual
                                var oneHourLater =
                                    now.add(Duration(hours: 1)); //sumo 1 hora
                                var formatter = DateFormat('hh:mm');
                                String formattedTime = formatter.format(now);
                                String formattedTime2 =
                                    formatter.format(oneHourLater);
                                //codigo 200
                                String typeDelete =
                                    'Aceptada su solicitud de Colación';

                                notiController.storeNotification2(
                                    typeDelete,
                                    controllerLogin.branchIdLoggedIn,
                                    idProf,
                                    'Aceptada su solicitud de Colación, de ($formattedTime a $formattedTime2)',
                                    charge);

                                    */
                              } else {
                                Get.snackbar(
                                  'Alerta',
                                  'Inténtelo nuevamente,problemas de conexión',
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
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await clientCorControl.ColacionRequestBranch(
                                    controllerLogin.branchIdLoggedIn);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //todo aqui le muestra las solicitudes de Colación
    //

    //todo aqui le muestra a los clientes solicitados como rechazados
    for (int i = 0;
        i < controllerclient.clientsScheduledListBranchClientLength;
        i++) {
      titulo = 'Rechazando Cliente';

      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              //rechazar la Eliminación
                              controllerShoppingCart.setLoading(true);
                              print('rechazando la solicitud');
                              //aqui mandar a poner en 0 de nuevo en la cola al cliente
                              bool result = false;
                              String charge = controllerclient
                                  .clientsScheduledListBranchClient[i].charge!;
                              print('rechazando la solicitud - charge:$charge');
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              if (charge == 'Barbero') {
                                result = await clientCorControl
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        0);
                              } else if (charge == 'Tecnico') {
                                result = await clientCorControl
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        4);
                              }

                              //aqui mandar notificacion
                              print('return resul: IconButton $result');
                              if (result == true) {
                                if (charge == 'Barbero') {
                                  notiController.storeNotification2(
                                      'Solicitud de Eliminación Rechazada',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      '!Atención..El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} no fue rechazado.',
                                      'Barbero');
                                } else if (charge == 'Tecnico') {
                                  notiController.storeNotification2(
                                      'Solicitud de Eliminación Rechazada',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      '!Atención..El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} no fue rechazado.',
                                      'Tecnico');
                                }
                                if (controllerLogin.branchIdLoggedIn != null) {
                                  await controllerclient
                                      .fetchClientsRechazBranch(
                                          controllerLogin.branchIdLoggedIn!);
                                  await contShopp.loadOrderDeleteCar(
                                      controllerLogin.branchIdLoggedIn!);
                                  controllerShoppingCart.setLoading(false);
                                }
                                controllerLogin.setMakeCallE(true);
                              } else {
                                Get.snackbar(
                                  'Mensaje',
                                  'Intentelo nuevamente',
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
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' $titulo',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        height: 1),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Color.fromARGB(180, 0, 0, 0),
                                        ),
                                        Text(
                                          controllerclient
                                              .clientsScheduledListBranchClient[
                                                  i]
                                              .client_name!,
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .time
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.accountTie,
                                  ),
                                  Text(
                                    '${controllerclient.clientsScheduledListBranchClient[i].professional_name.toString()}',
                                    style: TextStyle(
                                        fontSize: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.018),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: IconButton(
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              controllerShoppingCart.setLoading(true);
                              String charge = controllerclient
                                  .clientsScheduledListBranchClient[i].charge!;
                              bool result = false;
                              String typeDelete = '';
                              if (charge == 'Barbero y Encargado') {
                                charge = 'Barbero';
                              }
                              if (charge == 'Barbero') {
                                result = await clientsScheduleCont
                                    .deleteReservationClientCoor(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        'Fue rechazado por ${controllerclient.clientsScheduledListBranchClient[i].professional_name}');
                                typeDelete = 'Aceptada Eliminación de Cliente';
                              } else if (charge == 'Tecnico') {
                                result = await clientCorControl
                                    .acceptOrRejectClientCoord(
                                        controllerclient
                                            .clientsScheduledListBranchClient[i]
                                            .reservation_id,
                                        11);

                                typeDelete = 'Aceptada Eliminación de Cliente';
                              }

                              //aqui mandar notificacion
                              print('return resul: IconButton $result');
                              if (result == true) {
                                if (charge == 'Barbero') {
                                  notiController.storeNotification2(
                                      typeDelete,
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue eliminado de su cola',
                                      'Barbero');
                                } else if (charge == 'Tecnico') {
                                  //enviar mensaje al barbero que el cliente esta regresando porque fue rechazado

                                  notiController.storeNotification(
                                      'Cliente rechazado por el Técnico',
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .idBarber,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue rechazado por el Técnico ${controllerclient.clientsScheduledListBranchClient[i].professional_name}',
                                      'Barbero');
                                  //enviar notificacion al propio tecnico que fue aceptada
                                  notiController.storeNotification2(
                                      typeDelete,
                                      controllerLogin.branchIdLoggedIn,
                                      controllerclient
                                          .clientsScheduledListBranchClient[i]
                                          .professional_id,
                                      'El cliente ${controllerclient.clientsScheduledListBranchClient[i].client_name} fue eliminado de su cola',
                                      'Tecnico');
                                }
                              }
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await controllerclient.fetchClientsRechazBranch(
                                    controllerLogin.branchIdLoggedIn!);
                                await contShopp.loadOrderDeleteCar(
                                    controllerLogin.branchIdLoggedIn!);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                          icon: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.white,
                            size: (MediaQuery.of(context).size.height * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //
    //todo aqui le muestra a los clientes solicitados como rechazados
    //
    //

    //
//todo aqui le muestra las solicitudes de Eliminación de Servicios y Productos
    for (int i = 0; i < contShopp.orderDeleteCar.length; i++) {
      if (contShopp.orderDeleteCar[i].nameService == '') {
        titulo = 'Eliminación de Producto';
        service = false;
      } else {
        titulo = 'Eliminación de Servicio';
        service = true;
      }
      widgets.add(
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.126),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6750),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xFFFF6750), // Color de fondo en verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el radio según tus necesidades
                            ),
                            // Ajusta el radio según tus necesidades
                          ),
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              controllerLogin.setMakeCallE(false);
                              //rechazar la Eliminación
                              controllerShoppingCart.setLoading(true);
                              int result = await contShopp.requestDelete(
                                  contShopp.orderDeleteCar[i].id, 0);
                              //aqui mandar notificacion
                              if (result == 1) {
                                String serviceProduct = 'Servicio';
                                String? nameServiceProduct =
                                    contShopp.orderDeleteCar[i].nameService;
                                if (contShopp.orderDeleteCar[i].nameService ==
                                    null) {
                                  serviceProduct = 'Producto';
                                  nameServiceProduct =
                                      contShopp.orderDeleteCar[i].nameProduct;
                                }
                                //la notificacion la crea la api
                                //
                                // notiController.storeNotification(
                                //     'Solicitud de Eliminación Rechazada',
                                //     controllerLogin.branchIdLoggedIn,
                                //     contShopp.orderDeleteCar[i].profesional_id,
                                //     '!Atención..El $serviceProduct "$nameServiceProduct" de el cliente ${contShopp.orderDeleteCar[i].nameClient} no fue aprobado para su eliminación.',
                                //     'Barbero');
                              }
                              if (controllerLogin.branchIdLoggedIn != null) {
                                await contShopp.loadOrderDeleteCar(
                                    controllerLogin.branchIdLoggedIn!);
                                controllerShoppingCart.setLoading(false);
                              }
                              controllerLogin.setMakeCallE(true);
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
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.120),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $titulo',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      height: 1),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.formatListBulleted,
                                      ),
                                      Text(
                                        service
                                            ? '${contShopp.orderDeleteCar[i].nameService}'
                                            : '${contShopp.orderDeleteCar[i].nameProduct}',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                            fontWeight: FontWeight.w500,
                                            height: 1),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      contShopp.orderDeleteCar[i].hora
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800,
                                          height: 1)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  MdiIcons.accountTie,
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameProfesional
                                      .toString(),
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(180, 0, 0, 0),
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameClient,
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.126),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            color: const Color(0xFF19CF9E),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xFF19CF9E), // Color de fondo en verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el radio según tus necesidades
                            ),
                          ),
                          onPressed: () async {
                            if (controllerLogin.usserPermissionQr == 1 ||
                                controllerLogin.usserPermissionQr == 2) {
                              if (contShopp.buttonPress == false) {
                                contShopp.setButtonPress(true);
                                controllerLogin.setMakeCallE(false);

                                controllerShoppingCart.setLoading(true);
                                int result = await contShopp.orderDelete(
                                    contShopp.orderDeleteCar[i].id);
                                //aqui mandar notificacion
                                print('return resul: IconButton $result');
                                print(
                                    'return resul: orderDeleteCar[i].id ${contShopp.orderDeleteCar[i].id}');
                                if (result == 1) {
                                  String typeDelete =
                                      'Aceptada Eliminación de Servicio';
                                  String serviceProduct = 'Servicio';
                                  String? nameServiceProduct =
                                      contShopp.orderDeleteCar[i].nameService;
                                  if (contShopp.orderDeleteCar[i].nameService ==
                                      '') {
                                    typeDelete =
                                        'Aceptada Eliminación de Producto';
                                    serviceProduct = 'Producto';
                                    nameServiceProduct =
                                        contShopp.orderDeleteCar[i].nameProduct;
                                  }

                                  if (typeDelete ==
                                      'Aceptada Eliminación de Servicio') {
                                    //esta notificación la esta haciendo el api
                                    //
                                    // notiController.storeNotification2(
                                    //     typeDelete,
                                    //     controllerLogin.branchIdLoggedIn,
                                    //     contShopp
                                    //         .orderDeleteCar[i].profesional_id,
                                    //     '$serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado con tiempo de ${contShopp.orderDeleteCar[i].duration_service} min.${contShopp.orderDeleteCar[i].reservation_id}',
                                    //     'Barbero');
                                  } else {
                                    //esta notificación la esta haciendo el api
                                    //
                                    // notiController.storeNotification(
                                    //     typeDelete,
                                    //     controllerLogin.branchIdLoggedIn,
                                    //     contShopp
                                    //         .orderDeleteCar[i].profesional_id,
                                    //     'El $serviceProduct "$nameServiceProduct" del cliente ${contShopp.orderDeleteCar[i].nameClient} fue eliminado satisfactoriamente.',
                                    //     'Barbero');
                                  }
                                }
                                if (controllerLogin.branchIdLoggedIn != null) {
                                  await contShopp.loadOrderDeleteCar(
                                      controllerLogin.branchIdLoggedIn!);
                                  controllerShoppingCart.setLoading(false);
                                  contShopp.setButtonPress(false);
                                }
                              }
                              controllerLogin.setMakeCallE(true);
                              controllerShoppingCart.setLoading(false);
                              contShopp.setButtonPress(false);
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      );
    }
    //
    //todo aqui le muestra las solicitudes de Eliminación de Servicios y Productos
    //
    //
    //

    //
    if ((contShopp.orderDeleteCar.isEmpty) &&
        (controllerclient.clientsScheduledListBranchClient.isEmpty) &&
        (controllerclient.clientsColacionRequestBranch.isEmpty) &&
        (controllerclient.pOutRequestBranch.isEmpty)) {
      widgets.add(const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 70),
          child: Text(
            'No hay solicitudes a eliminar.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }
}
