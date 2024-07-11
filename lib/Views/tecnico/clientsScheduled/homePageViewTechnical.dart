//****************************************************************************** */
//****************************************************************************** */
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 18,
                                      child:
                                          //AQUI CONTROLO SI HAY CLIENTES EN COLA LOS MUESTRO , SINO MUESTRO UN MENSAJE
                                          clientsScheduledController
                                                      .clientsTechnicalLength >
                                                  0
                                              ? ListView.builder(
                                                  padding: EdgeInsets
                                                      .zero, // Elimina cualquier padding del ListView
                                                  itemCount:
                                                      clientsScheduledController
                                                          .clientsTechnicalLength,
                                                  itemBuilder:
                                                      (context, index) {
                                                    String tipo = '';
                                                    if (clientsScheduledController
                                                            .clientsScheduledListTechnical[
                                                                index]
                                                            .from_home ==
                                                        1) {
                                                      tipo = 'Reser';
                                                    } else if (clientsScheduledController
                                                            .clientsScheduledListTechnical[
                                                                index]
                                                            .select_professional ==
                                                        1) {
                                                      tipo = 'Selec';
                                                    } else {
                                                      tipo = 'Aleat';
                                                    }
                                                    return Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.013),
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.006),
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.013),
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.006)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 2,
                                                              color: clientsScheduledController
                                                                          .clientsScheduledListTechnical[
                                                                              index]
                                                                          .from_home ==
                                                                      1
                                                                  ? const Color(
                                                                      0xFFFDAE2A)
                                                                  : clientsScheduledController
                                                                              .clientsScheduledListTechnical[
                                                                                  index]
                                                                              .select_professional ==
                                                                          1
                                                                      ? const Color(
                                                                          0xFF19CF9E)
                                                                      : const Color(
                                                                          0xFF4470F3)),
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
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  12),
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            /*
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
                                                                      .reservation_id!);
                                                          //AQUI MANDO EL NOMBRE PARA PONERLO DE TITULO DE LA PAGINA DE SERVICE Y PRODUCT
                                                          clientsScheduledController.returnClientName(
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
                                                            ModalHelperTecnical
                                                                .showModalTechnical(
                                                                    //todo 1
                                                                    pagesConfigC
                                                                        .pageController,
                                                                    context,
                                                                    clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .client_name!,
                                                                    clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .reservation_id!,
                                                                    clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .car_id!,
                                                                    clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .professional_id!);
                                                          });
                                                          
                                                          */
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
                                                                        ' ${clientsScheduledController.clientsScheduledListTechnical[index].final_hour}  $tipo',
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
                                                                        .client_name!,
                                                                    //AQUI EL NOMBRE DEL CLIENTE
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    clientsScheduledController
                                                                        .clientsScheduledListTechnical[
                                                                            index]
                                                                        .professional_name!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              148,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      height:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  )
                                                                ],
                                                              ), //SI ESTA VARIABLE ES IGUAL A 1 ES QUE SE ESTA ATENDIENDO
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
                                                                                Color(0xFFFDAE2A),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : clientsScheduledController
                                                                              .clientsScheduledListTechnical[index]
                                                                              .attended ==
                                                                          33
                                                                      ? const Column(
                                                                          children: [
                                                                            Image(
                                                                              image: AssetImage(
                                                                                'assets/images/icons/lavado.png',
                                                                              ),
                                                                              width: 50,
                                                                              height: 50,
                                                                            ),
                                                                            Text(
                                                                              'Solicitud rechazo',
                                                                              style: TextStyle(
                                                                                color: Color(0xFFFF6750),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container()
                                                            ],
                                                          ),
                                                          //subtitle: Text(clientsScheduledController.users[index].username.toString()),
                                                          selected: false,
                                                          //selectedColor: Colors.amber,
                                                          //selectedTileColor: Colors.blue,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'No hay cliente en espera',
                                                    ),
                                                  ],
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
