// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotificationsPageProf extends StatefulWidget {
  const NotificationsPageProf({super.key});

  @override
  State<NotificationsPageProf> createState() => _NotificationsPageProfState();
}

class _NotificationsPageProfState extends State<NotificationsPageProf> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final NotificationController notifCont = Get.find<NotificationController>();
  final LoginController logCont = Get.find<LoginController>();
  String typeEnv = '';
  @override
  void initState() {
    super.initState();

    if (logCont.chargeUserLoggedIn == 'Barbero y Encargado') {
      if (logCont.switchValue == false) //'Barbero'
      {
        typeEnv = 'Barbero';
      } else {
        typeEnv = 'Encargado';
      }
    } else {
      typeEnv = logCont.chargeUserLoggedIn;
    }
    FlutterBackgroundService().invoke('clearAllNotifications');
    Future.delayed(const Duration(seconds: 2), () {
      notifCont.updateNotifications(
          logCont.branchIdLoggedIn, logCont.idProfessionalLoggedIn, typeEnv);


    });


  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.back();
    });
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;
    /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
    final IconnsBack = Icons.arrow_back;
    final IconnsP = MdiIcons.bellBadgeOutline;
    String title = 'Notificaciones';
    String subTitle = 'Mis notificaciones';
    final colorCont = Colors.white;
    double panddCont = 8;
    double borderCont = 12;
    final colorIcon = Color(0xFFFF6750);
    /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<NotificationController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: topPage(
                        panddCont: panddCont,
                        colorCont: colorCont,
                        borderCont: borderCont,
                        IconnsBack: IconnsBack,
                        pagesConfigC: pagesConfigCont,
                        isPagesConfig: true,
                        IconnsP: IconnsP,
                        title: title,
                        subTitle: subTitle,
                        colorIcon: colorIcon,
                        buttonRight: false),
                  ),
                  Expanded(
                      flex:
                          heightFlexBody, // 85% del espacio disponible para esta parte
                      child: _.notificationListLength > 0
                          ? ListView.builder(
                              padding: EdgeInsets
                                  .zero, // Elimina cualquier padding del ListView
                              itemCount: _.notificationListLength,
                              itemBuilder: (context, index) {
                                String description =
                                    _.notification[index].description;
                                if (_.notification[index].tittle ==
                                    'Aceptada Eliminación de Servicio') {
                                  String textoCompleto =
                                      _.notification[index].description;
                                  description = textoCompleto
                                      .split(',')[0]; // Obtener la descripción
                                }

                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.01),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  borderRadiusValue)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(-5,
                                                  5), // Ajusta los valores para personalizar la sombra
                                            ),
                                          ],
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 231, 232, 234),
                                              Color.fromARGB(
                                                  255, 243, 182, 138),
                                            ],
                                            stops: [0.0, 0.8],
                                            begin: FractionalOffset.centerRight,
                                            end: FractionalOffset.centerLeft,
                                          )),
                                      child: Row(
                                        children: [
                                          Visibility(
                                            visible: _.selectNotification
                                                .contains(
                                                    _.notification[index]),
                                            child: Container(
                                              height: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.168),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.20),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFDAE2A),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            borderRadiusValue)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(-5,
                                                        5), // Ajusta los valores para personalizar la sombra
                                                  ),
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    '! No me Gustó...',
                                                    duration: const Duration(
                                                        milliseconds: 2000),
                                                  );
                                                  //_.deletenotification(index);
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
                                          ),
                                          Container(
                                            height: _.selectNotification
                                                    .contains(
                                                        _.notification[index])
                                                ? (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.168)
                                                : (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.14),
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1),
                                            decoration: _.selectNotification
                                                    .contains(_.notification[
                                                        index]) /*_.selectnotification
                                                        .contains(_.notifications[index])*/
                                                ? null
                                                : BoxDecoration(
                                                    border:
                                                        Border.all(width: 0.01),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset: const Offset(-5,
                                                            5), // Ajusta los valores para personalizar la sombra
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                borderRadiusValue)),
                                                  ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ListTile(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            borderRadiusValue)),
                                                  ),
                                                  onTap: () {
                                                    // _.getSelectNotification(index);
                                                  },
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 2),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              _
                                                                  .notification[
                                                                      index]
                                                                  .tittle,
                                                              style: TextStyle(
                                                                fontSize: _
                                                                        .selectNotification
                                                                        .contains(
                                                                            _.notification[index])
                                                                    ? 23
                                                                    : 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      (_.notification[index]
                                                                      .state ==
                                                                  0) ||
                                                              (_.notification[index]
                                                                      .state ==
                                                                  3)
                                                          ? const Icon(
                                                              Icons
                                                                  .notifications_active,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      17,
                                                                      94,
                                                                      14),
                                                            )
                                                          : Text(''),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 2),
                                                        child: Text(
                                                          description,
                                                          style: TextStyle(
                                                            fontSize: _
                                                                    .selectNotification
                                                                    .contains(
                                                                        _.notification[
                                                                            index])
                                                                ? 20
                                                                : 14,
                                                            color: const Color
                                                                    .fromARGB(
                                                                148, 0, 0, 0),
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      _.notification[index]
                                                          .created_at,
                                                      style: TextStyle(
                                                          fontSize: _
                                                                  .selectNotification
                                                                  .contains(
                                                                      _.notification[
                                                                          index])
                                                              ? 12
                                                              : 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          /*todo*/ Visibility(
                                            visible: _.selectNotification
                                                .contains(
                                                    _.notification[index]),
                                            child: Container(
                                              height: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.168),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.20),
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 32, 32, 32),
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          borderRadiusValue))),
                                              child: IconButton(
                                                onPressed: () {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Like!',
                                                    duration: const Duration(
                                                        milliseconds: 2000),
                                                  );
                                                  // _.deletenotification(index);
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : const Center(
                              //*AQUI ESTA EL CODIGO DE CUANDO NO HAY NOTIFICACIONES
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No hay Notificaciones'),
                                  ],
                                ),
                              ],
                            )))
                ],
              );
      }),
    );
  }
}
