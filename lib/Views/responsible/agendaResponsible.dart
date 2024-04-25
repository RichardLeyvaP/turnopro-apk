// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';

import '../../../Controllers/login.controller.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgendaResponsible extends StatefulWidget {
  const AgendaResponsible({super.key});

  @override
  State<AgendaResponsible> createState() => _AgendaResponsibleState();
}

class _AgendaResponsibleState extends State<AgendaResponsible> {
  final double valuePadding = 12;
  final StatisticController controllerStatistic =
      Get.find<StatisticController>();
  final PagesConfigResponController pagesConfigCont =
      Get.find<PagesConfigResponController>();
  final LoginController loginController = Get.find<LoginController>();
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
  final IconnsP = MdiIcons.accountOutline;
  String title = 'Clientes';
  String subTitle = 'Mis clientes';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF19CF9E);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<ClientsCoordinatorController>(
        builder: (controllerCORD) {
          return Column(
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
                flex: 18,
                child: controllerCORD.clientsScheduledListBranch
                        .isNotEmpty //todo si hay cargarlos aqui
                    ? ListView.builder(
                        padding: EdgeInsets
                            .zero, // Elimina cualquier padding del ListView
                        itemCount: controllerCORD
                            .clientsScheduledListBranchLength, //aqui ver la long de clientAttenCORD y mostrar aqui los que esten
                        itemBuilder: (context, index) {
                          // Utiliza la función cardOptions para construir cada Card
                          return cardClientTails(
                              controllerCORD, context, index);
                        },
                      )
                    : const Center(
                        child: Text('No hay clientes atendiéndose'),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  FittedBox cardClientTails(ClientsCoordinatorController controllerclient,
      BuildContext context, index) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                          child: Image.network(
                            '${Env.apiEndpoint}/images/${controllerclient.clientsScheduledListBranch[index].client_image}',
                            fit: BoxFit
                                .cover, // Ajusta la imagen para cubrir completamente el área
                            width:
                                50, // Ancho deseado de la imagen dentro del círculo
                            height: 50,
                            loadingBuilder: (BuildContext context, Widget child,
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
                                  radius: 40,
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
                                  radius: 40,
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
                      height: (MediaQuery.of(context).size.height * 0.115),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  //CLIENTE
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color:
                                          const Color.fromARGB(255, 43, 44, 49),
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .client_name,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  //HORARIO
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      MdiIcons.clockOutline,
                                    ),
                                    Text(
                                      '${controllerclient.clientsScheduledListBranch[index].start_time} - ${controllerclient.clientsScheduledListBranch[index].final_hour}',
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
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
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .professional_name!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
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
            const SizedBox(
              height: 12,
            )
          ],
        ));
  }
}
