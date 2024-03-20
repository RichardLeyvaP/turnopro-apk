// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
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
  @override
  void initState() {
    super.initState();
    notifCont.updateNotifications(
        logCont.branchIdLoggedIn, logCont.idProfessionalLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                pagesConfigCont.back();

                // Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.notifications,
                  size: 50,
                ),
                Text(
                  'Notificaciones',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.14),
            ),
          ],
        ),
        //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        elevation: 0, // Quits the shadow
        //shadowColor: Colors.amber, // Removes visual elevation
      ),
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<NotificationController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color.fromARGB(255, 241, 130, 84),
              ))
            : _.notificationListLength > 0
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex:
                            heightFlexBody, // 85% del espacio disponible para esta parte
                        child: ListView.builder(
                            itemCount: _.notificationListLength,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006),
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006)),
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
                                                  Colors.grey.withOpacity(0.6),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0,
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
                                                color: const Color.fromARGB(
                                                    255, 241, 130, 84),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            borderRadiusValue)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
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
                                                            .withOpacity(0.7),
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
                                                      _.notification[index]
                                                                  .state ==
                                                              0
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
                                                          _.notification[index]
                                                              .description,
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

                                                      // Column(
                                                      //   children: [
                                                      //     Row(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .start,
                                                      //       children: [
                                                      //         Icon(
                                                      //           MdiIcons.accountTie,
                                                      //           color: const Color.fromARGB(255, 43, 44, 49),
                                                      //           size: _.selectNotification
                                                      //                   .contains(
                                                      //                       _.notification[
                                                      //                           index])
                                                      //               ? 20
                                                      //               : 16,
                                                      //         ),
                                                      //         Text(
                                                      //           'Paula Rego',
                                                      //           style: TextStyle(
                                                      //             fontSize: _
                                                      //                     .selectNotification
                                                      //                     .contains(
                                                      //                         _.notification[
                                                      //                             index])
                                                      //                 ? 20
                                                      //                 : 14,
                                                      //             color: const Color
                                                      //                     .fromARGB(
                                                      //                 148, 0, 0, 0),
                                                      //             height: 1.0,
                                                      //           ),
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //     Row(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .spaceBetween,
                                                      //       children: [
                                                      //         Row(
                                                      //           mainAxisAlignment:
                                                      //               MainAxisAlignment
                                                      //                   .end,
                                                      //           children: [
                                                      //             Icon(
                                                      //               MdiIcons
                                                      //                   .account,
                                                      //               color: Colors
                                                      //                   .black,
                                                      //               size: _.selectNotification
                                                      //                       .contains(
                                                      //                           _.notification[index])
                                                      //                   ? 20
                                                      //                   : 16,
                                                      //             ),
                                                      //             Text(
                                                      //               'Wiliam Miller',
                                                      //               style:
                                                      //                   TextStyle(
                                                      //                 fontSize: _
                                                      //                         .selectNotification
                                                      //                         .contains(
                                                      //                             _.notification[index])
                                                      //                     ? 20
                                                      //                     : 14,
                                                      //                 color: const Color
                                                      //                         .fromARGB(
                                                      //                     148,
                                                      //                     0,
                                                      //                     0,
                                                      //                     0),
                                                      //                 height: 1.0,
                                                      //               ),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //         Row(
                                                      //           mainAxisAlignment:
                                                      //               MainAxisAlignment
                                                      //                   .end,
                                                      //           children: [
                                                      //             Icon(Icons.timer,
                                                      //                 color: Colors
                                                      //                     .black,
                                                      //                 size: (MediaQuery.of(
                                                      //                             context)
                                                      //                         .size
                                                      //                         .height *
                                                      //                     0.016)),
                                                      //             Text(
                                                      //               '15 Minutos',
                                                      //               style: TextStyle(
                                                      //                   fontSize: _
                                                      //                           .selectNotification
                                                      //                           .contains(_.notification[
                                                      //                               index])
                                                      //                       ? 16
                                                      //                       : 12,
                                                      //                   fontWeight:
                                                      //                       FontWeight
                                                      //                           .w500),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //   ],
                                                      // ),
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
                                )),
                      ),
                    ],
                  )
                : const Center(
                    //*AQUI ESTA EL CODIGO DE CUANDO NO HAY NOTIFICACIONES
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_backpack_outlined),
                          Text('No hay Notificaciones'),
                        ],
                      ),
                    ],
                  ));
      }),
    );
  }
}
