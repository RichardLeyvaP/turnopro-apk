// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';

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
  String title = 'Clientes Atendiéndose';
  String subTitle = 'Clientes atendiéndose';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF19CF9E);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        toolbarHeight: 150,
        leading: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    /*  pagesConfigCont.pageController2
                        .jumpToPage(0); //AQUI VA  AL HOME*/
                    pagesConfigCont.showAppBar(true);
                    pagesConfigCont.back();
                    // pagesConfigCont.back();
                    // pagesConfigCont.goToPreviousPage();
                    // pagesConfigCont.goToPage(
                    //     1, pagesConfigCont.pageController2);

                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 72.0, // Ajusta el tamaño del círculo según sea necesario
                height: 72.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(76, 224, 224,
                      224), // Puedes ajustar el tono del gris según tus preferencias
                ),
              ),
            )
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Icon(
                  MdiIcons.account,
                  size: 62.0,
                  color: Colors.white, // Color del ícono
                ),
                const Text(
                  'Clientes Atendiéndose',
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
      ),*/
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
                child: controllerCORD.clientAttendBranch
                        .isNotEmpty //todo si hay cargarlos aqui
                    ? ListView.builder(
                        padding: EdgeInsets
                            .zero, // Elimina cualquier padding del ListView
                        itemCount: controllerCORD
                            .clientAttendBranchLength, //aqui ver la long de clientAttenCORD y mostrar aqui los que esten
                        itemBuilder: (context, index) {
                          // Utiliza la función cardOptions para construir cada Card
                          return cardClientTails(controllerCORD, context, index,
                              pagesConfigCont.pageController2, pagesConfigCont);
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

  cardClientTails(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC) {
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
                          child: ClipOval(
                            child: Image.network(
                              '${Env.apiEndpoint}/images/${controllerclient.clientAttendBranch[index].client_image}',
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
                                          Text(
                                            controllerclient
                                                .clientAttendBranch[index]
                                                .client_name,
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
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          '${controllerclient.clientAttendBranch[index].start_time} - ${controllerclient.clientAttendBranch[index].final_hour}',
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
                                      Text(
                                        controllerclient
                                            .clientAttendBranch[index]
                                            .professional_name!,
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
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
}
