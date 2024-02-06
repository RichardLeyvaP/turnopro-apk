//****************************************************************************** */
//****************************************************************************** */

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\currentPageIndex:${pagesConfigC.currentPageIndex}');
    return Scaffold(
      // appBar: pagesConfigC.currentPageIndex == 0
      //     ? AppBar(
      //         leading: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             IconButton(
      //               icon: const Icon(Icons.arrow_back),
      //               onPressed: () {
      //                 pagesConfigC.back();

      //                 // Navigator.pop(context);
      //               },
      //             ),
      //           ],
      //         ),
      //         title: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Column(
      //               children: [
      //                 Icon(
      //                   Icons.person,
      //                   size: 70,
      //                 ),
      //                 Text(
      //                   'Mis Clientes',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.w700, fontSize: 20),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               width: (MediaQuery.of(context).size.width * 0.14),
      //             ),
      //           ],
      //         ),
      //         //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      //         elevation: 0, // Quits the shadow
      //         //shadowColor: Colors.amber, // Removes visual elevation
      //       )
      //     : null,
      body: Column(
        children: [
          //todo esto de abajo son botones para manejar el desplazamiento de las paginas y hacer o no scroll
          // Row(
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           isPageViewEnabled = !isPageViewEnabled;
          //         });
          //       },
          //       child:
          //           Text(isPageViewEnabled ? 'Deshab Scroll' : 'Habili Scroll'),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           // Cambiar a la siguiente página.
          //           _pageController.nextPage(
          //             duration: Duration(milliseconds: 300),
          //             curve: Curves.ease,
          //           );
          //         },
          //         child: Text('Siguiente Página'),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         // Cambiar a la siguiente página.
          //         _pageController.previousPage(
          //           duration: Duration(milliseconds: 1000),
          //           curve: Curves.fastOutSlowIn,
          //         );
          //       },
          //       child: Text('Atras'),
          //     ),
          //   ],
          // ),
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
                Center(
                  child: GetBuilder<ClientsScheduledController>(
                    builder: (controllerClient) => controllerClient.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 241, 130, 84),
                          ))
                        :
                        //AQUI VERIFICO QUE SE ESTE CONECTANDO AL SERVIDOR
                        controllerClient.correctConnection == true
                            ? Column(
                                children: [
                                  Container(
                                    color: const Color(0xFFF18254),
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

                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                                        4
                                                    ? BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.01),
                                                        borderRadius:
                                                            const BorderRadius.all(
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
                                                    : controllerClient
                                                            .selectClientsScheduledList
                                                            .contains(
                                                                controllerClient
                                                                        .clientsScheduledList[
                                                                    index])
                                                        ? BoxDecoration(
                                                            border: Border.all(width: 0.01),
                                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.7),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: const Offset(
                                                                    -5,
                                                                    5), // Ajusta los valores para personalizar la sombra
                                                              ),
                                                            ],
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                Color.fromARGB(
                                                                    255,
                                                                    231,
                                                                    232,
                                                                    234),
                                                                Color.fromARGB(
                                                                    255,
                                                                    243,
                                                                    182,
                                                                    138),
                                                              ],
                                                              stops: [0.0, 0.8],
                                                              begin: FractionalOffset
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
                                                                    color: controllerClient.clientsScheduledList[index].attended ==
                                                                            1
                                                                        ? const Color(
                                                                            0xFFF18254)
                                                                        : const Color.fromARGB(
                                                                            255,
                                                                            17,
                                                                            179,
                                                                            38))
                                                                : Border.all(
                                                                    width:
                                                                        0.01),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
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
                                                              Radius.circular(
                                                                  12),
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

                                                    if (controllerClient
                                                            .clientsScheduledList[
                                                                index]
                                                            .attended !=
                                                        4) {
                                                      // aqui digo que estoy mostrando los servicios de un cliente para que no se actualice la cola en ese momento
                                                      controllerClient
                                                          .showingServiceClient(
                                                              true);
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
                                                      controllerClient
                                                          .returnClientStatus(
                                                              controllerClient
                                                                  .clientsScheduledList[
                                                                      index]
                                                                  .reservation_id);
                                                      //AQUI MANDO EL NOMBRE PARA PONERLO DE TITULO DE LA PAGINA DE SERVICE Y PRODUCT
                                                      controllerClient
                                                          .returnClientName(
                                                              (controllerClient
                                                                      .clientsScheduledList[
                                                                          index]
                                                                      .client_name)
                                                                  .toString());

                                                      controllerClient
                                                          .searchForCustomerServices(
                                                              controllerClient
                                                                  .clientsScheduledList[
                                                                      index]
                                                                  .car_id)
                                                          .then((_) {
                                                        String clientName =
                                                            controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .client_name;
                                                        int reservationId =
                                                            controllerClient
                                                                .clientsScheduledList[
                                                                    index]
                                                                .reservation_id;
                                                        int carId = controllerClient
                                                            .clientsScheduledList[
                                                                index]
                                                            .car_id;
                                                        ModalHelper.showModal(
                                                            pagesConfigC
                                                                .pageController,
                                                            context,
                                                            clientName,
                                                            reservationId,
                                                            carId);
                                                      });
                                                    }
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
                                                          controllerClient
                                                                  .selectClientsScheduledList
                                                                  .contains(
                                                                      controllerClient
                                                                              .clientsScheduledList[
                                                                          index])
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      MdiIcons
                                                                          .formatListNumbered, //todo
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          150,
                                                                          37,
                                                                          19),
                                                                    ),
                                                                    Text(
                                                                      'Tiempo Total: ${controllerClient.clientsScheduledList[index].total_time}',
                                                                      // AQUI CARHA LA HORA INICIAL,
                                                                      style: const TextStyle(
                                                                          height:
                                                                              1.0,
                                                                          fontSize:
                                                                              12,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              150,
                                                                              37,
                                                                              19),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Row(
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
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          71,
                                                                          143,
                                                                          43),
                                                                    ),
                                                                    Text(
                                                                      '  ${controllerClient.clientsScheduledList[index].start_time}'
                                                                      ' - '
                                                                      ' ${controllerClient.clientsScheduledList[index].final_hour}',
                                                                      // '   08:10 - 09:10',
                                                                      style:
                                                                          const TextStyle(
                                                                        height:
                                                                            1.0,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color.fromARGB(
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
                                                                .client_name,
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
                                                      controllerClient
                                                              .selectClientsScheduledList
                                                              .contains(
                                                                  controllerClient.clientsScheduledList[
                                                                      index])
                                                          ? Row(
                                                              children: [
                                                                Opacity(
                                                                  opacity: 1,
                                                                  child: controllerClient
                                                                          .isLoading
                                                                      ? const CircularProgressIndicator(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              241,
                                                                              130,
                                                                              84),
                                                                          strokeWidth:
                                                                              4,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .play_circle,
                                                                          size:
                                                                              60,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              150,
                                                                              37,
                                                                              19),
                                                                        ),
                                                                ),
                                                              ],
                                                            )
                                                          : //SI ESTA VARIABLE ES IGUAL A 1 ES QUE SE ESTA ATENDIENDO
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
                                                                      height:
                                                                          50,
                                                                    ),
                                                                    Text(
                                                                      controllerClient.clientsScheduledList[index].attended ==
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
                                                                                0xFFF18254)
                                                                            : const Color.fromARGB(
                                                                                255,
                                                                                71,
                                                                                143,
                                                                                43),
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
                                                                              .clientsScheduledList[index]
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      'assets/images/icons/error-connection.png',
                                    ),
                                  ),
                                  Text(
                                      'Lo sentimos, hay problemas de conexión...'),
                                ],
                              ),
                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//****************************************************************************** */
//****************************************************************************** */
