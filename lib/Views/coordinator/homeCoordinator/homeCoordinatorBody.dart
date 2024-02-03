import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/env.dart';

import '../profile/profileClient.dart';

class HomeCoordinatorBody extends StatefulWidget {
  const HomeCoordinatorBody({super.key});

  @override
  State<HomeCoordinatorBody> createState() => _HomeCoordinatorBodyState();
}

class _HomeCoordinatorBodyState extends State<HomeCoordinatorBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsCoordinatorController clientsScheduledController =
      Get.find<ClientsCoordinatorController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());

  @override
  void initState() {
    super.initState();
    iniciarLlamadaCada10Segundos();
  }

  Timer? _timer;
  iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();
    int cont = 2;
    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      print('hola entrando en 10 min;;');
      if (loginController.branchIdLoggedIn != null &&
          loginController.chargeUserLoggedIn == "Cordinador") {
        print('.........estoy entrando cada : $cont segundos........');

        // actualizo la cola

        print('con contador en 8 llamo la funcion');
        clientsScheduledController
            .fetchClientsScheduledBranch(loginController.branchIdLoggedIn);

        //fin del for
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  String imag = '${Env.apiEndpoint}/images/coordinator/default_profile.jpg';

  //
  @override
  Widget build(BuildContext context) {
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO

    super.build(context);
    return GetBuilder<ClientsCoordinatorController>(
        builder: (controllerclient) {
      return PageView(
          controller: pagesConfigC.pageController2,
          scrollDirection: Axis.horizontal,
          physics: pagesConfigC.isPageViewEnabled
              ? BouncingScrollPhysics() // Habilitar desplazamiento
              : NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            // Almacena el índice de la página actual cuando cambia.

            setState(() {
              pagesConfigC.currentPageIndex = index;
              print(
                  'mostrando aqui el valor de index ESTOY EN HOMEcOORDINATORbODY : $index');
              print(
                  'mostrando aqui el valor de pagesConfigC.pages31Index ESTOY EN HOMEcOORDINATORbODY wewewe : ${pagesConfigC.pages31Index}');
            });
          },
          children: [
            Column(
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
                      child:
                          controllerclient.clientsScheduledListBranchLength > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, left: 12, right: 12, bottom: 12),
                                  child: ListView.builder(
                                    itemCount: controllerclient
                                        .clientsScheduledListBranchLength,
                                    itemBuilder: (context, index) =>
                                        cardClientTails(
                                            controllerclient,
                                            context,
                                            index,
                                            pagesConfigC.pageController2,
                                            pagesConfigC,
                                            imag),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_off,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'No hay clientes en cola',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await pagesConfigC.showAppBar(false);
                                        pagesConfigC.goToPage(
                                            4, pagesConfigC.pageController2);
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color(0xFF2B3141),
                                          const Color.fromARGB(
                                              255, 231, 233, 233),
                                          'Atendiéndose',
                                          'Clientes Atendiéndose',
                                          Icons.person),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        pagesConfigC.onTabTapped(
                                            2); //index = 2 -> /NotificationsPageProf
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color.fromARGB(
                                              255, 81, 93, 117),
                                          Color.fromARGB(255, 231, 233, 233),
                                          'Notificaciones',
                                          'Tus Notificaciones',
                                          Icons.notifications),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                      0.01),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pagesConfigC.onTabTapped(
                                            3); //index = 3 -> /StatisticPage
                                      },
                                      child: cartsHome(
                                          context,
                                          12,
                                          const Color.fromARGB(
                                              255, 177, 174, 174),
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
            ),
            //AQUI MUESTRO LA OTRA NAVEGACION
            pagesConfigC.pages31[0],
            pagesConfigC.pages31[1],
            pagesConfigC.pages31[2],
            pagesConfigC.pages31[3],
          ]);
    });
    //todoooooooooooooooooooooooooooooooooooooooooo
  }

//
//
//
//
  FittedBox cardClientTails(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC,
      imageDirection) {
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
                        backgroundImage: NetworkImage(imageDirection),
                        radius: 40, // Ajusta el tamaño del círculo aquí
                      ),
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
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .client_name,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  //HORARIO
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
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
                                    const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .professional_name!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await pagesConfigC.showAppBar(false);
                        pageController2.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.115),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color.fromARGB(255, 32, 32, 32),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    int idClient = controllerclient
                                        .clientsScheduledListBranch[index]
                                        .client_id;
                                    int idBranch =
                                        loginController.branchIdLoggedIn!;
                                    // aqui llamar a la db y pedir todos los datos del cliente
                                    await controllerclient.getClientHistory(
                                        idClient, idBranch);
                                    //pagesConfigC.updateSelectedIndex();
                                    await pagesConfigC.showAppBar(false);
                                    pageController2.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  },
                                  icon: Icon(
                                    MdiIcons.eye,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height *
                                        0.05),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            const Text(
                              'VER MÁS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
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

//
//
//
//

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
