//****************************************************************************** */
//****************************************************************************** */

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/Views/products-services/servicesProductsPage.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/professional/shoppingCartPage.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  YourPageViewScreenState createState() => YourPageViewScreenState();
}

class YourPageViewScreenState extends State<HomePageView> {
  final ClientsScheduledController controllerclient =
      Get.find<ClientsScheduledController>();
  final LoginController controllerLogin = Get.find<LoginController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();
  final ShoppingCartController chopCont = Get.find<ShoppingCartController>();
  final ServiceController serviceControll = Get.find<ServiceController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

/**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.accountGroup;
  String title = 'Mis Clientes';
  String subTitle = 'Clientes en cola';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF19CF9E);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerclient.showingServiceClient(false);
    });
    print(
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\currentPageIndex:${pagesConfigC.currentPageIndex}');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 233, 233),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pagesConfigC.pageController,
              scrollDirection: Axis.horizontal,
              physics: pagesConfigC.isPageViewEnabled
                  ? BouncingScrollPhysics() // Habilitar desplazamiento
                  : NeverScrollableScrollPhysics(), // Deshabilitar desplazamiento
              onPageChanged: (index) {
                // Almacena el índice de la página actual cuando cambia.

                setState(() {
                  pagesConfigC.currentPageIndex = index;
                });
              },
              children: [
                // Agrega tus páginas aquí
                //
                //
                //todo PAGINA 1
                if (controllerLogin.varInTheClock == false) ...[
                  Center(
                    child: GetBuilder<ClientsScheduledController>(
                        builder: (controllerClient) =>
                            controllerClient.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Color(0xFFFDAE2A),
                                  ))
                                : Column(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: topPage(
                                            panddCont: panddCont,
                                            colorCont: colorCont,
                                            borderCont: borderCont,
                                            IconnsBack: IconnsBack,
                                            pagesConfigC: pagesConfigC,
                                            isPagesConfig: true,
                                            IconnsP: IconnsP,
                                            title: title,
                                            subTitle: subTitle,
                                            colorIcon: colorIcon,
                                            buttonRight: false),
                                      ),
                                      loginController.setIsLoading2 == true
                                          ? Container(
                                              width:
                                                  30, // Ancho del indicador de carga
                                              height:
                                                  30, // Altura del indicador de carga
                                              alignment: Alignment.center,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                    Color(
                                                        0xFFFDAE2A)), // Color naranja
                                                strokeWidth:
                                                    3, // Grosor del indicador de carga
                                              ),
                                            )
                                          : SizedBox(),
                                      //AQUI CONTROLO SI HAY CLIENTES EN COLA LOS MUESTRO , SINO MUESTRO UN MENSAJE

                                      controllerclient.getWaitTime() == true
                                          ? Expanded(
                                              flex: 18,
                                              child: Center(
                                                  child: Text(
                                                      'Espera de ${controllerClient.getwaitTimeCount()} segundos',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 82, 81, 81),
                                                      ))))
                                          : Expanded(
                                              flex: 18,
                                              child: controllerClient
                                                          .clientsScheduledListLength >
                                                      0
                                                  ? ListView.builder(
                                                      padding: EdgeInsets
                                                          .zero, // Elimina cualquier padding del ListView
                                                      itemCount: controllerClient
                                                          .clientsScheduledListLength,
                                                      itemBuilder:
                                                          (context, index) {
                                                        String tipo = '';
                                                        if (controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .from_home ==
                                                            1) {
                                                          tipo = 'Reser';
                                                        } else if (controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .select_professional ==
                                                            1) {
                                                          tipo = 'Selec';
                                                        } else {
                                                          tipo = 'Aleat';
                                                        }

                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 10,
                                                            left: 10,
                                                            right: 10,
                                                          ),
                                                          child: Container(
                                                            decoration: controllerClient
                                                                            .clientsScheduledList[
                                                                                index]
                                                                            .attended ==
                                                                        4 ||
                                                                    controllerClient
                                                                            .clientsScheduledList[index]
                                                                            .attended ==
                                                                        3
                                                                ? BoxDecoration(
                                                                    border: Border.all(
                                                                        width: 2,
                                                                        color: controllerClient.clientsScheduledList[index].from_home == 1
                                                                            ? const Color(0xFFFDAE2A)
                                                                            : controllerClient.clientsScheduledList[index].select_professional == 1
                                                                                ? const Color(0xFF19CF9E)
                                                                                : const Color(0xFF4470F3)),
                                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.7),
                                                                        spreadRadius:
                                                                            1,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: const Offset(
                                                                            -5,
                                                                            5), // Ajusta los valores para personalizar la sombra
                                                                      ),
                                                                    ],
                                                                    gradient: const LinearGradient(
                                                                      colors: [
                                                                        Color.fromARGB(
                                                                            255,
                                                                            254,
                                                                            254,
                                                                            255),
                                                                        Color.fromARGB(
                                                                            82,
                                                                            236,
                                                                            233,
                                                                            233),
                                                                      ],
                                                                      stops: [
                                                                        0.0,
                                                                        0.8
                                                                      ],
                                                                      begin: FractionalOffset
                                                                          .centerRight,
                                                                      end: FractionalOffset
                                                                          .centerLeft,
                                                                    ))
                                                                : BoxDecoration(
                                                                    border: controllerClient.clientsScheduledList[index].attended == 1 ||
                                                                            controllerClient.clientsScheduledList[index].attended ==
                                                                                11 ||
                                                                            controllerClient.clientsScheduledList[index].attended ==
                                                                                111
                                                                        ? Border.all(
                                                                            width: 2,
                                                                            color: controllerClient.clientsScheduledList[index].from_home == 1
                                                                                ? const Color(0xFFFDAE2A)
                                                                                : controllerClient.clientsScheduledList[index].select_professional == 1
                                                                                    ? const Color(0xFF19CF9E)
                                                                                    : const Color(0xFF4470F3))
                                                                        : Border.all(
                                                                            width: 2,
                                                                            color: controllerClient.clientsScheduledList[index].from_home == 1
                                                                                ? const Color(0xFFFDAE2A)
                                                                                : controllerClient.clientsScheduledList[index].select_professional == 1
                                                                                    ? const Color(0xFF19CF9E)
                                                                                    : const Color(0xFF4470F3)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.7),
                                                                        spreadRadius:
                                                                            1,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: const Offset(
                                                                            -5,
                                                                            5), // Ajusta los valores para personalizar la sombra
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          12),
                                                                    ),
                                                                  ),
                                                            child: ListTile(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                Get.dialog(
                                                                  const Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Color(
                                                                          0xFFFDAE2A),
                                                                    ),
                                                                  ),
                                                                  barrierDismissible:
                                                                      false,
                                                                ); //Get.back();
                                                                String
                                                                    clientName =
                                                                    controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .client_name!;
                                                                String urlImage = controllerClient
                                                                            .clientsScheduledList[
                                                                                index]
                                                                            .client_image! ==
                                                                        ''
                                                                    ? 'comments/default_profile.jpg'
                                                                    : controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .client_image!;
                                                                int reservationId =
                                                                    controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .reservation_id!;
                                                                int carId =
                                                                    controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .car_id!;

                                                                // aqui digo que estoy mostrando los servicios de un cliente para que no se actualice la cola en ese momento
                                                                // controllerClient
                                                                //     .showingServiceClient(
                                                                //         true);
                                                                // aqui cargar los servicios que tiene
                                                                await controllerClient
                                                                    .searchForCustomerServices3(
                                                                        controllerClient
                                                                            .clientsScheduledList[
                                                                                index]
                                                                            .car_id,
                                                                        loginController
                                                                            .tokenUserLoggedIn)
                                                                    .then((_) {
                                                                  Get.back();
                                                                  Get.toNamed(
                                                                    '/ProfileClientBarber',
                                                                    arguments: {
                                                                      'clientName':
                                                                          clientName,
                                                                      'urlImage':
                                                                          urlImage,
                                                                    },
                                                                  );
                                                                });

                                                                //
                                                                //
                                                              },
                                                              title: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            MdiIcons.clockPlus,
                                                                            color:
                                                                                const Color(0xFF19CF9E),
                                                                          ),
                                                                          Text(
                                                                            '  ${controllerClient.clientsScheduledList[index].start_time}'
                                                                            ' - '
                                                                            ' ${controllerClient.clientsScheduledList[index].final_hour}  $tipo',
                                                                            // '   08:10 - 09:10',
                                                                            style:
                                                                                const TextStyle(
                                                                              height: 1.0,
                                                                              fontSize: 12,
                                                                              color: Color.fromARGB(180, 0, 0, 0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        controllerClient
                                                                            .clientsScheduledList[index]
                                                                            .client_name!,
                                                                        //AQUI EL NOMBRE DEL CLIENTE
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      Text(
                                                                        'Total de servicios: ${(controllerClient.clientsScheduledList[index].total_services).toString()}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Color.fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          height:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //SI ESTA VARIABLE ES IGUAL A 1 ES QUE SE ESTA ATENDIENDO
                                                                  controllerClient.clientsScheduledList[index].attended == 1 ||
                                                                          controllerClient.clientsScheduledList[index].attended ==
                                                                              11 ||
                                                                          controllerClient.clientsScheduledList[index].attended ==
                                                                              111
                                                                      ? Column(
                                                                          children: [
                                                                            const Image(
                                                                              image: AssetImage(
                                                                                'assets/images/client-attended.png',
                                                                              ),
                                                                              width: 50,
                                                                              height: 50,
                                                                            ),
                                                                            Text(
                                                                              controllerClient.clientsScheduledList[index].attended == 1 ? 'Atendiéndose' : 'Terminando Servicio',
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: controllerClient.clientsScheduledList[index].from_home == 1
                                                                                    ? const Color(0xFFFDAE2A)
                                                                                    : controllerClient.clientsScheduledList[index].select_professional == 1
                                                                                        ? const Color(0xFF19CF9E)
                                                                                        : const Color(0xFF4470F3),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : controllerClient.clientsScheduledList[index].attended == 4 ||
                                                                              controllerClient.clientsScheduledList[index].attended == 5
                                                                          ? const Row(
                                                                              //todo 999
                                                                              children: [
                                                                                Opacity(
                                                                                  opacity: 1,
                                                                                  child: Image(
                                                                                    image: AssetImage(
                                                                                      'assets/images/icons/lavado.png',
                                                                                    ),
                                                                                    width: 50,
                                                                                    height: 50,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : controllerClient.clientsScheduledList[index].attended == 3
                                                                              ? const Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      'Esperando',
                                                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFF6750)),
                                                                                    ),
                                                                                    Text('confirmación de', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFF6750))),
                                                                                    Text('Eliminación', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFF6750))),
                                                                                  ],
                                                                                )
                                                                              : Text('')
                                                                ],
                                                              ),
                                                              //subtitle: Text(controllerClient.users[index].username.toString()),
                                                              selected: false,
                                                              //selectedColor: Colors.amber,
                                                              //selectedTileColor: Colors.blue,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'No hay ningún cliente para hoy',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            )
                                    ],
                                  )),
                  ),
                  //
                  //
                  //,
                  //todo PAGINA 2
                  const ServicesProductsPage(),
                  //
                  //
                  //,
                  //todo PAGINA 3
                  ShoppingCartPage(),
                ] else ...[
                  //
                  //,
                  //todo PAGINA 2
                  const ServicesProductsPage(),
                  //
                  //

                  //,
                  //todo PAGINA 3
                  ShoppingCartPage(),
                  //
                  //
                  Center(
                    child: GetBuilder<ClientsScheduledController>(
                        builder: (controllerClient) => controllerClient
                                .isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              ))
                            :
                            //AQUI VERIFICO QUE SE ESTE CONECTANDO AL SERVIDOR
                            // controllerClient.correctConnection == true
                            //     ?
                            Column(
                                children: [
                                  Container(
                                    color: const Color(0xFFFDAE2A),
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).padding.top),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  pagesConfigC.back();
                                                  // Navigator.pop(context);
                                                },
                                              ),
                                              // Ajusta el espacio según sea necesario
                                              const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 70,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    'Mis Clientes',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              const Text('             '),

                                              // Añade más widgets o ajusta según sea necesario
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  loginController.setIsLoading2 == true
                                      ? Container(
                                          width:
                                              30, // Ancho del indicador de carga
                                          height:
                                              30, // Altura del indicador de carga
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Color(
                                                    0xFFFDAE2A)), // Color naranja
                                            strokeWidth:
                                                3, // Grosor del indicador de carga
                                          ),
                                        )
                                      : SizedBox(),
                                  //AQUI CONTROLO SI HAY CLIENTES EN COLA LOS MUESTRO , SINO MUESTRO UN MENSAJE
                                  controllerClient.clientsScheduledListLength >
                                          0
                                      ? Expanded(
                                          flex: 18,
                                          child: ListView.builder(
                                            itemCount: controllerClient
                                                .clientsScheduledListLength,
                                            itemBuilder: (context, index) =>
                                                //AQUI CONTROLO DESDE LA **(API)** SI ATTEENDED=3 ES QUE FUE RECHAZADO Y NO LO MUESTRO
                                                //IGUAL SI ES ATTEENDED=2 ES QUE YA FUE ATENDIDO Y TAMPOCO LO MUESTRO
                                                Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.013),
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.006),
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.013),
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.006)),
                                              child: Container(
                                                decoration: controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .attended ==
                                                            4 ||
                                                        controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .attended ==
                                                            3
                                                    ? BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.01),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    12)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.7),
                                                            spreadRadius: 1,
                                                            blurRadius: 5,
                                                            offset: const Offset(
                                                                -5,
                                                                5), // Ajusta los valores para personalizar la sombra
                                                          ),
                                                        ],
                                                        gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            Color.fromARGB(255,
                                                                254, 254, 255),
                                                            Color.fromARGB(82,
                                                                236, 233, 233),
                                                          ],
                                                          stops: [0.0, 0.8],
                                                          begin:
                                                              FractionalOffset
                                                                  .centerRight,
                                                          end: FractionalOffset
                                                              .centerLeft,
                                                        ))
                                                    : BoxDecoration(
                                                        border: controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .attended ==
                                                                    1 ||
                                                                controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .attended ==
                                                                    11 ||
                                                                controllerClient
                                                                        .clientsScheduledList[
                                                                            index]
                                                                        .attended ==
                                                                    111
                                                            ? Border.all(
                                                                width: 2,
                                                                color: controllerClient
                                                                            .clientsScheduledList[
                                                                                index]
                                                                            .attended ==
                                                                        1
                                                                    ? const Color(
                                                                        0xFFFDAE2A)
                                                                    : const Color(
                                                                        0xFF19CF9E))
                                                            : Border.all(
                                                                width: 0.01),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.7),
                                                            spreadRadius: 1,
                                                            blurRadius: 5,
                                                            offset: const Offset(
                                                                -5,
                                                                5), // Ajusta los valores para personalizar la sombra
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(12),
                                                        ),
                                                      ),
                                                child: ListTile(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    //VA A EJECUTARSE SI NO ESTA CON EL TECNICO
                                                    int resulButton = 0;
                                                    resulButton = loginController
                                                        .handleButtonClickModal(
                                                            controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .reservation_id!);
                                                    if (resulButton == 1) {
                                                      //limpio la lista que controla que se de un solo click al seleccionar los servicios

                                                      loginController
                                                          .handleButtonClickServiceClear();
                                                      loginController
                                                          .setIsLoadingFor2(
                                                              true);
                                                      serviceControll
                                                          .clearSelectService();

                                                      if (controllerClient
                                                              .clientsScheduledList[
                                                                  index]
                                                              .attended !=
                                                          4) {
                                                        // aqui selecciono el cliente
                                                        controllerClient
                                                            .getselectCustomer(
                                                                index,
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .car_id);
                                                        //AQUI MANDO ID DE CARRO PAR ACARGAR EL CARRITO PARA LOS SERVICIO Y PRODUCTOS
                                                        //Y SE ACTUALIZA LA VARIABLE GLOBAL carIdClienteSelect
                                                        controllerClient
                                                            .selectCarClient(
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .car_id);
                                                        //AQUI MANDO EL ID DE RESERVACION Y ME DEVUELVE EL ESTADO DEL CLIENTE,
                                                        //SI SE ESTA ATENDINEDO O NO , PARA ASI SABER CUANDO MOSTRAR LOS BOTONES DE ATENDIDO Y
                                                        //SELECCIONAR SERVICIO Y PRODUCTOS
                                                        controllerClient.returnClientStatus(
                                                            controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .reservation_id!,
                                                            loginController
                                                                .tokenUserLoggedIn);
                                                        //AQUI MANDO EL NOMBRE PARA PONERLO DE TITULO DE LA PAGINA DE SERVICE Y PRODUCT
                                                        controllerClient.returnClientName(
                                                            (controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .client_name)
                                                                .toString());
                                                        controllerClient.returnImageName(
                                                            (controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .client_image)
                                                                .toString());
                                                        //todo  INICIO esto estaba en la pagina del modal al dar en Ver carrito
                                                        await controllerClient
                                                            .watchModifyTime(
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .reservation_id);
                                                        // servControll
                                                        //     .clearSelectService();
                                                        //todo FIN esto estaba en la pagina del modal al dar en Ver carrito
                                                        await chopCont
                                                            .loadDataInitiallyNecessary()
                                                            .then((_) async {
                                                          await controllerClient
                                                              .searchForCustomerServices(
                                                                  controllerClient
                                                                      .clientsScheduledList[
                                                                          index]
                                                                      .car_id,
                                                                  loginController
                                                                      .tokenUserLoggedIn)
                                                              .then((_) {
                                                            loginController
                                                                .setHandleButtonClickModal();
                                                            String clientName =
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .client_name!;
                                                            String urlImage =
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .client_image!;
                                                            int reservationId =
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .reservation_id!;
                                                            int carId =
                                                                controllerClient
                                                                    .clientsScheduledList[
                                                                        index]
                                                                    .car_id!;
                                                            //   _mostrarBottomSheet(          context);
                                                            //  showMyDialog(context);
                                                            print(
                                                                'LISTA2 _fetchServiceList Limpiando clientName:$clientName...reservationId:$reservationId....carId:$carId....urlImage:$urlImage');
                                                            loginController
                                                                .setIsLoadingFor2(
                                                                    false);
                                                            ModalHelper.showModal(
                                                                pagesConfigC
                                                                    .pageController,
                                                                context,
                                                                clientName,
                                                                reservationId,
                                                                carId,
                                                                urlImage);
                                                            // aqui digo que estoy mostrando los servicios de un cliente para que no se actualice la cola en ese momento
                                                            controllerClient
                                                                .showingServiceClient(
                                                                    true);
                                                          });
                                                        });
                                                      }
                                                    } //cierre del if de comprobacion que no lo llame vairas veces
                                                  },
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                MdiIcons
                                                                    .clockPlus,
                                                                color: const Color(
                                                                    0xFF19CF9E),
                                                              ),
                                                              Text(
                                                                '  ${controllerClient.clientsScheduledList[index].start_time}'
                                                                ' - '
                                                                ' ${controllerClient.clientsScheduledList[index].final_hour}',
                                                                // '   08:10 - 09:10',
                                                                style:
                                                                    const TextStyle(
                                                                  height: 1.0,
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          180,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .client_name!,
                                                            //AQUI EL NOMBRE DEL CLIENTE
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text(
                                                            'Total de servicios: ${(controllerClient.clientsScheduledList[index].total_services).toString()}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(148,
                                                                      0, 0, 0),
                                                              height: 1.0,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          )
                                                        ],
                                                      ),
                                                      //SI ESTA VARIABLE ES IGUAL A 1 ES QUE SE ESTA ATENDIENDO
                                                      controllerClient
                                                                      .clientsScheduledList[
                                                                          index]
                                                                      .attended ==
                                                                  1 ||
                                                              controllerClient
                                                                      .clientsScheduledList[
                                                                          index]
                                                                      .attended ==
                                                                  11 ||
                                                              controllerClient
                                                                      .clientsScheduledList[
                                                                          index]
                                                                      .attended ==
                                                                  111
                                                          ? Column(
                                                              children: [
                                                                const Image(
                                                                  image:
                                                                      AssetImage(
                                                                    'assets/images/client-attended.png',
                                                                  ),
                                                                  width: 50,
                                                                  height: 50,
                                                                ),
                                                                Text(
                                                                  controllerClient
                                                                              .clientsScheduledList[index]
                                                                              .attended ==
                                                                          1
                                                                      ? 'Atendiendose'
                                                                      : 'Terminando Servicio',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: controllerClient.clientsScheduledList[index].attended ==
                                                                            1
                                                                        ? const Color(
                                                                            0xFFFDAE2A)
                                                                        : const Color(
                                                                            0xFF19CF9E),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : controllerClient
                                                                          .clientsScheduledList[
                                                                              index]
                                                                          .attended ==
                                                                      4 ||
                                                                  controllerClient
                                                                          .clientsScheduledList[
                                                                              index]
                                                                          .attended ==
                                                                      5
                                                              ? const Row(
                                                                  //todo 999
                                                                  children: [
                                                                    Opacity(
                                                                      opacity:
                                                                          1,
                                                                      child:
                                                                          Image(
                                                                        image:
                                                                            AssetImage(
                                                                          'assets/images/icons/lavado.png',
                                                                        ),
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : controllerClient
                                                                          .clientsScheduledList[
                                                                              index]
                                                                          .attended ==
                                                                      3
                                                                  ? const Column(
                                                                      children: [
                                                                        Text(
                                                                          'Esperando',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(0xFFFF6750)),
                                                                        ),
                                                                        Text(
                                                                            'confirmación de',
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Color(0xFFFF6750))),
                                                                        Text(
                                                                            'Eliminación',
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Color(0xFFFF6750))),
                                                                      ],
                                                                    )
                                                                  : const Row(
                                                                      //todo 999
                                                                      children: [
                                                                        Opacity(
                                                                          opacity:
                                                                              1,
                                                                          child:
                                                                              Icon(
                                                                            Icons.play_circle,
                                                                            size:
                                                                                60,
                                                                            color: Color.fromARGB(
                                                                                85,
                                                                                83,
                                                                                82,
                                                                                82),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                    ],
                                                  ),
                                                  //subtitle: Text(controllerClient.users[index].username.toString()),
                                                  selected: false,
                                                  //selectedColor: Colors.amber,
                                                  //selectedTileColor: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.assignment_ind_sharp),
                                              Text(
                                                'No hay ningún cliente para hoy',
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              )),
                  ),
                  //
                  //
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  //
  //
  //
  //
  void _mostrarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xff123456), // Color de fondo del Bottom Sheet
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Color(
                    0xFFFDAE2A), // Color de fondo del encabezado dentro del Bottom Sheet
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Encabezado Naranja',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(
                        255, 122, 121, 121), // Color del texto del encabezado
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Contenido del Bottom Sheet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(
                        0xffffffff), // Este es blanco, pero puedes cambiarlo como desees
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//****************************************************************************** */
//****************************************************************************** */
