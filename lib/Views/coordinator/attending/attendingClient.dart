// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/ImageDetailScreen.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/login.controller.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AttendingClient extends StatefulWidget {
  const AttendingClient({super.key});

  @override
  State<AttendingClient> createState() => _AttendingClientState();
}

class _AttendingClientState extends State<AttendingClient> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final LoginController loginController = Get.find<LoginController>();
  final PagesConfigController pagesConfigCont1 =
      Get.find<PagesConfigController>();
  int cantVisitas = 3;

  String description = 'Coca Cola Classic 350 ml';
  String fecha = '10-01-2024';
  String name = 'Coca Cola';
  Icon icon = Icon(
    MdiIcons.tag,
  );
  int cant = 8;

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  var IconnsP = MdiIcons.accountOutline;
  String title = 'Clientes Atendiéndose';
  String subTitle = 'Clientes atendiéndose';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  var colorIcon = Color(0xFF19CF9E);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  var IconnsP2 = MdiIcons.accountTieOutline;
  String title2 = 'Profesionales en Colación';
  String subTitle2 = 'Profesionales en Colación';
  double panddCont2 = 8;
  double borderCont2 = 12;
  var colorIcon2 = Color(0xFFFF6750);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<ClientsCoordinatorController>(
        builder: (controllerCORD) {
          return Column(
            children: [
              pagesConfigCont1.colacionNotification == 1
                  ? Expanded(
                      flex: 4,
                      child: topPage(
                          panddCont: panddCont2,
                          colorCont: colorCont,
                          borderCont: borderCont2,
                          IconnsBack: IconnsBack,
                          pagesConfigC: pagesConfigCont,
                          isPagesConfig: true,
                          IconnsP: IconnsP2,
                          title: title2,
                          subTitle: subTitle2,
                          colorIcon: colorIcon2,
                          buttonRight: false),
                    )
                  : Expanded(
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
              pagesConfigCont.colacionNotification == 0
                  ? Expanded(
                      flex: 18,
                      child: controllerCORD.clientAttendBranch
                              .isNotEmpty //todo si hay cargarlos aqui
                          ? ListView.builder(
                              padding: EdgeInsets
                                  .zero, // Elimina cualquier padding del ListView
                              itemCount: controllerCORD
                                  .clientAttendBranchLength, //aqui ver la long de clientAttenCORD y mostrar aqui los que esten
                              itemBuilder: (context, index) {
                                // Utiliza la función cardOptions para construir cada Card
                                return cardClientTails(
                                    controllerCORD,
                                    context,
                                    index,
                                    pagesConfigCont.pageController2,
                                    pagesConfigCont);
                              },
                            )
                          : const Center(
                              child: Text('No hay clientes atendiéndose'),
                            ),
                    )
                  : Expanded(
                      flex: 18,
                      child: controllerCORD.clientsColacionBranch
                              .isNotEmpty //todo si hay cargarlos aqui
                          ? ListView.builder(
                              padding: EdgeInsets
                                  .zero, // Elimina cualquier padding del ListView
                              itemCount: controllerCORD
                                  .clientsColacionBranchLength, //aqui ver la long de clientAttenCORD y mostrar aqui los que esten
                              itemBuilder: (context, index) {
                                // Utiliza la función cardOptions para construir cada Card
                                return cardProfessionalesColacion(
                                    controllerCORD,
                                    context,
                                    index,
                                    pagesConfigCont.pageController2,
                                    pagesConfigCont);
                              },
                            )
                          : const Center(
                              child: Text('No hay profesionales en colación'),
                            ),
                    )
            ],
          );
        },
      ),
    );
  }

  cardProfessionalesColacion(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC) {
    DateFormat formatter = DateFormat('HH:mm');
    DateTime currentTime = formatter
        .parse(controllerclient.clientsColacionBranch[index].start_time!);

    // Paso 2: Sumar una hora al objeto DateTime
    DateTime newTime = currentTime.add(Duration(hours: 1));

    // Paso 3: Formatear el resultado en el formato deseado (hh:mm a)
    String formattedNewTime = formatter.format(newTime);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 8, bottom: 8, right: 4),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white, //fondo de la imagen
                          child: ClipOval(
                            child: Image.network(
                              '${Env.apiEndpoint}/images/${controllerclient.clientsColacionBranch[index].client_image}',
                              fit: BoxFit
                                  .cover, // Ajusta la imagen para cubrir completamente el área
                              width:
                                  50, // Ancho deseado de la imagen dentro del círculo
                              height: 50,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
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
                              errorBuilder: (BuildContext context, Object error,
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
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height * 0.11),
                        width: (MediaQuery.of(context).size.width * 0.8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        //PROFESIONAL
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            controllerclient
                                                .clientsColacionBranch[index]
                                                .professional_name!,
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                height: 1,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          '${controllerclient.clientsColacionBranch[index].start_time!.substring(0, 5)} - $formattedNewTime',
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              height: 1,
                                              fontWeight: FontWeight.w500),
                                        ),
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
                  )),
            ],
          )),
    );
  }

  cardClientTails(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC) {
    String tipo = '';
    if (controllerclient.clientAttendBranch[index].from_home == 1) {
      tipo = 'Reser';
    } else if (controllerclient.clientAttendBranch[index].select_professional ==
        1) {
      tipo = 'Selec';
    } else {
      tipo = 'Aleat';
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Container(
                  height: 76,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          width: 2,
                          color: controllerclient
                                      .clientAttendBranch[index].from_home ==
                                  1
                              ? const Color(0xFFFDAE2A)
                              : controllerclient.clientAttendBranch[index]
                                          .select_professional ==
                                      1
                                  ? const Color(0xFF19CF9E)
                                  : const Color(0xFF4470F3))),
                  //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 12, bottom: 8, right: 4),
                        child: CircleAvatar(
                          //'${Env.apiEndpoint}/images/${controllerclient.clientAttendBranch[index].client_image}'
                          radius: 25,
                          backgroundColor: Colors.white, //fondo de la imagen
                          child: GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageDetailScreen(
                                      imageUrl:
                                          '${Env.apiEndpoint}/images/${controllerclient.clientAttendBranch[index].client_image}'),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${Env.apiEndpoint}/images/${controllerclient.clientAttendBranch[index].client_image}',
                                placeholder: (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        strokeWidth:
                                            2, // Personaliza el ancho del indicador como desees
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(110, 253, 176, 42)),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/default_profile.jpg',
                                  cacheWidth: 50,
                                  cacheHeight: 50,
                                  fit: BoxFit.cover,
                                ),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        //
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height * 0.115),
                        width: (MediaQuery.of(context).size.width * 0.8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        //CLIENTE
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: const Color.fromARGB(
                                                255, 43, 44, 49),
                                            size: 22,
                                          ),
                                          TruncatedText(
                                            text: controllerclient
                                                .clientAttendBranch[index]
                                                .client_name!,
                                            maxLength: 17,
                                            styleText: const TextStyle(
                                                fontSize: 15,
                                                height: 1,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          /*  Text(
                                            controllerclient
                                                .clientAttendBranch[index]
                                                .client_name!,
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                height: 1,
                                                fontWeight: FontWeight.w500),
                                          ),*/
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          '${controllerclient.clientAttendBranch[index].start_time} - ${controllerclient.clientAttendBranch[index].final_hour}  $tipo',
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    //PROFESIONAL
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.accountTie,
                                        color: const Color.fromARGB(
                                            255, 43, 44, 49),
                                        size: 22,
                                      ),
                                      TruncatedText(
                                        text: controllerclient
                                            .clientAttendBranch[index]
                                            .professional_name!,
                                        maxLength: 25,
                                        styleText: const TextStyle(
                                            fontSize: 15,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      /* Text(
                                        controllerclient
                                            .clientAttendBranch[index]
                                            .professional_name!,
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),*/
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
