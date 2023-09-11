// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:get/get.dart';

class NotificationsPageNew extends StatelessWidget {
  const NotificationsPageNew({super.key});
  final double valuePadding = 12;

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
                Navigator.pop(context);
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
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: _.selectNotification
                                              .contains(_.notification[index]),
                                          child: Container(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.130),
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.16),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 241, 130, 84),
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                      left: Radius.circular(
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
                                                Icons.phonelink_erase,
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
                                          height: _.selectNotification.contains(
                                                  _.notification[index])
                                              ? (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.130)
                                              : (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.115),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1),
                                          decoration: _.selectNotification
                                                  .contains(_.notification[
                                                      index]) /*_.selectnotification
                                                  .contains(_.notifications[index])*/
                                              ? BoxDecoration(
                                                  boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
                                                        spreadRadius: 1,
                                                        blurRadius: 3,
                                                        offset: const Offset(0,
                                                            5), // Ajusta los valores para personalizar la sombra
                                                      ),
                                                    ],
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 231, 232, 234),
                                                      Color.fromARGB(
                                                          255, 243, 182, 138),
                                                    ],
                                                    stops: [0.0, 0.8],
                                                    begin: FractionalOffset
                                                        .centerRight,
                                                    end: FractionalOffset
                                                        .centerLeft,
                                                  ))
                                              : BoxDecoration(
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
                                          child: ListTile(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            onTap: () {
                                              _.getSelectNotification(index);
                                            },
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Eliminación de Servicio',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                Text(
                                                  '8.000',
                                                  style: TextStyle(
                                                      fontSize: _
                                                              .selectNotification
                                                              .contains(
                                                                  _.notification[
                                                                      index])
                                                          ? (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.03)
                                                          : (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.022),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Masaje capilar'),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .person_2_outlined,
                                                            color: Colors.black,
                                                            size: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.016)),
                                                        Text(
                                                          'Paula Rego',
                                                          style: TextStyle(
                                                              fontSize: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.014),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(Icons.person,
                                                                color: Colors
                                                                    .black,
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.016)),
                                                            Text(
                                                              'Wiliam Miller',
                                                              style: TextStyle(
                                                                  fontSize: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.014),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(Icons.timer,
                                                                color: Colors
                                                                    .black,
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.016)),
                                                            Text(
                                                              '15 Minutos',
                                                              style: TextStyle(
                                                                  fontSize: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.014),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _.selectNotification
                                              .contains(_.notification[index]),
                                          child: Container(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.130),
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.16),
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 32, 32, 32),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
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
                                                Icons.done_all,
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
                                )),
                      ),
                    ],
                  )
                : Center(
                    //*AQUI ESTA EL CODIGO DE CUANDO NO HAY NOTIFICACIONES
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_backpack_outlined),
                          Text('No hay Notificaciones'),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Mensaje',
                            'INSERTADO CORRECTAMENTE',
                            backgroundColor:
                                const Color.fromARGB(92, 11, 226, 22),
                            duration: const Duration(milliseconds: 2000),
                          );
                          _.addNotification();
                        },
                      ),
                    ],
                  ));
      }),
    );
  }
}
