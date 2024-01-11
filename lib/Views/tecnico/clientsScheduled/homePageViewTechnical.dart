//****************************************************************************** */
//****************************************************************************** */
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/products-services/servicesProductsPage.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/professional/shoppingCartPage.dart';
import 'package:turnopro_apk/Views/tecnico/clientsScheduled/modalHelperClientTechnical.dart';

class HomePageViewTechnical extends StatefulWidget {
  const HomePageViewTechnical({super.key});

  @override
  YourPageViewScreenState createState() => YourPageViewScreenState();
}

class YourPageViewScreenState extends State<HomePageViewTechnical> {
  final ClientsTechnicalController clientsScheduledController =
      Get.find<ClientsTechnicalController>();
  final LoginController controllerLogin = Get.find<LoginController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  @override
  void initState() {
    super.initState(); //todo REVISAR valor fijo
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
                Center(
                  child: GetBuilder<ClientsTechnicalController>(
                    builder: (clientsScheduledController) =>
                        clientsScheduledController.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 241, 130, 84),
                              ))
                            :
                            //AQUI VERIFICO QUE SE ESTE CONECTANDO AL SERVIDOR
                            clientsScheduledController.correctConnection == true
                                ? Column(
                                    children: [
                                      Container(
                                        color: const Color(0xFFF18254),
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .padding
                                                .top),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 70,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        'Mis Clientes(Técnico)',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
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
                                      clientsScheduledController
                                                  .clientsTechnicalLength >
                                              0
                                          ? Expanded(
                                              flex: 18,
                                              child: ListView.builder(
                                                itemCount:
                                                    clientsScheduledController
                                                        .clientsTechnicalLength,
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
                                                    decoration: clientsScheduledController
                                                            .selectclientsScheduledListTechnical
                                                            .contains(
                                                                clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                    index])
                                                        ? BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.01),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            12)),
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
                                                            gradient:
                                                                const LinearGradient(
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
                                                            border: clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .attended ==
                                                                    5
                                                                ? Border.all(
                                                                    width: 2,
                                                                    color: const Color(
                                                                        0xFFF18254))
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
                                                        // aqui digo que estoy mostrando los servicios de un cliente para que no se actualice la cola en ese momento
                                                        clientsScheduledController
                                                            .showingServiceClientTechnical(
                                                                true);
                                                        // aqui selecciono el cliente
                                                        clientsScheduledController
                                                            .getselectCustomerTechnical(
                                                                index,
                                                                clientsScheduledController
                                                                    .clientsScheduledListTechnical[
                                                                        index]
                                                                    .car_id);
                                                        //AQUI MANDO ID DE CARRO PAR ACARGAR EL CARRITO PARA LOS SERVICIO Y PRODUCTOS
                                                        //Y SE ACTUALIZA LA VARIABLE GLOBAL carIdClienteSelect
                                                        clientsScheduledController
                                                            .selectCarClient(
                                                                clientsScheduledController
                                                                    .clientsScheduledListTechnical[
                                                                        index]
                                                                    .car_id);
                                                        //AQUI MANDO EL ID DE RESERVACION Y ME DEVUELVE EL ESTADO DEL CLIENTE,
                                                        //SI SE ESTA ATENDINEDO O NO , PARA ASI SABER CUANDO MOSTRAR LOS BOTONES DE ATENDIDO Y
                                                        //SELECCIONAR SERVICIO Y PRODUCTOS
                                                        clientsScheduledController
                                                            .returnClientStatus(
                                                                clientsScheduledController
                                                                    .clientsScheduledListTechnical[
                                                                        index]
                                                                    .reservation_id);
                                                        //AQUI MANDO EL NOMBRE PARA PONERLO DE TITULO DE LA PAGINA DE SERVICE Y PRODUCT
                                                        clientsScheduledController
                                                            .returnClientName(
                                                                (clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .client_name)
                                                                    .toString());

                                                        clientsScheduledController
                                                            .searchForCustomerServices(
                                                                clientsScheduledController
                                                                    .clientsScheduledListTechnical[
                                                                        index]
                                                                    .car_id)
                                                            .then((_) {
                                                          ModalHelperTecnical.showModalTechnical(
                                                              pagesConfigC
                                                                  .pageController,
                                                              context,
                                                              clientsScheduledController
                                                                  .clientsScheduledListTechnical[
                                                                      index]
                                                                  .client_name,
                                                              clientsScheduledController
                                                                  .clientsScheduledListTechnical[
                                                                      index]
                                                                  .reservation_id,
                                                              clientsScheduledController
                                                                  .clientsScheduledListTechnical[
                                                                      index]
                                                                  .car_id);
                                                        });
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
                                                              clientsScheduledController
                                                                      .selectclientsScheduledListTechnical
                                                                      .contains(
                                                                          clientsScheduledController
                                                                              .clientsScheduledListTechnical[index])
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
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              150,
                                                                              37,
                                                                              19),
                                                                        ),
                                                                        Text(
                                                                          'Tiempo Total: ${clientsScheduledController.clientsScheduledListTechnical[index].total_time}',
                                                                          // AQUI CARHA LA HORA INICIAL,
                                                                          style: const TextStyle(
                                                                              height: 1.0,
                                                                              fontSize: 12,
                                                                              color: Color.fromARGB(255, 150, 37, 19),
                                                                              fontWeight: FontWeight.bold),
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
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              71,
                                                                              143,
                                                                              43),
                                                                        ),
                                                                        Text(
                                                                          '  ${clientsScheduledController.clientsScheduledListTechnical[index].start_time}'
                                                                          ' - '
                                                                          ' ${clientsScheduledController.clientsScheduledListTechnical[index].final_hour}',
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
                                                                clientsScheduledController
                                                                    .clientsScheduledListTechnical[
                                                                        index]
                                                                    .client_name,
                                                                //AQUI EL NOMBRE DEL CLIENTE
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              const Text(
                                                                'Barbero: (Nombre del Barbero)',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  height: 1.0,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              )
                                                            ],
                                                          ),
                                                          clientsScheduledController
                                                                  .selectclientsScheduledListTechnical
                                                                  .contains(
                                                                      clientsScheduledController
                                                                              .clientsScheduledListTechnical[
                                                                          index])
                                                              ? const Row(
                                                                  children: [
                                                                    Opacity(
                                                                      opacity:
                                                                          1,
                                                                      child:
                                                                          Icon(
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
                                                              clientsScheduledController
                                                                          .clientsScheduledListTechnical[
                                                                              index]
                                                                          .attended ==
                                                                      5
                                                                  ? const Column(
                                                                      children: [
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
                                                                        Text(
                                                                          'Atendiendose',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFF18254),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : const Row(
                                                                      //todo 99
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
                                                      //subtitle: Text(clientsScheduledController.users[index].username.toString()),
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
                                                  Icon(Icons
                                                      .assignment_ind_sharp),
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
