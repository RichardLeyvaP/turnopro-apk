import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinator.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';

class HomeCoordinatorBody extends StatefulWidget {
  const HomeCoordinatorBody({super.key});

  @override
  State<HomeCoordinatorBody> createState() => _HomeCoordinatorBodyState();
}

class _HomeCoordinatorBodyState extends State<HomeCoordinatorBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());

  @override
  bool get wantKeepAlive => true;

  //
  @override
  Widget build(BuildContext context) {
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO

    super.build(context);
    return GetBuilder<ClientsCoordinatorController>(
        builder: (controllerclient) {
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
                    color: Color.fromARGB(255, 26, 50, 82),
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
